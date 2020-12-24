// =============================================================================
// AntiCheatEngine - (c) 2009-2020 AnthraX
// =============================================================================
class ACEHUDMutator extends Mutator;

// =============================================================================
// Enumerations
// =============================================================================
var enum EDrawState
{
    DRAW_BLANK,
    DRAW_FADE_IN,
    DRAW_DISPLAY,
    DRAW_FADE_OUT,
    DRAW_DONE
} DrawState;

// =============================================================================
// Variables
// =============================================================================
var ChallengeHUD HUD;
var PlayerPawn Player;
var Font       ScaledFont;
var int        PosX, PosY;                      // Calculated
var int        ConfigPosX, ConfigPosY;          // Configured
var int        OldClipX, OldClipY;
var float      GameSpeed, DrawTime;
var bool       LogoInitialized;
var string     VersionText, StatusText;
var int        StatusNum;
var texture    SplashLogo;
var int        DotCount;
var float      LastUpdate;
var float      OldLTS;
var string     DisplayText;

// =============================================================================
// PostRender ~
// =============================================================================
simulated function PostRender(canvas Canvas)
{
    if (DrawState != EDrawState.DRAW_DONE)
    {
        if (!LogoInitialized)
        {
            LogoInitialized = true;
            SplashLogo = texture'acelogo';
            DrawState  = EDrawState.DRAW_FADE_IN;
            OldLTS     = Level.TimeSeconds;
        }

        DrawSplash(Canvas);
    }
    else if (DrawState == EDrawState.DRAW_DONE)
    {
        UnregisterHUDMutator();
        Destroy();
    }

    if (NextHUDMutator != None)
        NextHUDMutator.PostRender(Canvas);
}

// =============================================================================
// Destroyed
// =============================================================================
event Destroyed()
{
    HUD            = none;
    Player         = none;
    SplashLogo     = none;
    NextHUDMutator = none;
    ScaledFont     = none;
}

// =============================================================================
// Tick
// =============================================================================
simulated function Tick(float DeltaTime)
{
    if (HUD == none && Player != none)
	{
        HUD = ChallengeHUD(Player.myHUD);		
    }
	
    if (HUD != none && bHUDMutator)
    {
        RegisterHUDMutator();
    }
}

// =============================================================================
// DrawSplash
// =============================================================================
simulated function DrawSplash(canvas Canvas)
{
    local font PreviousFont;
    local bool PreviousCenter;
    local color PreviousColor;
    local byte PreviousStyle;
    local float W, H, MaxW, MaxH;
    local float Tmp;
    local int I;
	local class<FontInfo> FCClass;
	local FontInfo FC;
	local float ScaledU, ScaledV;

    DisplayText = StatusText;

    DrawTime  += (Level.TimeSeconds - OldLTS);
    OldLTS     = Level.TimeSeconds;
    //DrawTime += DeltaTime;

	if (ScaledFont == none)
	{
		FCClass = Class<FontInfo>(DynamicLoadObject(class'ChallengeHUD'.default.FontInfoClass, class'Class'));
		if (FCClass != none)
		{
			FC = Spawn(FCClass);
			if (FC != none)
			{
				ScaledFont = FC.GetSmallFont(Canvas.ClipX);
				FC.Destroy();
			}
		}

		if (ScaledFont == none)
			ScaledFont = Canvas.SmallFont;

		FCClass = none;
		FC = none;
	}

    // Update text
    if (DrawTime - LastUpdate > 0.2)
    {
        LastUpdate = DrawTime;
        DotCount++;
        if (DotCount > 3)
            DotCount = 0;
    }

    Switch (DrawState)
    {
        case EDrawState.DRAW_FADE_IN :
            if (DrawTime >= 1.0)
            {
                DrawState = EDrawState.DRAW_DISPLAY;
                DrawTime = 0.0;
            }
            break;
        case EDrawState.DRAW_DISPLAY :
            if (StatusNum == 2 && DrawTime >= 3.0)
            {
                DrawState = EDrawState.DRAW_FADE_OUT;
                DrawTime = 0.0;
            }
            break;
        case EDrawState.DRAW_FADE_OUT :
            if (DrawTime >= 3.0)
            {
                DrawState = EDrawState.DRAW_DONE;
                DrawTime = 0.0;
            }
            break;

        case EDrawState.DRAW_DONE :
            SplashLogo = none;
            break;
    }

    if (StatusNum < 2)
    {
        for (I = 0; I < DotCount; ++I)
            DisplayText = DisplayText $ ".";
    }

    if (DrawState != EDrawState.DRAW_BLANK)
    {
        PreviousCenter = Canvas.bCenter;
        PreviousColor  = Canvas.DrawColor;
        PreviousFont   = Canvas.Font;
        PreviousStyle  = Canvas.Style;
        Canvas.Reset();
        Canvas.Font = ScaledFont;
		Canvas.TextSize("Loading Complete!",MaxW,MaxH);

		ScaledU = SplashLogo.USize * MaxH / 10.0;
		ScaledV = SplashLogo.VSize * MaxH / 10.0;

        // if player has changed the screen resolution, re-set positions and
        // size - also sets things in the first run
		if(Canvas.ClipX != OldClipX || Canvas.ClipY != OldClipY)
		{
			PosX = ConfigPosX;
			PosY = Canvas.ClipY/2 + ConfigPosY;
		    OldClipX = Canvas.ClipX;
		    OldClipY = Canvas.ClipY;
		}
        Canvas.SetPos(PosX, PosY);

        Switch (DrawState)
        {
            case EDrawState.DRAW_FADE_IN :
                Canvas.Style = ERenderStyle.STY_Translucent;
                Tmp = DrawTime;
                if (Tmp > 1.0) Tmp = 1.0;
                Canvas.DrawColor.R = 255 * Tmp;
                Canvas.DrawColor.G = 255 * Tmp;
                Canvas.DrawColor.B = 255 * Tmp;
                break;

            case EDrawState.DRAW_DISPLAY :
                Canvas.Style = ERenderStyle.STY_Translucent;
                Canvas.DrawColor.R = 255;
                Canvas.DrawColor.G = 255;
                Canvas.DrawColor.B = 255;
                break;

            case EDrawState.DRAW_FADE_OUT :
                Canvas.Style = ERenderStyle.STY_Translucent;
                Tmp = (3.0 - DrawTime) / 3.0;
                if (Tmp < 0.0)
                {
                    Disable('Tick');
                    Tmp = 0.0;
                }
                Canvas.DrawColor.R = 255 * Tmp;
                Canvas.DrawColor.G = 255 * Tmp;
                Canvas.DrawColor.B = 255 * Tmp;
                break;
        }

        Canvas.DrawIcon(SplashLogo, ScaledU / SplashLogo.USize);

        Canvas.Reset();
        Canvas.bCenter = False;

        Switch (DrawState)
        {
            case EDrawState.DRAW_FADE_IN :
                Canvas.Style = ERenderStyle.STY_Translucent;
                Tmp = DrawTime;
                if (Tmp > 1.0) Tmp = 1.0;
                Canvas.DrawColor.R = 255 * Tmp;
                Canvas.DrawColor.G = 255 * Tmp;
                Canvas.DrawColor.B = 255 * Tmp;
                break;

            case EDrawState.DRAW_DISPLAY :
                Canvas.Style = ERenderStyle.STY_Translucent;
                Canvas.DrawColor.R = 255;
                Canvas.DrawColor.G = 255;
                Canvas.DrawColor.B = 255;
                break;

            case EDrawState.DRAW_FADE_OUT :
                Canvas.Style = ERenderStyle.STY_Translucent;
                Tmp = (3.0 - DrawTime) / 3.0;
                if (Tmp < 0.0)
                {
                    Disable('Tick');
                    Tmp = 0.0;
                }
                Canvas.DrawColor.R = Max(255 * Tmp, 1);
                Canvas.DrawColor.G = Max(255 * Tmp, 1);
                Canvas.DrawColor.B = Max(255 * Tmp, 1);
                break;
        }

		Canvas.Font = ScaledFont;
        Canvas.TextSize(VersionText,W,H);
        Canvas.SetPos(PosX + int(ScaledU/2.0 - W/2.0), PosY + int(ScaledV));
        Canvas.DrawText(VersionText);
        Canvas.TextSize(StatusText,W,H);
        Canvas.SetPos(PosX + int(ScaledU/2.0 - W/2.0), PosY + int(ScaledV) + MaxH);
        Canvas.DrawText(DisplayText);

        Canvas.bCenter   = PreviousCenter;
        Canvas.DrawColor = PreviousColor;
        Canvas.Font      = PreviousFont;
        Canvas.Style     = PreviousStyle;
    }
}

// =============================================================================
// RegisterHUDMutator
// =============================================================================
function RegisterHUDMutator()
{
    if (HUD != none)
    {
        if (HUD.HUDMutator == none)
            HUD.HUDMutator = self;
        else
        {
            NextHUDMutator   = HUD.HUDMutator;
            HUD.HUDMutator = self;
        }
		bHUDMutator = true;
    }
}

// =============================================================================
// UnregisterHUDMutator
// =============================================================================
function UnregisterHUDMutator()
{
    local Mutator Mut;
    local Mutator Prev;

    if (HUD != none)
    {
        if (HUD.HUDMutator == self)
        {
            HUD.HUDMutator = NextHUDMutator;
        }
        else if (HUD.HUDMutator != none)
        {
            for (Mut = HUD.HUDMutator.NextHUDMutator; Mut != none; Mut = Mut.NextHUDMutator)
            {
                if (Mut == self)
                {
                    Prev.NextHUDMutator = NextHUDMutator;
                    break;
                }
                Prev = Mut;
            }
        }
    }
}

// =============================================================================
// SetStatus
// =============================================================================
function SetStatus(int SN, optional string SS)
{
    StatusNum = SN;
    if (SN == 2)
    {
        DrawTime = 0.0;
        StatusText = "Loading Complete!";

		// Clean up here because if the HUD is hidden, we're not going to get
		// any PostRender calls so we won't have a chance to clean up there
        if (HUD != none && HUD.bHideHUD)
		{
            UnregisterHUDMutator();
			Destroy();
        }
    }
    else if (SN == 1)
    {
        StatusText = "Loading";
    }
    else if (SN == 0)
    {
        StatusText = "Connecting";
    }
}

// =============================================================================
// defaultproperties
// =============================================================================
defaultproperties
{
    VersionText="ACE @ACELONGVERLOWER@"
    StatusText="Loading"
	bHidden=true
	bAlwaysTick=true
}