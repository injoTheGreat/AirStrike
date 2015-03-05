package game.utils
{
	import flash.geom.Rectangle;

	public class CollisionUtils
	{
		public static const COLLISION_NA:String = "NotAvailableCollision";
		public static const COLLISION_PLAYER:String = "PlayerCollision";
		public static const COLLISION_ENEMY:String = "EnemyCollision";
		public static const COLLISION_BULLET_PLAYER:String = "BulletPlayerCollision";
		public static const COLLISION_BULLET_ENEMY:String = "BulletEnemyCollision";
		
		public static const COLLISION_MAP:Object = generateCollisionMap();
	 
		//maps collidable object keys
		private static function generateCollisionMap():Object{
			var object:Object = new Object();
			
			object[COLLISION_BULLET_ENEMY] = [COLLISION_PLAYER];
			object[COLLISION_BULLET_PLAYER] = [COLLISION_ENEMY];
			object[COLLISION_ENEMY] = [COLLISION_BULLET_PLAYER, COLLISION_PLAYER];
			object[COLLISION_PLAYER] = [COLLISION_BULLET_ENEMY,COLLISION_ENEMY];
			
			return object; 
		}
	}
}