package game.utils
{

	public class CollisionUtils
	{
		public static const COLLISION_NA:String = "NotAvailableCollision";
		public static const COLLISION_PLAYER:String = "PlayerCollision";
		public static const COLLISION_ENEMY:String = "EnemyCollision";
		public static const COLLISION_BULLET_PLAYER:String = "BulletPlayerCollision";
		public static const COLLISION_BULLET_ENEMY:String = "BulletEnemyCollision";
		/*public static const COLLISION_AMMO_ITEM:String = "AmmunitionItemCollision";
		public static const COLLISION_WEAPON_ITEM:String = "WeapontemCollision";
		public static const COLLISION_ENERGY_ITEM:String = "EnergytemCollision";*/
		public static const COLLISION_PICK_UP_ITEM:String = "PickUptemCollision";
		
		public static const COLLISION_MAP:Object = generateCollisionMap();
	 
		//maps collidable object keys
		private static function generateCollisionMap():Object{
			var object:Object = new Object();
			//bullets
			object[COLLISION_BULLET_ENEMY] = [COLLISION_PLAYER];
			object[COLLISION_BULLET_PLAYER] = [COLLISION_ENEMY];
			// pick up item
			object[COLLISION_PICK_UP_ITEM] = [COLLISION_PLAYER];
			//enemy
			object[COLLISION_ENEMY] = [COLLISION_BULLET_PLAYER, COLLISION_PLAYER];
			//player
			object[COLLISION_PLAYER] = [COLLISION_BULLET_ENEMY,COLLISION_ENEMY, COLLISION_PICK_UP_ITEM];
			
			return object; 
		}
	}
}