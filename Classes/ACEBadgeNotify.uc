// =============================================================================
// AntiCheatEngine - (c) 2009-2020 AnthraX
// =============================================================================
class ACEBadgeNotify extends IACECommon;

// =============================================================================
// Variables
// =============================================================================
var ACEHUDMutator   ACEHUD;  // ACE HUD!
var ChallengeHUD    HUD;     // HUD we're attached to
var PlayerPawn      PP;      // PlayerPawn we're attached to
var int StatusNum;           //
var string StatusTxt;        // Optional extra text
var float XPos;              // X Position of the top left corner
var float YPos;              // Y Position of the top left corner

// =============================================================================
// PostBeginPlay ~
// =============================================================================
function MyPostBeginPlay()
{
    if (PP != none && PP.myHUD != none && PP.myHUD.IsA('ChallengeHUD'))
    {
        AttachToHUD(ChallengeHUD(PP.myHUD));
    }
    else
    {
        SetTimer(0.25, true);
    }
}

// =============================================================================
// Timer ~ Periodically check if the hud is there
// =============================================================================
function Timer()
{
    if (PP != none && PP.myHUD != none && PP.myHUD.IsA('ChallengeHUD'))
    {
        AttachToHUD(ChallengeHUD(PP.myHUD));
        SetTimer(0.0, false);
    }
}

// =============================================================================
// AttachToHud ~
// =============================================================================
function AttachToHUD(ChallengeHUD NewHUD)
{
    HUD    = NewHUD;
    ACEHUD = Spawn(class'ACEHUDMutator');

    if (ACEHUD != None)
    {
        ACEHUD.HUD  = HUD;
        ACEHUD.Player = PP;
        ACEHUD.PosX = XPos;
        ACEHUD.PosY = YPos;
        ACEHUD.RegisterHUDMutator();
        ACEHUD.SetStatus(StatusNum, StatusTxt);
    }
}

// =============================================================================
// SetStatus ~
// =============================================================================
function SetStatus(int Status, optional string StatusText)
{
    // 1 = handshake complete
    // 2 = loading complete. Entering main loop
    StatusNum = Status;
    StatusTxt = StatusText;
    if (ACEHUD != none)
        ACEHUD.SetStatus(Status, StatusText);
    if (StatusNum == 2)
    {
        ACEHUD = none;
        HUD    = none;
        PP     = none;
        Destroy();
    }
}

// =============================================================================
// defaultproperties
// =============================================================================
defaultproperties
{
    bAlwaysTick=true
}