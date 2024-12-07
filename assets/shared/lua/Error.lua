--error handler script to prevent crashes if a song file isnt chosen properly
luaDebugMode = true;

function onSongStart()
    debugPrint('this is an error message.\nThe script file name that you entered was invalid, or the file was missing.\nThis message exists as an error handler to prevent crashes.', 'CHECK FILENAME AND TRY AGAIN');
end