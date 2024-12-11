package backend.utils;

import openfl.system.System;
import openfl.Assets;
import flixel.util.typeLimit.OneOfTwo;

enum AssetType {
    SOUND;
    IMAGE;
    ATLAS;
}

class Cache {
    public static var menuImageFolders:Array<String> = [
        '', // Blank because of the images folder
        'TitleScreen',
        'OptionsMenu',
        'storymenu',

        // Main Menu folders
        'MainMenu',
        'MainMenu/Sketches',
        'MainMenu/Enters',
    ];

    // Static caching functions //
    public static function cacheFolderAssets(parentFolder:String = 'assets', ?inShared:Bool = true, ?folder:String = 'images', ?subFolder:String = '', ?type:AssetType = IMAGE, ?ext:String = 'png', ?exclude:String = '')
    {
        var subPath = subFolder != '' ? '$subFolder/' : '';
        var files = FileSystem.readDirectory('assets/${(inShared ? 'shared/' : '')}$folder/$subPath');
        for (file in files) {
            if (file.endsWith('.$ext')){
                var file = file.substring(0, file.length - 4);
                var realFile = '$subPath/$file';
                if (!file.contains(exclude) && exclude != '')
                    cacheBasicAsset(realFile, type);
            }
        }
    }

    public static function cacheBasicAsset(file:String, type:AssetType)
    {
        switch (type)
        {
            case SOUND:
                // Making sure it isn't wasting time caching an already cached asset 😇
                if (!Paths.currentTrackedAssets.exists(file)) 
                    Paths.returnSound(file);
            case IMAGE:
                // getAtlas might have already cached our image, no point in caching it again.
                if (!Paths.currentTrackedAssets.exists(file)) 
                    Paths.image(file);
            case ATLAS:
                Paths.getAtlas(file);
        }
    }

    /**
     * A vigorous cleaning is in order:
     * 
     * Removes literally *every single asset* that is currently cached.
     * This is an unsafe operation, and should only be used when reloading the games assets.
     */
    public static function clearCache()
    {
        // A vigorous cleaning is in order.
        Assets.cache.clear();
        @:privateAccess FlxG.bitmap._cache.clear();
        Main.resetSpriteCache(FlxG.game);
        Paths.localTrackedAssets.clear();
        Paths.currentTrackedAssets.clear();
        Paths.currentTrackedSounds.clear();
        System.gc();
    }

    // Instanced caching functions //
    public var prog = 0;
    public var targetProg = 0;
    public var caching:Bool = false;
    public function new()
        return;

    public function cacheMenuAssets()
    {
        inline function cacheFolderAssets(parentFolder:String = 'assets', ?inShared:Bool = true, ?folder:String = 'images', ?subFolder:String = '', ?type:AssetType = IMAGE, ?ext:String = 'png', ?exclude:String = '')
        {
            var subPath = subFolder != '' ? '$subFolder/' : '';
            trace(subPath);
            var files = FileSystem.readDirectory('assets/${(inShared ? 'shared/' : '')}$folder/$subPath');
            trace('assets/${(inShared ? 'shared/' : '')}$folder/$subPath');
            for (file in files) {
                if (file.endsWith('.$ext')){
                    var fileFile = file.substring(0, file.length - 4);
                    var realFile = '$subPath$fileFile';
                    trace('EXCLUDE: "$exclude" | file: $realFile');
                    inline function cacheAsset(file:String, type:AssetType)
                    {
                        prog++;
                        trace('caching asset: $file | progress: $prog | totalProgress: $targetProg');
                        cacheBasicAsset(file, type);
                    }
                    if (!realFile.contains(exclude) && exclude != '')
                        cacheAsset(realFile, type);
                    else if (exclude == null || exclude == '')
                        cacheAsset(realFile, type);
                }
            }
        }
        inline function cacheImageAssets(type:AssetType, ext:String)
        {
            for (path in menuImageFolders){
                if (path == 'TitleScreen'){
                    trace('caching titleScreen folders');
                    cacheFolderAssets('assets', true, 'images', 'TitleScreen', type, ext, 'DeveloperMode');
                }else{
                    trace('caching normal folders');
                    cacheFolderAssets('assets', true, 'images', path, type, ext);
                }
                
            }
        }
        inline function validPath(path:String)
            return path.endsWith('.png') ? true : path.endsWith('.xml') ? true : false;

        caching = true;
        prog = 0;
        targetProg = 0;
        for (path in menuImageFolders){
            var paths = FileSystem.readDirectory('assets/shared/images/$path');
            for (_path in paths)
                if (!_path.contains('DeveloperMode') && validPath(_path))
                    targetProg++;
        }
        var _:Array<Array<OneOfTwo<AssetType, String>>> = [[ATLAS, 'xml'], [IMAGE, 'png']];
        for (modeID in 0..._.length) 
        {
            var mode = _[modeID];
            trace('mode: $mode');
            cacheImageAssets(mode[0], mode[1]);
        }
        #if debug for (type in [ATLAS, IMAGE]) cacheBasicAsset('TitleScreen/DeveloperMode', type); #end
        caching = false;
    }
}