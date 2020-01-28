// =============================================================================
// AntiCheatEngine - (c) 2009-2020 AnthraX
// =============================================================================
// IACEConfigFileReader: this cannot be compiled without bytehacking UWeb.u
//
// Bytehacked UWeb.u:
// http://utgl.unrealadmin.org/UWebHacked.u
//
// ONLY use this for compiling. If you use this in online games you will most
// likely get caught and banned!
// =============================================================================
class IACEConfigFileReader extends WebResponse;

// =============================================================================
// Variables
// =============================================================================
var string Lines[512];
var int LineCount;

// =============================================================================
// Read ~ Reads the ACE.ini file from the specified folder and parses it.
// @param Path Folder to read the ACE.ini file from
// @param File IACEConfigFile object to store the settings in.
// @return true when succeeded
// =============================================================================
function bool Read(string Path, IACEConfigFile File)
{
    local int i, Index;
    local string Name, Value;

    IncludePath = Path;
    IncludeBinaryFile("ACE.ini");

    for (i = 0; i <= LineCount; ++i)
    {
        Index = InStr(Lines[i], "=");

        if (Index != -1)
        {
            Name  = Left(Lines[i], Index);
            Value = Mid(Lines[i], Index+1);
            File.SetConfigVariable(name, CVAR_UNKNOWN, Value);
        }
    }

    return (LineCount != 0);
}

// =============================================================================
// SendBinary ~ Callback function
// =============================================================================
event SendBinary (int Count, byte Bytes[255])
{
    local int i;

    for (i = 0; i < Count; ++i)
    {
        switch(Bytes[i])
        {
            case 13: // Ignore Carriage Return
                break;
            case 10: // Line Feed
                LineCount++;
                break;
            case 0: // UTF-16LE
                break;
            default:
                if (LineCount < 512)
                    Lines[LineCount] = Lines[LineCount] $ chr(Bytes[i]);
                break;
        }
    }
}