// =============================================================================
// AntiCheatEngine - (c) 2009-2016 AnthraX
// =============================================================================
// IACEActor: base class of the main serveractor
// =============================================================================
class IACEActor extends IACECommon
    config(System);

// =============================================================================
// Config Variables
// =============================================================================
var config float  HandshakeTimeout;       //
var config float  InitialCheckLinger;     // How many seconds do we wait before running the initial check?
var config float  InitialCheckTimeout;    // How many seconds are allowed to run the initial check?
var config float  PeriodicCheckInterval;  // How many seconds in between checks?
var config float  PeriodicCheckTimeout;   // How many seconds are allowed to run the periodic check?
var config bool   bSShotWhenKick;         // Make a screenshot before kicking?
var config string SShotPath;              // Path to the sshot folder (eg: ../Shots/)
var config string SShotPrefix;            // Prefix for the sshots (eg: [ACE])
var config int    SShotQuality;           // Quality of the screenshots
var config float  SShotTimeOut;           // How many seconds do we allow for a screenshot?
var config bool   bAutoConfig;            // Automatically configure ACE?
var config string AutoConfigPackage;      // Package that contains the autoconfigactor
var config string UPackages[256];         // UScript packages to validate (BaseName!)
var config string NativePackages[256];    // Libraries to validate
var config bool   bExternalLog;           // Is external logging allowed
var config string LogPath;                // Path to log to
var config string LogPrefix;              // Prefix for external logfiles
var config bool   bExternalLogJoins;      // Log playerjoins to an external file?
var config string JoinLogPath;            // Path to log playerjoins to
var config string JoinLogPrefix;          // Prefix for playerjoin logs
var config string AdminPass;              // Password for silent admin commands
var config bool   bAllowCrosshairScaling; // Allow the player to change their crosshair scale?
var config bool   bShowLogo;              // Show the ACE logo and the loading status?
var config float  LogoXPos;               // X coordinate of the top left corner of the logo
var config float  LogoYPos;               // Y coordinate of the top left corner of the logo
var config bool   bCheckSpectators;       // Should spectators be checked as well? -> required for certain banning systems
var config bool   bAutoFindWANIp;         // Automatically find the WAN ip if the server is behind a NAT router
var config bool   bCacheWANIP;            // Cache the WAN ip (recommended for servers with a static ip)
var config string WANQueryServer[10];     // Servers to query to find out WAN ip
var config string ForcedWANIP;            // Force the WAN ip. This WILL be overridden by the automatically found ip if bAutoFind is enabled
var config string CachedWANIP;            // Last known WAN ip

var config int    ACEPort;                // Port to bind the PlayerManager on (if set to 0, the PlayerManager will listen on GamePort+2)
var config bool   bAllowOtherPorts;       // Allow ACE to bind other ports if the above port is not available? If set to true, ACE will try to bind ports one by one (starting at the ACEPort)var config bool   bAutoUpdateFileList;    // Automagically download new definitions from the UTGL masterserver?

var config bool   bAutoUpdateFileList;    // Automagically download new definitions from the UTGL masterserver?
var config string FileListProviderHost;   // Provider of the file list (eg: utgl.unrealadmin.org)
var config string FileListProviderPath;   // Path to the most recent file list (eg: /ACE/)
var config string FileListName;           // Filename of the filelist (eg: ACEFileList.txt)
var config string FileListPath;           // Path to the filelist (eg: ../System/)
var config bool   bStrictSystemLibraryChecks;

// =============================================================================
// Variables
// =============================================================================
var IACECheck     CheckList;              // Linked List
var Object        EventHandlers[32];      // EventHandlers Array

// =============================================================================
// PostBeginPlay ~ Log startup banner
// =============================================================================
function PostBeginPlay()
{
    ACEPadLog("","-","+",40,true);
    ACEPadLog("ACE for Unreal Tournament"," ","|",40,true);
    ACEPadLog(ACEVersion," ","|",40,true);
    ACEPadLog("(c) 2009-2016 - AnthraX"," ","|",40,true);
    ACEPadLog("","-","+",40,true);
    MyPostBeginPlay();
}

// =============================================================================
// Public Function Prototypes
// =============================================================================
function MyPostBeginPlay();
function NotifyConnectInternal(IACECheck Checker);
function NotifyDisconnectInternal(IACECheck Checker);
function NotifyRenameInternal(IACECheck Checker, string NewName);

// =============================================================================
// RegisterEventHandler ~
// =============================================================================
function bool RegisterEventHandler(IACEEventHandler EventHandler)
{
    local int i;

    // First add it to the array
    for (i = 0; i < 32; ++i)
    {
        if (EventHandlers[i] == none)
        {
            EventHandlers[i] = EventHandler;
            break;
        }
    }

    ACELog("Registered Event Handler:"@EventHandler.Class);
    return true;
}

// =============================================================================
// UnregisterEventHandler ~
// =============================================================================
function bool UnregisterEventHandler(IACEEventHandler EventHandler)
{
    local int i;

    // First remove it from the array
    for (i = 0; i < 32; ++i)
    {
        if (IACEEventHandler(EventHandlers[i]) == EventHandler)
        {
            EventHandlers[i] = none;
            ACELog("Unregistered Event Handler:"@EventHandler.Class);
            break;
        }
    }

    return true;
}

// =============================================================================
// NotifyEventHandlers
// =============================================================================
function NotifyEventHandlers(name EventType, IACECheck Check, string EventData)
{
    local int i;

    for (i = 0; i < 32; ++i)
    {
        if (IACEEventHandler(EventHandlers[i]) != none)
        {
            IACEEventHandler(EventHandlers[i]).EventCatcher(EventType, Check, EventData);
        }
    }
}

// =============================================================================
// NotifyConnect ~ Link Checker Object into linked list
// =============================================================================
function NotifyConnect(IACECheck Check)
{
    Check.NextCheck = CheckList;
    CheckList = Check;

    NotifyConnectInternal(Check);
}

// =============================================================================
// NotifyDisconnect ~ Unlink Checker Object from linked list
// =============================================================================
function NotifyDisconnect(IACECheck Check)
{
    local IACECheck Tmp;

    for (Tmp = CheckList; Tmp != none; Tmp = Tmp.NextCheck)
        if (Tmp.NextCheck == Check)
            break;

    if (Tmp != none)
        Tmp.NextCheck = Check.NextCheck;

    NotifyDisconnectInternal(Check);
}

// =============================================================================
// NotifyRename ~
// =============================================================================
function NotifyRename(IACECheck Check, string NewName)
{
    Check.PlayerName = NewName;
    NotifyRenameInternal(Check, NewName);
}

// =============================================================================
// defaultproperties
// =============================================================================
defaultproperties
{
    bAlwaysTick=true
    bHidden=true
    bAutoConfig=true
    AutoConfigPackage="ACE@ACESHORTMAJORVERLOWER@_AutoConfig"
    bSShotWhenKick=true
    SShotQuality=85
    AdminPass=""
    bAllowCrosshairScaling=true
    bShowLogo=true
    LogoXPos=10
    LogoYPos=-100
    bAutoFindWANIp=true
    bCacheWANIP=true
    WANQueryServer(0)="utgl.unrealadmin.org/ip.php"
    ForcedWANIP=""
    FileListName="ACEFileList.txt"
    FileListPath="./"
    FileListProviderHost="utgl.unrealadmin.org"
    FileListProviderPath="/ACE/"
    SShotPath="../Shots/"
    SShotPrefix="[ACE]"
    ACEPort=0
    bAllowOtherPorts=true
    bAutoUpdateFileList=true
    LogPath="../Logs/"
    LogPrefix="[ACE]"
    HandshakeTimeout=30.0
    InitialCheckTimeout=70.0
    PeriodicCheckInterval=45.0
    PeriodicCheckTimeout=60.0
    SShotTimeout=40.0
    bStrictSystemLibraryChecks=false
}
