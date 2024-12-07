package backend;

import openfl.Assets;
import psychlua.FunkinLua;

class Functions
{
    public static var LuaState:State;
	/**
		custom timer function for easy timer creation.

			@param Time the time to wait for

			@param onComplete what to do after function is finished
	**/
	inline static public function wait(Time:Float, onComplete:() -> Void):FlxTimer
		return new FlxTimer().start(Time, (_) ->
		{
			onComplete();
		});

	/**
		easy loading of song specific data files.

			@param file File name
	**/
	static public function loadExternalScriptFile(file:String)
		return new FunkinLua(Paths.getSharedPath('lua/${file}.lua'));
}