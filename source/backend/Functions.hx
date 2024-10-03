package backend;

import psychlua.FunkinLua;

class Functions
{
    /**
        custom timer function for easy timer creation.

            {>} Time = Time for timer to take

            {>} onComplete = what to do after completion. (write in one line.)
    **/
    inline static public function wait(Time:Int, onComplete:String)
        {
            var Timer:FlxTimer;
            Timer = new FlxTimer();
            Timer.start(Time, function(tmr:FlxTimer)
                {
                    onComplete;
                });
        }
    /**
        easy loading of song specific data files.

            {>} songname = name of song (must be string)
    **/
    inline static public function loadSongLuaFile(songname:String) 
        {
            for (folder in Mods.internalDirectoriesWithFile(Paths.getSharedPath(), 'data/lua/' + songname + '-data'))
                for (file in FileSystem.readDirectory(folder))
                {
                    if(file.toLowerCase().endsWith('.lua'))
                        new FunkinLua(folder + file);
                    trace(folder + file);
                }
        }
    /**
        easy loading of additional lua files.

            {>} filename = name of file.
    **/
	inline static public function loadLooseLuaFile(filename:String) 
        {
            for (folder in Mods.internalDirectoriesWithFile(Paths.getSharedPath(), 'data/lua/' + filename))
                for (file in FileSystem.readDirectory(folder))
                {
                    if(file.toLowerCase().endsWith('.lua'))
                        new FunkinLua(folder + file);
                }
	    }
}