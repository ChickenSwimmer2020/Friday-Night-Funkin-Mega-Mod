package backend;

import psychlua.FunkinLua;

class Functions
{
    public static var LuaState:State;
	/**
		custom timer function for easy timer creation.

			@param Time the time to wait for

			@param onComplete what to do after function is finished
	**/
	inline public function wait(Time:Float, onComplete:() -> Void):FlxTimer
		return new FlxTimer().start(Time, (_) ->
		{
			onComplete();
		});

	/**
		easy loading of song specific data files.

			@param file file name to load (dont forget the .lua extension)
            @param dir file directory eg:[DIRECTORY]/foldername
	**/
	inline static public function loadExternalScriptFile(file:String, dir:String)
	{
		var dafile = Paths.getFolderPath(file, dir);
		new FunkinLua(dafile);
	}
}