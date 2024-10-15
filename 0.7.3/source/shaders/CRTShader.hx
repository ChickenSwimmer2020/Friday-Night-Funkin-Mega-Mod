package shaders;

import flixel.addons.display.FlxRuntimeShader;

class CRTShader extends FlxRuntimeShader
{
	override public function new():Void
	{
		glFragmentSource = '
                // Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform)
	{
		return color;
	}
	if (color.a == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	if (!hasColorTransform)
	{
		return color * openfl_Alphav;
	}
	color = vec4(color.rgb / color.a, color.a);
	mat4 colorMultiplier = mat4(0);
	colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	if (color.a > 0.0)
	{
		return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}
	return vec4(0.0, 0.0, 0.0, 0.0);
}

// variables which is empty, they need just to avoid crashing shader
uniform float iTimeDelta;
uniform float iFrameRate;
uniform int iFrame;
#define iChannelTime float[4](iTime, 0., 0., 0.)
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
uniform vec4 iMouse;
uniform vec4 iDate;

// THE BLOOM ON LINE 137 is from FMS_Cat !! 


#define R (iResolution.xy)
#define T(U) texture(iChannel0,(U)/R)
#define Tn(U,mip) texture(iChannel0,(U),mip)

vec4 noise(float t){return texture(iChannel0,vec2(floor(t), floor(t))/256.);}
vec4 valueNoise(vec2 t, float w){
    vec2 fr = fract(t);
	return 
        mix(
            mix( 
                texture(iChannel1,vec2(floor(t.x), floor(t.y))/256.),
                texture(iChannel1,vec2(floor(t.x), floor(t.y) + 1.)/256.),
            	smoothstep(0.,1.,fr.y)
            ),
            mix( 
                texture(iChannel1,vec2(floor(t.x) + 1.,floor(t.y))/256.),
                texture(iChannel1,vec2(floor(t.x) + 1.,floor(t.y) + 1.)/256.),
            	smoothstep(0.,1.,fr.y)
            ),
            smoothstep(0.,1.,pow(fr.x, w)));
}
vec4 fbm(vec2 uv){
	vec4 n = vec4(0);
    n += valueNoise(uv*800.,0.1);
    n += valueNoise(uv*1700.,0.1)*0.5;
    n -= valueNoise(uv*10.,1.)*1.;
    n -= valueNoise(uv*20.,0.5)*0.5;
    //n = max(n, 0.);
    
    n = smoothstep(0.,1.,n);
    return n;
}



float eass(float p, float g) {
    float s = p*0.45;
    for(float i = 0.; i < g; i++){
    	s = smoothstep(0.,1.,s);
    }
    return s;
}


void mainImage( out vec4 C, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    
    vec2 nuv = (fragCoord - 0.5*iResolution.xy)/iResolution.y;
    
    vec2 offs = vec2(cos(iTime*0.5),sin(iTime*0.9))*0.04;
    uv += offs;
    nuv += offs;
    vec2 bentuv = nuv * (1. - smoothstep(1.,0.,dot(nuv,nuv)*0.2)*0.4);
    
    bentuv *= 1.7;
    
    
    float df = dFdx(uv.x);
    float amt = (dot(nuv,nuv) + 0.1)*2.*(1.04-eass((iTime)/3.,3.));
    
    float env = eass(iTime*1.,3.);
    float envb = eass((iTime - 2.)*0.4,2.);
    float envc = eass((iTime - 4.)*1.,2.);
    float envd = eass((iTime - 9.)*1.,2.);
    
    
    vec4 nA = fbm(uv*0.02 + iTime*(20.));
    vec4 nB = fbm(vec2(1. + iTime*0.3 + sin(iTime)*0.1,uv.y*0.42));
    vec4 nC = valueNoise(vec2( iTime,uv.y),0.5);
    vec4 nD = valueNoise(vec2( iTime*50.,uv.y),0.5);
    vec4 nE = fbm(vec2(uv.x*0.02,iTime));
    vec4 nF = fbm(vec2(uv.x*1.0,mod(iTime*200.,2000.)));
    vec4 nG = fbm(vec2(uv.x,uv.y + mod(iTime,2000.)));
    vec4 nT = valueNoise(vec2( iTime),0.5);
    
    float glitch = 0.;
    glitch += pow(nB.x,0.5)*0.005 + nB.y*0.005;
    glitch *= 1.;
    uv.x += glitch*0.1;
    
    
    //+ float ( 0. == floor(fract(uv.y*iResolution.y/8.)*2.) ) 
    
    float slidey = smoothstep(0.01,0.,abs(uv.y - nC.x*1.4) - 0.1 + nE.x*0.06);
    
    
    slidey *= smoothstep(0.,df*(224.2 ),abs(nuv.x + R.x/R.y*0.5 - 0.01) - 0.004);
    
    
    glitch += slidey*0.002;
    uv.x += slidey*(pow(nC.y,0.01)*0.004 + 0.001);
    
    
    uv.x += 0.1*pow(nB.x,2.)*smoothstep(df*(4.2 ),0.,(abs(nuv.x + R.x/R.y*0.5 - 0.01) - 0.004 )*0.2);
    
    uv.x += pow(nB.x,2.)*0.007;
    
    C += smoothstep(df*(1. + nE.y*2.2),0.,abs(uv.y  + nC.x*.02 + 0.1 - 2.*nD.y*float(nC.z>0.4)) + nE.x*0.04 - (nE.y*0.01))*(0.5*nE.y );
    
    
    
    if(nA.x*nA.z > 0.1 - 0.0009*sin(iTime) ){
        glitch += 0.01;
        uv += 0.02;
    }
    if(nB.x*nB.y > 0.1 - envc*0.10001){
        
        //glitch += envc*0.;
        //uv += 0.1 + iTime;
    }
    
    
    
    
    
    float mip = 0.5 + nG.x*5.;
    
    float iters = 20.;
    
    vec3 chrab = vec3(0);
    vec2 chruv = uv;
    vec2 dir = vec2(1.,0.);
    amt *= 1.;
    amt += glitch*224.4;
    for(float i = 0.; i < iters; i++){
        //uv.x += 0.01;
        float slider = i/iters;
        chrab.r += Tn(uv + amt*dir*0.004*slider,mip).r;
        chrab.g += Tn(uv + -amt*dir*0.01*slider,mip).g;
        chrab.b += Tn(uv + amt*dir*0.01*slider,mip).b;
    }
    
    chrab /= iters;
    vec3 bloom = vec3(0);
      for( float x = -1.0; x < 2.5; x += 1.0 ){
        bloom += vec3(
          Tn( uv + vec2( x - 0.0, 0.0 ) * 7E-3, mip).x,
          Tn( uv + vec2( x - 1.0 + sin(iTime), 0.0 ) * 7E-3,mip ).y,
          Tn( uv + vec2( x - 4.0 - sin(iTime*4.), 0.0 ) * 7E-3, mip ).z
        );
      }
    bloom/=iters;
    
    C.rgb += mix(chrab,bloom,0.5);
    
    
    C = mix(C,vec4(1),(smoothstep(0.5,0.41,pow(nT.x,0.9)) + 0.02)*pow(smoothstep(0.6,0.,valueNoise( uv*190. + vec2(0,nA.x*30. + pow(nB.y, 0.01)*70.*nT.y) + mod(iTime*2000.,20000.),1. + 3.*nC.x).x),18. - nT.w*uv.y*17.));
    
    C.rgb = mix(vec3(1),C.rgb,1.);
    
    vec2 bentuvold = bentuv;
    
    float dfbentuv = dFdx(bentuv.x);
    
    bentuv = abs(bentuv);
    float dedges = abs(bentuv.x) - 0.9;
    dedges = max(dedges, bentuv.y - 0.5);
    float edger = 0.1;
    //dedges = max(dedges,-length(bentuv- vec2(R.x/R.y,R.y/R.y)*0.5 + edger) - edger);
    
   // C *= smoothstep(dfbentuv*4.,0.,);
    C *= pow(smoothstep(0.1,0., bentuv.x - R.x/R.y*0.47),1.);
    C *= pow(smoothstep(0.1,0., bentuv.y - R.y/R.y*0.4),1.);
    
    
    C = mix(C, Tn(uv + 0.2,2.)*0.01,1.-smoothstep(dfbentuv*4.,0.,dedges));
    
    C *= smoothstep(1.,0.2, 0.3 + 0.2*uv.y*(0.7 + nD.x));
    C *= pow(smoothstep(1.,0., dot(nuv*0.6,nuv)),1.);
    
    bentuvold -= vec2(0.3,0.1);
    
    C += pow(smoothstep(1.,0., length(bentuvold) - 0.),4.)*0.01*vec4(0.6,0.9,0.9,0.);
    
    
    C = pow(C,vec4(0.4545));

}


void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
                ';
		super();
	}
}
