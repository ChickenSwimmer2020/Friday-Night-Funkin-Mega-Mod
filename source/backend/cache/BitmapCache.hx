package backend.cache;

import sys.thread.Thread;
import openfl.display.BitmapData;
import haxe.io.Path;
import backend.cache.CacheFileMgr.CacheStatus;

class Pixel {
    public var x:Int;
    public var y:Int;
    public var color:Int;

    public function new(x:Int, y:Int, color:Int)
    {
        this.x = x;
        this.y = y;
        this.color = color;
    }

    public function toString():String
        return '$x|$y|$color';
}

class BitmapBuffer {
    public var width:Int;
    public var height:Int;
    public var pixels:Array<Pixel> = [];

    public function new()
        return;

    public function add(pixel:Pixel):Int
    {
        if (!pixels.contains(pixel)){
            pixels.push(pixel);
            return 0;
        }
        return 1;
    }
        
    public function toString():String {
        // Convinience..
        inline function str(v:Dynamic):String
            return Std.string(v);

        // Variable initialization
        var regionSeperator = BitmapCache.regionSeperator;
        var sectionSeperator = BitmapCache.sectionSeperator;
        var innerSectionSeperator = BitmapCache.innerSectionSeperator;
        var strBuf:StringBuf = new StringBuf();

        // Buffer header
        inline function addPropertyToHeader(property:Dynamic)
        {
            strBuf.add(str(property));
            strBuf.add(sectionSeperator);
        }
        addPropertyToHeader(width);
        addPropertyToHeader(height);

        // Next region
        strBuf.add(regionSeperator);
        strBuf.add(sectionSeperator);

        // Pixel Data
        inline function addPixelDataToBody(pixel:Pixel)
        {
            strBuf.add(str(pixel.x));
            strBuf.add(innerSectionSeperator);
            strBuf.add(str(pixel.y));
            strBuf.add(innerSectionSeperator);
            strBuf.add(str(pixel.color));
        }

        for (pixel in pixels)
        {
            addPixelDataToBody(pixel);
            strBuf.add(sectionSeperator);
        }

        return strBuf.toString();
    }
}

class BitmapCache {
    public static var regionSeperator:String = '!!';
    public static var sectionSeperator:String = '|';
    public static var innerSectionSeperator:String = '*';
    public static function writeBitmapDataToFile(data:BitmapData, targetPath:Path, fileName:String, ?multithreaded:Bool = true):CacheStatus
    {
        var buffer:BitmapBuffer = new BitmapBuffer();
        try{
            buffer.width = data.width;
            buffer.height = data.height;
            if (multithreaded){
                Thread.create(() -> {
                    for (x in 0...data.width){
                        for (y in 0...data.height)
                        {
                            var pixel:Pixel = new Pixel(x, y, data.getPixel32(x, y));
                            if (buffer.add(pixel) != 0)
                                break;
                        }
                    }
                });
            }else{
                for (x in 0...data.width){
                    for (y in 0...data.height)
                    {
                        var pixel:Pixel = new Pixel(x, y, data.getPixel32(x, y));
                        buffer.add(pixel);
                    }
                }
            }

            trace(buffer.toString());
        }catch(e)
            return new CacheStatus(1, null, e);

        return new CacheStatus(0, buffer);
    }
}