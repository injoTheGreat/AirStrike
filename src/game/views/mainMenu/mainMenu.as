import flash.display.Bitmap;
import flash.events.MouseEvent;

[Embed(source="/assets/images/mainmenu.png")]
private static const mainMenu:Class;

private static const MAIN_MENU:Bitmap = new mainMenu();

protected function startGame(event:MouseEvent):void
{
	parentApplication.setCurrentState("gameplay", false);
}