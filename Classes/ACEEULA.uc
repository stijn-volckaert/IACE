// =============================================================================
// AntiCheatEngine - (c) 2009-2016 AnthraX
// =============================================================================
// ACE End User License agreement. Spawned into entrylevel and displayed by
// NPLoader. Needs to be accepted before ACE is installed.
// Can be queried through the Engine.Actor.GetItemName function
// =============================================================================
class ACEEULA extends Actor
    config(User);

// =============================================================================
// Variables
// =============================================================================
var string LicenseChunks[250];
var int NumChunks;

// =============================================================================
// Config variables
// =============================================================================
var config bool bLicenseAccepted;

// =============================================================================
// PostBeginPlay ~ Set up license chunks here
// =============================================================================
function PostBeginPlay()
{
    AddLine("================================================");
    AddLine("AntiCheatEngine 1.2 - End User License Agreement");
    AddLine("================================================");
    AddLine("");
    AddLine("By installing ACE, the player accepts that ACE:");
    AddLine("* may monitor the game's virtual address space to look for mods, libraries or programs that enable or facilitate cheating;");
    AddLine("* may generate checksums for the game's core files and certain system libraries;");
    AddLine("* may generate and submit screenshots;");
    AddLine("* may submit non-personal system information to the gameserver;");
    AddLine("* may store certain ACE specific settings in User.ini;");
    AddLine("* may install minor updates of the ACE module without prompting the user;");
    AddLine("* will NOT analyze, alter or submit any personal information;");
    AddLine("* will NOT open or read files that are not directly related to the game;");
    AddLine("* will NOT run after the game has been shut down;");
    AddLine("* will NOT run while playing on servers without ACE;");
    AddLine("* will NOT modify, delete or rename any files or settings (besides the ACE specific settings in ACE.ini);");
    AddLine("* will NOT install major updates of the ACE module without prompting the user;");
    AddLine("* will ALWAYS notify the user if the terms of this agreement change;");
    AddLine("* will ALWAYS prompt the user when installing a major update.");
    AddLine("");
    AddLine("ACE is partially based on components of the following 3rd party products:");
    AddLine("");
    AddLine("--------------------------------------------");
    AddLine("1) The Independent JPEG Group's jpeg library");
    AddLine("--------------------------------------------");
    AddLine("");
    AddLine("This software is based in part on the work of the Independent JPEG Group.");
    AddLine("Copyright (C) 1991-2010, Thomas G. Lane, Guido Vollbeding.");
    AddLine("");
    AddLine("--------------------------------------------");
    AddLine("2) The CxImage Library");
    AddLine("--------------------------------------------");
    AddLine("");
    AddLine("Copyright (C) 2001 - 2008, Davide Pizzolato");
    AddLine("");
    AddLine("--------------------------------------------");
    AddLine("3) Hacker's Disassembler Engine 32");
    AddLine("--------------------------------------------");
    AddLine("");
    AddLine("Hacker Disassembler Engine 32 C");
    AddLine("Copyright (c) 2008-2009, Vyacheslav Patkov.");
    AddLine("All rights reserved.");
    AddLine("");
    AddLine("Redistribution and use in source and binary forms, with or without");
    AddLine("modification, are permitted provided that the following conditions");
    AddLine("are met:");
    AddLine("");
    AddLine(" 1. Redistributions of source code must retain the above copyright");
    AddLine("    notice, this list of conditions and the following disclaimer.");
    AddLine(" 2. Redistributions in binary form must reproduce the above copyright");
    AddLine("    notice, this list of conditions and the following disclaimer in the");
    AddLine("    documentation and/or other materials provided with the distribution.");
    AddLine("");
    AddLine("THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS");
    AddLine("\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED");
    AddLine("TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A");
    AddLine("PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR");
    AddLine("CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,");
    AddLine("EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,");
    AddLine("PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR");
    AddLine("PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF");
    AddLine("LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING");
    AddLine("NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS");
    AddLine("SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.");
    AddLine("");
    AddLine("--------------------------------------------");
    AddLine("4) The ENet Network Protocol");
    AddLine("--------------------------------------------");
    AddLine("");
    AddLine("Copyright (c) 2002-2011 Lee Salzman");
    AddLine("");
    AddLine("Permission is hereby granted, free of charge, to any person obtaining");
    AddLine("a copy of this software and associated documentation files (the");
    AddLine("\"Software\"), to deal in the Software without restriction, including");
    AddLine("without limitation the rights to use, copy, modify, merge, publish,");
    AddLine("distribute, sublicense, and/or sell copies of the Software, and to");
    AddLine("permit persons to whom the Software is furnished to do so, subject to");
    AddLine("the following conditions:");
    AddLine("");
    AddLine("The above copyright notice and this permission notice shall be");
    AddLine("included in all copies or substantial portions of the Software.");
    AddLine("");
    AddLine("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,");
    AddLine("EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF");
    AddLine("MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND");
    AddLine("NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE");
    AddLine("LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION");
    AddLine("OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION");
    AddLine("WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.");
    AddLine("");
    AddLine("--------------------------------------------");
    AddLine("5) xxHash - Fast Hash algorithm");
    AddLine("--------------------------------------------");
    AddLine("");
    AddLine("Copyright (C) 2012-2016, Yann Collet");
    AddLine("");
    AddLine("BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)");
    AddLine("");
    AddLine("Redistribution and use in source and binary forms, with or without");
    AddLine("modification, are permitted provided that the following conditions are");
    AddLine("met:");
    AddLine("");
    AddLine("* Redistributions of source code must retain the above copyright");
    AddLine("notice, this list of conditions and the following disclaimer.");
    AddLine("* Redistributions in binary form must reproduce the above");
    AddLine("copyright notice, this list of conditions and the following disclaimer");
    AddLine("in the documentation and/or other materials provided with the");
    AddLine("distribution.");
    AddLine("");
    AddLine("THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS");
    AddLine("\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT");
    AddLine("LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR");
    AddLine("A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO event SHALL THE COPYRIGHT");
    AddLine("OWNER OR CONTRIBUTORS BE LIABLE for ANY DIRECT, INDIRECT, INCIDENTAL,");
    AddLine("SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT");
    AddLine("LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,");
    AddLine("DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY");
    AddLine("THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT");
    AddLine("(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY out OF THE USE");
    AddLine("OF THIS SOFTWARE, EVEN if ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.");
	AddLine("");
    AddLine("--------------------------------------------");
    AddLine("6) Microsoft Detours");
    AddLine("--------------------------------------------");
    AddLine("");
	AddLine("# Copyright (c) Microsoft Corporation");
	AddLine("");
	AddLine("All rights reserved.");
	AddLine("");
	AddLine("# MIT License");
	AddLine("");
	AddLine("Permission is hereby granted, free of charge, to any person obtaining a copy of");
	AddLine("this software and associated documentation files (the \"Software\"), to deal in");
	AddLine("the Software without restriction, including without limitation the rights to");
	AddLine("use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies");
	AddLine("of the Software, and to permit persons to whom the Software is furnished to do");
	AddLine("so, subject to the following conditions:");
	AddLine("");
	AddLine("The above copyright notice and this permission notice shall be included in all");
	AddLine("copies or substantial portions of the Software.");
	AddLine("");
	AddLine("THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR");
	AddLine("IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,");
	AddLine("FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE");
	AddLine("AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER");
	AddLine("LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,");
	AddLine("OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE");
	AddLine("SOFTWARE.");
}

// =============================================================================
// AddLine
// =============================================================================
function AddLine(string Line)
{
    LicenseChunks[NumChunks++] = Line;
}

// =============================================================================
// GetItemName
// =============================================================================
function string GetItemName(string Str)
{
    local string result;
    local int Arg;

    Str = CAPS(Str);

    if (InStr(Str, " ") != -1)
    {
        Arg = int(Mid(Str, InStr(Str, " ")+1));
        Str = Left(Str, InStr(Str, " "));
    }

    switch(Str)
    {
        case "ISACCEPTED":
            if (bLicenseAccepted)
                result = "TRUE";
            else
                result = "FALSE";
            break;

        case "ACCEPT":
            bLicenseAccepted = true;
            SaveConfig();
            break;

        case "GETNUMCHUNKS":
            result = "" $ NumChunks;
            break;

        case "GETCHUNK":
            if (Arg < NumChunks && Arg >= 0)
                result = LicenseChunks[Arg];
            break;
    }

    return result;
}