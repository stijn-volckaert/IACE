// =============================================================================
// AntiCheatEngine - (c) 2009-2016 AnthraX
// =============================================================================
class IACECommon extends Actor;

// =============================================================================
// Logo
// =============================================================================
#exec Texture Import File=Classes\acelogo.pcx name=acelogo Mips=Off Flags=2
#exec Texture Import File=Classes\acebg.pcx name=acebg Mips=Off Flags=2

// =============================================================================
// Constants
// =============================================================================
const hex = "0123456789ABCDEF";

// =============================================================================
// Variables
// =============================================================================
var string     ACEVersion;   // Current version of ACE
var IACELogger Logger;       // External logfile
var IACEActor  ConfigActor;  // Reference to the actor from which the configuration should be read

// =============================================================================
// Replication
// =============================================================================
replication
{
    // Executed by the server on the client
    reliable if (ROLE == ROLE_AUTHORITY)
        PlayerConsoleCommand, PlayerOpenConsole;
}

// =============================================================================
// PlayerKick ~ Kicks the player from the server!
//
// @param bShowConsole Show the player's console when kicking
// =============================================================================
function PlayerKick(bool bShowConsole)
{
    if (bShowConsole)
        PlayerOpenConsole();
    PlayerConsoleCommand("disconnect");
    GoToState('KickingPlayer');
}

// =============================================================================
// KickingPlayer ~ This state is here to make sure that the player gets kicked,
// even if the disconnect consolecommand did not work!
// =============================================================================
state KickingPlayer
{
    function Timer()
    {
        if (PlayerPawn(Owner) != none && PlayerPawn(Owner).Player != none
            && NetConnection(PlayerPawn(Owner).Player) != none)
        {
            // Player is still on the server! Remove the player by force
            Owner.Destroy();
        }

        if (Logger != none)
            Logger.Destroy();
    }
    Begin:
        SetTimer(15.0,false);
}

// =============================================================================
// PlayerMessage ~
// =============================================================================
function PlayerMessage(string Msg)
{
    if (PlayerPawn(Owner) != none)
        PlayerPawn(Owner).ClientMessage("[ACE"$ACEVersion$"] : "$Msg);
}

// =============================================================================
// PlayerOpenConsole ~ Displays the player's console
// =============================================================================
simulated function PlayerOpenConsole()
{
    local WindowConsole WC;

    if (PlayerPawn(Owner) == none
        || PlayerPawn(Owner).Player == none
        || PlayerPawn(Owner).Player.Console == none
        || WindowConsole(PlayerPawn(Owner).Player.Console) == none)
        return;

    WC = WindowConsole(PlayerPawn(Owner).Player.Console);
    if (!WC.bCreatedRoot || WC.Root == none)
        WC.CreateRootWindow(None);

    WC.bQuickKeyEnable = true;
    WC.bShowConsole = true;
    WC.LaunchUWindow();
    WC.ShowConsole();
}

// =============================================================================
// PlayerConsoleCommand ~ Execute the specified consolecommand in the player's console
// The results of the command are NOT returned to the server!
// =============================================================================
simulated function PlayerConsoleCommand(string Command)
{
    if (PlayerPawn(Owner) != none)
        PlayerPawn(Owner).ConsoleCommand(Command);
}

// =============================================================================
// Destroyed ~
// =============================================================================
event Destroyed()
{
    if (Logger != none)
    {
        Logger.CloseACELog();
        Logger.Destroy();
    }
}

// =============================================================================
// Timer ~
// =============================================================================
function Timer()
{
    if ((Level.Game.bGameEnded || Level.NextSwitchCountdown < 0.5))
    {
        if (Logger != None)
        {
            Logger.CloseACELog();
            Logger.Destroy();
            SetTimer(0.0,false);
        }
    }
}

// =============================================================================
// ACELogExternal ~ Log to the ACE external logfile. If there's no external
// logfile yet for this map then this function will create one
// =============================================================================
function ACELogExternal(string LogString)
{
    if (ConfigActor != none && ConfigActor.bExternalLog)
    {
        if (Logger == none)
        {
            Logger = Level.Spawn(class'IACELogger');
            Logger.OpenACELog(ConfigActor.LogPath, ConfigActor.LogPrefix, "");
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
    if (bExternal)
        ACELogExternal("[ACE"$ACEVersion$"]:"@LogString);
}

// =============================================================================
// ACEPadLog ~ Log with padding
//
// @param LogString    string to be logged
// @param PaddingChar  character to fill up the line with (default " ")
// @param FinalChar    character to be placed at the beginning and end of the line (default "|")
// @param StringLength length of the resulting string (default 75)
// @param bCenter      Center the logstring inside the resulting string?
// @param bHeader      Prepend the ace header to the logstring?
//
// example:
// ACEPadLog("TestString",".","*",30,true,true)
// => "[ACEv01]: *.........TestString.........*"
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
        ACELog(Result, bExternal);
    else if (ConfigActor != none && ConfigActor.bExternalLog)
        ACELogExternal(Result);
    else
        Log(Result);
}

// =============================================================================
// GetDate ~ Get the current date in dd-MM-yyyy format
// =============================================================================
function string GetDate()
{
    return "" $ IntToStr(Level.Day, 2) $ "-" $ IntToStr(Level.Month, 2) $ "-" $ IntToStr(Level.Year, 2);
}

// =============================================================================
// GetTime ~ Get the current time in hh:mm:ss format
// =============================================================================
function string GetTime()
{
    return "" $ IntToStr(Level.Hour, 2) $ ":" $ IntToStr(Level.Minute, 2) $ ":" $ IntToStr(Level.Second, 2);
}

// =============================================================================
// IntToStr ~ Converts an integer to a string of the specified length
//
// @param i            The integer to be converted
// @param StringLength The desired length of the string.
//                     "0" characters are prepadded to the int if needed
// =============================================================================
function string IntToStr(int i, int StringLength)
{
    local string Result;
    Result = string(i);
    while (Len(Result) < StringLength)
        Result = "0"$Result;
    return Result;
}

// =============================================================================
// xxReplaceText ~ Replaces any occurences of zzOldText by zzNewText in zzString
//
// @param zzString    The String in which the text should be replaced
// @param zzOldText   The Text that should be replaced
// @param zzNewText   The Text that should replace zzOldText
// =============================================================================
function string xxReplaceText (string zzString, string zzOldText, string zzNewText)
{
    while (InStr(zzString,zzOldText) != -1)
        zzString = Left(zzString,InStr(zzString,zzOldText))$zzNewText$Mid(zzString,InStr(zzString,zzOldText)+Len(zzOldText));

    return zzString;
}

// =============================================================================
// xxGetToken ~ Retrieve a token from a tokenstring
//
// @param zzString    The String in which the token should be found
// @param zzDelimiter The String that seperates the tokens
// @param zzToken     The Token that should be retrieved
// =============================================================================
function string xxGetToken(string zzString, string zzDelimiter, int zzToken)
{
    local int zzI;

    zzString = zzString$zzDelimiter;

    for (zzI = 0; zzI < zzToken; ++zzI)
    {
        if (InStr(zzString, zzDelimiter) != -1)
            zzString = Mid(zzString,InStr(zzString,zzDelimiter)+Len(zzDelimiter));
    }

    if (InStr(zzString,zzDelimiter) != -1)
        return Left(zzString,InStr(zzString,zzDelimiter));
    else
        return zzString;
}

// =============================================================================
// xxGetTokenCount ~ Calculates the number of tokens in a tokenstring
//
// @param zzString    The String that contains the tokens
// @param zzDelimiter The String that seperates the tokens
// =============================================================================
function int xxGetTokenCount(string zzString, string zzDelimiter)
{
    local int zzI;

    zzString = zzString$zzDelimiter;

    while (InStr(zzString, zzDelimiter) != -1)
    {
        zzString = Mid(zzString, InStr(zzString, zzDelimiter) + Len(zzDelimiter));
        zzI++;
    }

    return zzI;
}

// =============================================================================
// IntToHex ~ ripped from IUTDCv12
// =============================================================================
function string IntToHex(int i)
{
    return Mid(hex, i >> 28 & 0xf, 1) $ Mid(hex, i >> 24 & 0xf, 1)
        $ Mid(hex, i >> 20 & 0xf, 1) $ Mid(hex, i >> 16 & 0xf, 1)
        $ Mid(hex, i >> 12 & 0xf, 1) $ Mid(hex, i >> 8 & 0xf, 1)
        $ Mid(hex, i >> 4 & 0xf, 1) $ Mid(hex, i & 0xf, 1);
}

// =============================================================================
// HexToInt ~ Converts a hex DWORD to an integer
// =============================================================================
function int HexToInt(string HexString)
{
    local int i, temp;

    if (Len(HexString) != 8)
        return 0;

    for (i = 0; i < 8; ++i)
        temp += InStr(hex, Left(Right(HexString, i + 1), 1)) << (4 * i);

    return temp;
}

// =============================================================================
// defaultproperties
// =============================================================================
defaultproperties
{
    ACEVersion="v10"
    bHidden=true
}
