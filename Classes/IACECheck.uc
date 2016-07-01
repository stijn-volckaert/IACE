// =============================================================================
// AntiCheatEngine BETA 0.9 - (c) 2009-2011 AnthraX
// =============================================================================
// IACECheck: Base class of the ACE native checker
// =============================================================================
class IACECheck extends IACECommon;

// =============================================================================
// Variables
// =============================================================================
var string     PlayerName;          // Name of the player that owns this checker
var string     PlayerIP;            // Ip of the player that owns this checker
var int        PlayerID;            // Id of the player
var string     UTCommandLine;       // Commandline of the application
var string     UTVersion;           // UT Client version
var string     CPUIdentifier;       // CPU Identifier string
var string     CPUMeasuredSpeed;    // CPU Measured speed
var string     CPUReportedSpeed;    // CPU Reported speed - trough the commandline
var string     OSString;            // Full OS Version string
var string     NICName;             // Full name of the primary network interface
var string     MACHash;             // MD5 hash of the primary mac address
var string     UTDCMacHash;         // UTDC compatible hash of the mac address
var string     HWHash;              // MD5 hash of the hardware ID
var string     RenderDeviceClass;   // class of the renderdevice (eg: OpenGLDrv.OpenGLRenderDevice)
var string     RenderDeviceFile;    // DLL file of the renderdevice
var string     SoundDeviceClass;    // class of the sounddevice (eg: OpenAL.OpenALDevice)
var string     SoundDeviceFile;     // DLL file of the sounddevice
var string     KickReason[10];      // For delayed kicks
var bool       bKickPending;        // Kick Pending?
var bool       bTunnel;             // Is the user behind a UDP Proxy/Tunnel?
var string     RealIP;              // RealIP of the player (only set if bTunnel == true)
var bool       bWine;               // Is the client running UT using the Wine Emulator?
var bool       bSShotPending;       // Is a screenshot being sent?
var PlayerPawn SShotRequester;      // Pawn that requested the screenshot. none if the server did it
var IACECheck  NextCheck;           // Linked list

// =============================================================================
// SetPlayerCrosshairScale
// @param Scale -1 is the default behavior (dynamically scaling with resolution)
//              any other number is a fixed scale
// =============================================================================
function SetPlayerCrosshairScale(float CrosshairScale);

// =============================================================================
// ToggleCompatibilityMode ~ Changes the ACE timing settings to resemble the
// original game. This is NOT recommended.
// =============================================================================
function ToggleCompatibilityMode();

// =============================================================================
// TogglePerformanceMode ~ Toggles the ACE performance mode. Only recommended
// for high end pcs!
// =============================================================================
function TogglePerformanceMode();

// =============================================================================
// ToggleSoundFix ~ Toggles the Demo Sound volume fix on/off
// =============================================================================
function ToggleSoundFix();

// =============================================================================
// ViewSettings ~ Prints an overview of the client settings
// =============================================================================
function ViewSettings();

// =============================================================================
// SetDemoStatus ~ Controls the demo status display
// @param Status 0 = ALWAYS render in 'Recording: <filename> <time>' format
//               1 = ALWAYS render in 'Recording: <YES/NO>' format
//               2 = render WHEN RECORDING ONLY in 'Recording: <filename> <time>' format
//               3 = render WHEN RECORDING ONLY in 'Recording: <YES/NO>' format
//               4 = HIDE demo status display
// =============================================================================
function SetDemoStatus(int Status);

// =============================================================================
// ACELogExternal ~ Overridden
// =============================================================================
function ACELogExternal(string LogString)
{
    if (ConfigActor != none && ConfigActor.bExternalLog)
    {
        if (Logger == none)
        {
            Logger = Level.Spawn(class'IACELogger');
            Logger.OpenACELog(ConfigActor.LogPath, ConfigActor.LogPrefix, PlayerName);
            SetTimer(0.25, true);
        }

        if (Logger != none)
        {
            Logger.ACELog(LogString);
        }
    }
}

// =============================================================================
// ACELog ~ Log with header
// =============================================================================
function ACELog(string LogString, optional bool bExternal)
{
    Log("[ACE"$ACEVersion$"]:"@LogString);
    ACELogExternal("[ACE"$ACEVersion$"]:"@LogString);
}

// =============================================================================
// ACEPadLog ~ Overridden - Always external
// =============================================================================
function ACEPadLog(string LogString, optional string PaddingChar, optional string FinalChar,
    optional int StringLength, optional bool bCenter, optional bool bHeader, optional bool bExternal)
{
    local string Result;
    local int Pos;

    // Init default properties
    if (PaddingChar == "") PaddingChar  = " ";
    if (FinalChar == "")   FinalChar    = "|";
    if (StringLength == 0) StringLength = 75;

    Result = LogString;

    // Truncate string if needed
    if (Len(Result) + 4 > StringLength)
    {
        Result = FinalChar $ PaddingChar
            $ Left(Result, Len(Result) - 6) $ "..."
            $ PaddingChar $ FinalChar;
    }
    else
    {
        // Insert padding characters
        Result = PaddingChar $ Result;
        while (Len(Result) + 2 < StringLength)
        {
            // Only insert padding at the left side if the original string
            // should be centered in the resulting string
            if (bCenter && (Pos++) % 2 == 1)
                Result = PaddingChar $ Result;
            else
                Result = Result $ PaddingChar;
        }
        Result = FinalChar $ Result $ FinalChar;
    }

    if (bHeader)
        ACELog(Result, true);
    else if (ConfigActor != none)
        ACELogExternal(Result);
    else
        Log(Result);
}
