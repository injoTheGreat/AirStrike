package game.objects
{
	import flash.geom.Point;
	
	import flashx.textLayout.formats.Direction;
	
	import game.utils.CollisionUtils;
	import game.utils.GraphicsResource;
	import game.utils.ObjectPool;
	import game.utils.getGameHeight;

	public class Bullet extends GameObject
	{
		public static var pool:ObjectPool = new ObjectPool(createBullet);
		private var _def:WeaponDefinition;
		private var _collisionType:String;
		
		public function Bullet()
		{
			super();
		}
		
		private static function createBullet():GameObject{
			return new Bullet();
		}
		
		public function startUp(definition:WeaponDefinition, position:Point, direction:Point, collisionType:String):void{
			this.direction = direction;
			_def = definition;
			_collisionType = collisionType;
			initialize(definition.graphics, position, GameZOrders.PLAYER);
		}
		public override function updateProperties(time:Number):void{
			super.updateProperties(time);
			
			if((_collisionType == CollisionUtils.COLLISION_BULLET_PLAYER && position.y < -height) ||
				(_collisionType == CollisionUtils.COLLISION_BULLET_ENEMY && position.y > getGameHeight()))
			{
				dispose();
			}
			
			if(direction.y != 0)
				position.y += _def.bulletSpeed * direction.y;
			if(direction.x != 0)
				position.x += _def.bulletSpeed * direction.x;
		}
		
		public override function get collisionType():String{
			return _collisionType;
		}
		
		public override function handleCollision(collideWithObject:GameObject):void{
			dispose();
		}
	}
}