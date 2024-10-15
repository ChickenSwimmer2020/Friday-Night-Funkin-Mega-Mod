package backend.util;

import psychlua.FunkinLua;

class Functions
{
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

			@param songname the song name to load, straight song name.
	**/
	inline static public function loadSongLuaFile(songname:String)
	{
		for (folder in Mods.internalDirectoriesWithFile(Paths.getSharedPath(), 'data/lua/' + songname + '-data'))
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.toLowerCase().endsWith('.lua'))
					new FunkinLua(folder + file);
				trace(folder + file);
			}
	}

	/**
		easy loading of additional lua files.

			@param songname file name
	**/
	inline static public function loadLooseLuaFile(filename:String)
	{
		for (folder in Mods.internalDirectoriesWithFile(Paths.getSharedPath(), 'data/lua/' + filename))
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.toLowerCase().endsWith('.lua'))
					new FunkinLua(folder + file);
			}
	}
}
