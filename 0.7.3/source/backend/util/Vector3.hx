package backend.util;

import openfl.geom.Vector3D;

class Vector3 extends Vector3D {
    override public function new(x:Float, y:Float, z:Float) {
        super(x, y, z, 0);
    }
}