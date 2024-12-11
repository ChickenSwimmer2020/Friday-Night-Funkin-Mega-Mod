package backend.cache;

import haxe.Exception;
import haxe.io.Path;

class CacheStatus {
    public var code:Int = 0;
    public var exception:Exception;
    public var exData:Dynamic;
    public function new(code:Int, ?exData:Dynamic, ?exception:Exception = null)
    {
        this.code = code;
        this.exData = exData;
        this.exception = exception;
    }
}
