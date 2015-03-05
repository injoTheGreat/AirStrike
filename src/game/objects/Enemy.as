package game.objects
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	import game.MainManager;
	import game.Resources;
	import game.utils.CollisionUtils;
	import game.utils.GraphicUtils;
	import game.utils.GraphicsResource;
	import game.utils.ObjectPool;
	import game.utils.SoundUtils;
	import game.utils.getGameHeight;
	

	public class Enemy extends AnimatedGameObject
	{
		public static var pool:ObjectPool = new ObjectPool(createEnemy);
		public static const GREEN_PLANE_SPEED:Number = 80;
		public static const BLUE_PLANE_SPEED:Number = 60;
		public static const WHITE_PLANE_SPEED:Number = 100;
		public static const COOL_PLANE_SPEED:Number = 90;
		
		private var timeToNextBullet:Number = 0;
		private var _speed:Number = 0;
		
		
		public function Enemy()
		{
			super();
		}
		
		private static function createEnemy():GameObject{
			return new Enemy();
		}
		
		public function startUpEnemy(graphics:GraphicsResource, position:Point, speed:Number):void{
			_speed = speed;
			super.startUp(graphics, position, GameZOrders.PLAYER);
		}
		
		//move down
		public override function updateProperties(time:Number):void
		{
			super.updateProperties(time);
			if(position.y > getGameHeight()){
				dispose();
			}
			
			position.y += _speed * time;
//			position.x += _speed * time;
			
			timeToNextBullet -= time;
			
			if (timeToNextBullet <= 0)
			{
				timeToNextBullet = MainManager.inst.enemyWeapon.timeBetweenBullets; 
				var bulletPosition:Point = new Point(position.x + width/2 - MainManager.inst.enemyWeapon.graphics.bitmap.width/2, 
					position.y + height - MainManager.inst.enemyWeapon.graphics.bitmap.height);
				
				var bullet:Bullet=Bullet.pool.getItem() as Bullet;
				bullet.rotation = rotation;
				bullet.startUp(MainManager.inst.enemyWeapon, bulletPosition, new Point(Math.sin(rotation), Math.cos(rotation)), CollisionUtils.COLLISION_BULLET_ENEMY);
				SoundUtils.play(MainManager.inst.enemyWeapon.sound);
			}
		}
		
		public override function get collisionType():String{
			return CollisionUtils.COLLISION_ENEMY;
		}
		
		public override function handleCollision(collideWithObject:GameObject):void{
			
			if (collideWithObject.collisionType == CollisionUtils.COLLISION_BULLET_PLAYER)
			{
				// collision with player bullet
				this.energy -= MainManager.inst.playerWeapon.damage;
			}
			else
			{
				// direct collision with player
				this.energy = 0;
			}
			
			var widthDiff:Number;
			var heightDiff:Number; 
			
			if (this.energy == 0)
			{
				// object is totally damaged
				// simulate explosion
				MainManager.inst.kills++;
				
				widthDiff = (Resources.ExplosionGraphics.bitmap.width / Resources.ExplosionGraphics.frames - width)/2;
				heightDiff = (Resources.ExplosionGraphics.bitmap.height - height)/2;
				GraphicUtils.createAnimation(Resources.ExplosionGraphics, new Point(position.x - widthDiff, position.y - heightDiff), zOrder, false);
				SoundUtils.play(Resources.ExplosionSound);
				dispose();
			}
			else
			{
				//simulate missile hit by player
				widthDiff = (Resources.MissileHit.bitmap.width / Resources.MissileHit.frames - width)/2;
				heightDiff = (Resources.MissileHit.bitmap.height - height)/2;
				GraphicUtils.createAnimation(Resources.MissileHit, new Point(position.x + widthDiff, position.y + height/2), zOrder, false);
				SoundUtils.play(Resources.MissileHitSound);
			}
		}
	}
}