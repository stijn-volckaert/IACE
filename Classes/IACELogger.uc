// =============================================================================
// AntiCheatEngine - (c) 2009-2019 AnthraX
// =============================================================================
class IACELogger extends StatLogFile;

// =============================================================================
// Variables
// =============================================================================
var bool bClosing;

// =============================================================================
// OpenACELog ~ Make logfile and open it
// =============================================================================
function OpenACELog(string LogPath, string LogPrefix, optional string PlayerName)
{
    local string FileName;
    local string str, str2;
    local int i;

    str = Level.Game.GameReplicationInfo.ServerName;
    str = str $ "_" $ GetShortAbsoluteTime();
    str = str $ "_" $ Left(Level.Game, InStr(Level.Game, "."));
    if (PlayerName != "") str = str $ "_" $ PlayerName;
    str2 = "";
    for (i = 0; i<Len(Str); i++)
        if (asc(Mid(str, i, 1)) < 32 || asc(Mid(str, i, 1)) > 127 || InStr("\\/*?:<>\"|", Mid(str, i, 1)) != -1)
            str2 = str2 $ "_";
        else
            str2 = str2 $ Mid(str, i, 1);

    FileName = LogPath$LogPrefix$" - "$str2;
    StatLogFile = FileName$".tmp";
    StatLogFinal = FileName$".log";
    OpenLog();
}

// =============================================================================
// ACELog ~ Log string and flush the log
// =============================================================================
function ACELog(string LogString)
{
    FileLog(LogString);
    FileFlush();
}

// =============================================================================
// CloseACELog ~ Flush and close log
// =============================================================================
function CloseACELog()
{
    if (!bClosing)
    {
        bClosing = true;
        FileFlush();
        CloseLog();
    }
}

// =============================================================================
// Timer ~ Disabled
// =============================================================================
function Timer() {}

// =============================================================================
// Destroyed ~ Make sure that the log is closed
// =============================================================================
event Destroyed()
{
    CloseACELog();
}

// =============================================================================
// defaultproperties
// =============================================================================
defaultproperties
{
    StatLogFile="./ACE.log"
}