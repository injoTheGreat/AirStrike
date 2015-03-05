package game.objects.interfaces
{
	import flash.events.MouseEvent;

	public interface IInteractiveObject
	{
		function mouseClick(event:MouseEvent):void;
		function mouseUp(event:MouseEvent):void;
		function mouseDown(event:MouseEvent):void;
		function mouseMove(event:MouseEvent):void;
		function keyDown(keyCodes:Array):void;
	}
}