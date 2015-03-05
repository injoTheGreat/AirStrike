package game.objects
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import game.MainManager;
	import game.Resources;
	import game.objects.interfaces.IInteractiveObject;
	import game.utils.CollisionUtils;
	import game.utils.GraphicUtils;
	import game.utils.SoundUtils;
	import game.utils.getGameHeight;
	import game.utils.getGameWidth;

	public class WarriorPlane extends AnimatedGameObject implements IInteractiveObject
	{
		public static const DEFAULT_SPEED:Number = 5;
		private var isShooting:Boolean = false;
		private var timeToNextBullet:Number = 0;
		private const ROTATION_ANGLE:Number = 10 * Math.PI/180; //10 degrees angle converted to radians
		private var _speed:Number = 0;
		
		public function WarriorPlane()
		{
			super();
		}

		public function startUpWarrior(speed:Number = DEFAULT_SPEED):void
		{
			super.startUp(Resources.WarriorPlaneGraphics, new Point((getGameWidth() - Resources.WarriorPlaneGraphics.bitmap.rect.width) / 2, (getGameHeight() - Resources.WarriorPlaneGraphics.bitmap.rect.height) / 2), GameZOrders.PLAYER);
			timeToNextBullet = 0;
			isShooting = false;
			_speed  = speed;
		}

		//update properties for every frame with given time
		public override function updateProperties(time:Number):void
		{
			super.updateProperties(time);
			
			if (isShooting)
			{
				timeToNextBullet-=time;

				if (timeToNextBullet <= 0)
				{
					timeToNextBullet = MainManager.inst.playerWeapon.timeBetweenBullets;  
					var bulletPosition:Point = new Point(position.x + width/2 - MainManager.inst.playerWeapon.graphics.bitmap.width/2, 
						position.y + height/2 - MainManager.inst.playerWeapon.graphics.bitmap.height/2);
					
					var bullet:Bullet=Bullet.pool.getItem() as Bullet;
					bullet.rotation = rotation;
					bullet.startUp(MainManager.inst.playerWeapon, bulletPosition, new Point(Math.sin(rotation), -Math.cos(rotation)), CollisionUtils.COLLISION_BULLET_PLAYER);
					SoundUtils.play(MainManager.inst.playerWeapon.sound);
				}
			}
		}

		public function mouseClick(event:MouseEvent):void
		{
		}

		public function mouseUp(event:MouseEvent):void
		{
			isShooting = false;
		}

		public function mouseDown(event:MouseEvent):void
		{
			isShooting = true;
			timeToNextBullet = 0;
		}

		public function mouseMove(event:MouseEvent):void
		{
			var gameWidth:Number = getGameWidth();
			var gameHeight:Number = getGameHeight();

			position.x = event.localX - width / 2;
			position.y = event.localY - height / 2;

			if (position.x < 0)
				position.x=0;
			if (position.x > (gameWidth - width))
				position.x=gameWidth - width;
			if (position.y < 0)
				position.y=0;
			if (position.y > (gameHeight - height))
				position.y=gameHeight - height;
		}
		
		public function keyDown(keyCodes:Array):void		
		{
			if (keyCodes.indexOf(Keyboard.LEFT) > -1)
				rotation-= ROTATION_ANGLE;
			else if (keyCodes.indexOf(Keyboard.RIGHT) > -1)
				rotation+= ROTATION_ANGLE;
			
			if(keyCodes.indexOf(Keyboard.UP) > -1){
				position.x += Math.sin(rotation) * _speed;
				position.y += -Math.cos(rotation) * _speed;
			}
		}
		
		public override function get collisionType():String{
			return CollisionUtils.COLLISION_PLAYER;
		}
		
		public override function handleCollision(collideWithObject:GameObject):void{
			if (collideWithObject.collisionType == CollisionUtils.COLLISION_BULLET_ENEMY)
			{
				// collision with enemy bullet
				this.energy -= MainManager.inst.enemyWeapon.damage;
			}
			else
			{
				// direct collision with enemy object
				this.energy = 0;
			}
			
			var widthDiff:Number;
			var heightDiff:Number;
			if (this.energy == 0)
			{
				// object is totally damaged
				// simulate explosion
				widthDiff = (Resources.ExplosionGraphics.bitmap.width / Resources.ExplosionGraphics.frames - width)/2;
				heightDiff = (Resources.ExplosionGraphics.bitmap.height - height)/2;
				GraphicUtils.createAnimation(Resources.ExplosionGraphics, new Point(position.x - widthDiff, position.y - heightDiff), zOrder, false);
				SoundUtils.play(Resources.ExplosionSound);
				dispose();
			}
			else
			{
				// simulate missile hit by enemy
				widthDiff = (Resources.MissileHit1.bitmap.width / Resources.MissileHit1.frames - width)/2;
				heightDiff = (Resources.MissileHit1.bitmap.height - height)/2;
				GraphicUtils.createAnimation(Resources.MissileHit1, new Point(position.x - widthDiff, position.y - heightDiff), zOrder, false);
				SoundUtils.play(Resources.MissileHitSound);
			}
		}
	}
}
