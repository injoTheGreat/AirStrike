package game.events
{
	import flash.events.Event;
	
	/**
	 * Representing Event class for updating player game score
	 * @author nmilic
	 * 
	 */	
	public class ChangeScoreEvent extends Event
	{
		public static const UPDATE_SCORE:String = "update_score";
		
		private var _isEnemyKilled:Boolean = false;
		
		public function ChangeScoreEvent(type:String, isEnemyKilled:Boolean = false)
		{
			super(type);
			
			this._isEnemyKilled = isEnemyKilled;
		}
		
		/**
		 * Flag if enemy is killed.<br/>
		 * Calculating score depends if enemy is killed or some item is picked up by player 
		 * @return <code> true </code> if enemy is killed. <code> false </code> otherwise
		 * 
		 */		
		public function get isEnemyKilled():Boolean
		{
			return _isEnemyKilled;
		}
		
		public override function clone():Event
		{
			return new ChangeScoreEvent(type, isEnemyKilled);
		}
	}
}