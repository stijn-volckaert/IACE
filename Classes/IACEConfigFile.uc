// =============================================================================
// AntiCheatEngine - (c) 2009-2016 AnthraX
// =============================================================================
// IACEConfigFile: Object that allows reading from and writing to a version
// independent ACE configuration file.
// To use this class client-side this MUST be spawned into the EntryLevel!
// =============================================================================
class IACEConfigFile extends Actor;

// =============================================================================
// Enumerations
// =============================================================================
enum ConfigVariableType
{
    CVAR_UNKNOWN,
    CVAR_STRING,
    CVAR_CHAR,
    CVAR_INT,
    CVAR_FLOAT,
    CVAR_BOOL
};

// =============================================================================
// Structures
// =============================================================================
struct ConfigVariable
{
    var string Name;
    var string Value;
    var bool bDirty;
    var ConfigVariableType Type;
};

// =============================================================================
// Variables
// =============================================================================
var ConfigVariable       Settings[256];  // Current Settings
var bool                 bDirty;         // When set to true, the configfile is not up to date.

// =============================================================================
// ReadConfig ~ Read the configuration from the ACE.ini file
// @param Path Folder from which the ACE.ini file should be read
// @return true when file was read successfully
// =============================================================================
function bool ReadConfig(string Path)
{
    local IACEConfigFileReader Reader;
    local bool bSuccess;

    Reader    = new(None) class'IACEConfigFileReader';
    bSuccess  = Reader.Read(Path, self);
    Reader    = none;

    return bSuccess;
}

// =============================================================================
// WriteConfig ~ Writes the configuration to the ACE.ini file
// @param Path Folder to which the ACE.ini file should be written
// @return true when file was written successfully
// =============================================================================
function bool WriteConfig(string Path)
{
    local IACEConfigFileWriter Writer;
    local bool bSuccess;

    Writer    = Level.Spawn(class'IACEConfigFileWriter');
    bSuccess  = Writer.Write(Path, self);
    Writer.Destroy();
    Writer    = none;

    if (bSuccess)
        bDirty  = false;

    return bSuccess;
}

// =============================================================================
// CastToType ~ Cast the specified variable to the specified type
// @param Value Value of the Variable
// @param Type Type to cast to
// @return Requested variable in string form
// =============================================================================
function string CastToType(string Value, ConfigVariableType Type)
{
    if (Value != "")
    {
        switch(Type)
        {
            case CVAR_CHAR:
                Value = Left(Value, 1);
                break;
            case CVAR_INT:
                Value = string(int(Value));
                break;
            case CVAR_FLOAT:
                Value = string(float(Value));
                break;
            case CVAR_BOOL: // Multilangual support
                if (Value ~= "true" || Value ~= string(true))
                    Value = string(true);
                else
                    Value = string(false);
                break;
        }
    }

    if (Value == "")
    {
        switch(Type)
        {
            case CVAR_INT:
                Value = "0";
                break;
            case CVAR_FLOAT:
                Value = "0.0";
                break;
            case CVAR_BOOL:
                Value = string(false);
                break;
        }
    }

    return Value;
}

// =============================================================================
// QueryConfigVariable ~ Get the current value of a ConfigVariable
// @param Name Name of the Configuration Variable
// @param Type Type of the Configuration Variable
// @param bErrorWhenNotFound Returns "ERROR" when the specified variable was not found
// @return Requested variable in a format that can be cast to the specified type
// =============================================================================
function string QueryConfigVariable(string Name, ConfigVariableType Type, optional bool bErrorWhenNotFound)
{
    local int i;
    local string Result;

    for (i = 0; i < 256; ++i)
    {
        if (Settings[i].Name == "")
            break;

        if (Settings[i].Name ~= Name)
        {
            Result = Settings[i].Value;
            break;
        }
    }

    if (Result == "" && bErrorWhenNotFound)
        return "ERROR";

    return CastToType(Result, Type);
}

// =============================================================================
// SetConfigVariable ~ Set the value of a ConfigVariable
// @param name name of the Configuration Variable
// @param Type Type of the Configuration Variable
// @param Value Value of the Configuration Variable
// @return true when set successfully
// =============================================================================
function bool SetConfigVariable(string Name, ConfigVariableType Type, string Value)
{
    local int i;
    local string Tmp;

    for (i = 0; i < 256; ++i)
    {
        if (Settings[i].Name == "" || Settings[i].Name ~= Name)
        {
            Settings[i].Name = Name;
            break;
        }
    }

    if (i >= 256)
        return false;

    Tmp = CastToType(Value, Type);

    if (Settings[i].Type != Type || Settings[i].Value != Tmp)
        bDirty = true;

    Settings[i].Type  = Type;
    Settings[i].Value = Tmp;

    return true;
}

// =============================================================================
// CheckVariable ~ Check if the specified variable is present and initialize it
// to it's default value if needed.
// @param Name Name of the Variable to check
// @param Type Type of the Variable
// @param Value Default Value
// =============================================================================
function CheckVariable(string Name, ConfigVariableType Type, string Value)
{
    if (QueryConfigVariable(Name, Type, true) == "ERROR")
        SetConfigVariable(name, Type, Value);
}

// =============================================================================
// CheckConfig ~ Initializes any ACEv0.9 variable that was not found.
// =============================================================================
function CheckConfig()
{
    CheckVariable("CrosshairScale"    , CVAR_FLOAT , "-1.0");
    CheckVariable("TimingMode"        , CVAR_INT   , "0");
    CheckVariable("SleepMode"         , CVAR_INT   , "0");
    CheckVariable("CheckPriority"     , CVAR_INT   , "0");
    CheckVariable("bNonStrictCapping" , CVAR_BOOL  , "false");
    CheckVariable("bDisableSoundFix"  , CVAR_BOOL  , "false");
    CheckVariable("bForceHighPerf"    , CVAR_BOOL  , "false");
    CheckVariable("DemoStatusMode"    , CVAR_INT   , "2");
    CheckVariable("DemoStatusXOffset" , CVAR_INT   , "0");
    CheckVariable("DemoStatusYOffset" , CVAR_INT   , "0");

    if (bDirty)
        WriteConfig(".");
}

// =============================================================================
// GetName
// =============================================================================
function string GetName(int i)
{
    if (i < 256)
        return Settings[i].Name;
    return "";
}

// =============================================================================
// GetType
// =============================================================================
function ConfigVariableType GetType(int i)
{
    if (i < 256)
        return Settings[i].Type;
    return CVAR_UNKNOWN;
}

// =============================================================================
// GetValue
// =============================================================================
function string GetValue(int i)
{
    if (i < 256)
        return Settings[i].Value;
    return "";
}

// =============================================================================
// defaultproperties
// =============================================================================
defaultproperties
{
    bHidden=true
}