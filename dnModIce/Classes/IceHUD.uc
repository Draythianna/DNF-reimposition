class IceHUD extends DukeHUD;

var MaterialEx dnHudBackground;

function float ScaleHeight(Canvas C, float value)
{
	return value * (c.SizeY / 720.0);
}

function float ScaleWidth(Canvas C, float value)
{
	return value * (c.SizeX / 1280.0);
}

simulated event PreRender(Canvas Canvas)
{

}

simulated function Tick(float Delta)
{
	super(Actor).Tick(Delta);
	TickScreenFlashes(Delta);
}

simulated event PostPostRender(Canvas C)
{
	local int ego;

	bHideHUD = false;
	bHideCrosshair = false;

	C.SetPos(0, C.SizeY-ScaleHeight(C, 113));
	C.DrawTile(dnHudBackground, C.SizeX, ScaleHeight(C, 190), 0, 0, 1920, 256);

	ego = PlayerOwner.Ego;

	C.SetPos(ScaleWidth(C, 238), C.SizeY-ScaleHeight(C,63));
	C.DrawText(ego, false, false, false, 2.0, 2.0);

	if(PlayerOwner.Weapon != none)
	{
		if(PlayerOwner.Weapon.GetMaximumAmmo() > 0)
		{
			C.SetPos(ScaleWidth(C, 765), C.SizeY-ScaleHeight(C,63));
			C.DrawText(PlayerOwner.Weapon.GetTotalAmmo(), false, false, false, 2.0, 2.0);			
		}
	}
}

function SaveComplete()
{
	super.SaveComplete();
}

defaultproperties
{
	dnHudBackground=dukeui.ui.hud
}