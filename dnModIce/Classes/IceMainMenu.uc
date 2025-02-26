// IceMainMenu.uc
//

class IceMainMenu extends UDukeSceneMainMenuPAX;

var UDukeMenuButton SinglePlayerButton;
var UDukeMenuButton LocalMultiplayerGameButton;
var UDukeMenuButton OptionsButton;
var UDukeMenuButton ExtraButton;
var UDukeMenuButton ExitButton;

// var IceSceneHelpOptions videoOptions; // Don't use this or remove it! This helps the unreal compiler find this class!

function Created()
{
	super(UWindowScene).Created();
	SinglePlayerButton = UDukeMenuButton(CreateWindow(class'UDukeMenuButton',,,,, self));
	SinglePlayerButton.SetText("Play Campaign");
	SinglePlayerButton.SetHelpText("Play Campaign");
	SinglePlayerButton.Register(self);

	LocalMultiplayerGameButton = UDukeMenuButton(CreateWindow(class'UDukeMenuButton',,,,, self));
	LocalMultiplayerGameButton.SetText("Local Multiplayer");
	LocalMultiplayerGameButton.SetHelpText("Local Multiplayer");
	LocalMultiplayerGameButton.Register(self);
	
	ExtraButton = UDukeMenuButton(CreateWindow(class'UDukeMenuButton',,,,, self));
	ExtraButton.SetText("Extras");
	ExtraButton.SetHelpText("Extras");
	ExtraButton.Register(self);

	OptionsButton = UDukeMenuButton(CreateWindow(class'UDukeMenuButton',,,,, self));
	OptionsButton.SetText("Options");
	OptionsButton.SetHelpText("Options");
	OptionsButton.Register(self);

	ExitButton = UDukeMenuButton(CreateWindow(class'UDukeMenuButton',,,,, self));
	ExitButton.SetText("Exit");
	ExitButton.SetHelpText("Exit");
	ExitButton.Register(self);

	FirstControlToFocus = SinglePlayerButton;
	SinglePlayerButton.NavUp = ExitButton;
	LocalMultiplayerGameButton.NavUp = SinglePlayerButton;
    OptionsButton.NavUp = LocalMultiplayerGameButton;
	ExtraButton.NavUp = OptionsButton;
    ExitButton.NavUp = ExtraButton;
    SinglePlayerButton.NavDown = LocalMultiplayerGameButton;
	LocalMultiplayerGameButton.NavDown = OptionsButton;
    OptionsButton.NavDown = ExtraButton;
	ExtraButton.NavDown = ExitButton;
	ExitButton.NavDown = SinglePlayerButton;
}

function Paint(Canvas C, float X, float Y)
{
	SinglePlayerButton.Alpha = FadeAlpha;
	SinglePlayerButton.WinWidth = float(ButtonWidth);
	SinglePlayerButton.WinHeight = float(ButtonHeight);
	SinglePlayerButton.WinLeft = float(ButtonLeft);
	SinglePlayerButton.WinTop = float(ControlStart);

	LocalMultiplayerGameButton.Alpha = FadeAlpha;
	LocalMultiplayerGameButton.WinWidth = float(ButtonWidth);
	LocalMultiplayerGameButton.WinHeight = float(ButtonHeight);
	LocalMultiplayerGameButton.WinLeft = float(ButtonLeft);
	LocalMultiplayerGameButton.WinTop = SinglePlayerButton.WinTop + SinglePlayerButton.WinHeight;

	OptionsButton.Alpha = FadeAlpha;
	OptionsButton.WinWidth = float(ButtonWidth);
	OptionsButton.WinHeight = float(ButtonHeight);
	OptionsButton.WinLeft = float(ButtonLeft);
	OptionsButton.WinTop = LocalMultiplayerGameButton.WinTop + LocalMultiplayerGameButton.WinHeight;
	
	ExtraButton.Alpha = FadeAlpha;
	ExtraButton.WinWidth = float(ButtonWidth);
	ExtraButton.WinHeight = float(ButtonHeight);
	ExtraButton.WinLeft = float(ButtonLeft);
	ExtraButton.WinTop = float(ControlStart);
	ExtraButton.WinTop = OptionsButton.WinTop + OptionsButton.WinHeight;

	ExitButton.Alpha = FadeAlpha;
	ExitButton.WinWidth = float(ButtonWidth);
	ExitButton.WinHeight = float(ButtonHeight);
	ExitButton.WinLeft = float(ButtonLeft);
	ExitButton.WinTop = ExtraButton.WinTop + ExtraButton.WinHeight;
	super(UWindowScene).Paint(C, X, Y);
}

function NotifyFromControl(UWindowDialogControl C, byte E)
{
	if(c == SinglePlayerButton && E == 2)
	{
		NavigateForward(class'IceNewGame');	
	}

	if(c == LocalMultiplayerGameButton && E == 2)
	{
		GetPlayerOwner().ClientTravel("DM-Casino?Listen?Game=dnModIce.IceGameDeathmatch", TRAVEL_Relative, false);	
	}
	
	if(C == ExtraButton && E == 2)
	{
		NavigateForward(class'IceExtras');	
	}
	
	if(C == OptionsButton && E == 2)
	{
		NavigateForward(class'IceSceneHelpOptions');	
	}

	if(C == ExitButton && E == 2)
	{
		GetPlayerOwner().ConsoleCommand("quit");
	}
}

function bool PropagateKey(UWindowWindow.WinMessage msg, Canvas C, float X, float Y, int Key)
{
	if(msg == WM_KeyDown && key == 192)
	{
		Root.Console.ShowConsole();
		return true;
	}
	return super.PropagateKey(msg, C, X, Y, Key);
}

function Tick(float Delta)
{
	super(UWindowWindow).Tick(Delta);
}

defaultproperties
{
	bMenuMusic=false
}