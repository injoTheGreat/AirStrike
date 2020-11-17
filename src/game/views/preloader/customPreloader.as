import flash.display.Bitmap;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.events.FlexEvent;


[Embed(source="/assets/images/flying_plane.png")]
private static const LoadingPlane:Class;

private static const LOADING_PLANE:Bitmap = new LoadingPlane();

private var _timer:Timer = null;

protected function onCreationComplete(event:FlexEvent):void
{
	_timer = new Timer(100, 40);
	_timer.start();
	_timer.addEventListener(TimerEvent.TIMER, timerHandler);
}

protected function bar_completeHandler(event:Event):void
{
	parentApplication.setCurrentState("mainMenu");
}

protected function timerHandler(ev:TimerEvent):void
{
	bar.setProgress(_timer.currentCount, _timer.repeatCount);
}