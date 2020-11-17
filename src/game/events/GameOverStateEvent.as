package game.events
{
	import flash.events.Event;
	
	public class GameOverStateEvent extends Event
	{
		public static const GAMEOVER_SHOW:String = "show_game_over"
		
		public function GameOverStateEvent(type:String)
		{
			super(type);
		}
		
		public override function clone():Event
		{
			return new GameOverStateEvent(type);
		}
	}
}