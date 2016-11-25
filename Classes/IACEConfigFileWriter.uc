// =============================================================================
// AntiCheatEngine - (c) 2009-2016 AnthraX
// =============================================================================
class IACEConfigFileWriter extends StatLogFile;

// =============================================================================
// Write ~ Write the ACE.ini file to the specified folder.
// @param Path Folder to write the ACE.ini file to
// @param File IACEConfigFile object to retrieve the settings from.
// @return true when succeeded
// =============================================================================
function bool Write(string Path, IACEConfigFile File)
{
    local string FileName;
    local int i;

    if (Right(Path, 1) == "\\" || Right(Path, 1) == "/")
        Path = Left(Path, Len(Path) - 1);
    FileName = Path $ "/" $ "ACE.ini";

    StatLogFile  = FileName $ ".tmp";
    StatLogFinal = FileName;

    OpenLog();

    for (i = 0; i < 256; ++i)
    {
        if (File.GetName(i) != "")
        {
            FileLog(File.GetName(i) $ "="
                $ File.CastToType(File.GetValue(i), File.GetType(i)));
        }
    }

    FileFlush();
    CloseLog();

    return true;
}