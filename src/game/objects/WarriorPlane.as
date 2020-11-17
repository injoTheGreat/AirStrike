package game.objects
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	
	import game.MainManager;
	import game.Resources;
	import game.events.ChangeScoreEvent;
	import game.events.CollectItemEvent;
	import game.levels.Level1;
	import game.objects.interfaces.IInteractiveObject;
	import game.utils.CollisionUtils;
	import game.utils.GraphicUtils;
	import game.utils.SoundUtils;
	import game.utils.getGameHeight;
	import game.utils.getGameWidth;

	public class WarriorPlane extends AnimatedGameObject implements IInteractiveObject
	{
		public static const DEFAULT_SPEED:Number = 5;
		private var _isShooting:Boolean = false;
		private var _timeToNextBullet:Number = 0;
		private const ROTATION_ANGLE:Number = 10 * Math.PI/180; //10 degrees angle converted to radians
		private var _speed:Number = 0;
		
		[Bindable]
		public var weapon:WeaponDefinition;
		
		public function WarriorPlane()
		{
			super();
			// set initial player weapon
			weapon = Level1.inst.playerWeapons[0];
		}

		public function startUpWarrior(speed:Number = DEFAULT_SPEED):void
		{
			super.startUp(Resources.WarriorPlaneGraphics, new Point((getGameWidth() - Resources.WarriorPlaneGraphics.bitmap.rect.width) / 2, (getGameHeight() - Resources.WarriorPlaneGraphics.bitmap.rect.height) / 2), GameZOrders.PLAYER);
			_timeToNextBullet = 0;
			_isShooting = false;
			_speed  = speed;
			
			Level1.inst.playerWeapons[0].collected = true;
		}

		//update properties for every frame with given time
		public override function updateProperties(time:Number):void
		{
			super.updateProperties(time);
			
			if (_isShooting)
			{
				_timeToNextBullet -= time;

				if (_timeToNextBullet <= 0)
				{
					_timeToNextBullet = this.weapon.timeBetweenBullets;  
					var bulletPosition:Point = new Point(position.x + width/2 - this.weapon.graphics.bitmap.width/2, 
						position.y + height/2 - this.weapon.graphics.bitmap.height/2);
					
					var bullet:Bullet = Bullet.pool.getItem() as Bullet;
					bullet.rotation = rotation;
					bullet.startUp(this.weapon, bulletPosition, new Point(Math.sin(rotation), -Math.cos(rotation)), CollisionUtils.COLLISION_BULLET_PLAYER);
					SoundUtils.playSFX(this.weapon.sound);
					
					// decrease ammunition while shooting
					this.weapon.ammunition -= this.weapon.bulletsPerShot;
					
					MainManager.inst.shotsFired++;
				}
			}
		}

		public function mouseClick(event:MouseEvent):void
		{
		}

		public function mouseUp(event:MouseEvent):void
		{
			_isShooting = false;
		}

		public function mouseDown(event:MouseEvent):void
		{
			_isShooting = this.weapon.ammunition >= this.weapon.bulletsPerShot;
			_timeToNextBullet = 0;
		}

		public function mouseMove(event:MouseEvent):void
		{
			var gameWidth:Number = getGameWidth();
			var gameHeight:Number = getGameHeight();

			position.x = event.localX - width / 2;
			position.y = event.localY - height / 2;

			if (position.x < 0)
				position.x = 0;
			if (position.x > (gameWidth - width))
				position.x = gameWidth - width;
			if (position.y < 0)
				position.y = 0;
			if (position.y > (gameHeight - height))
				position.y = gameHeight - height;
		}
		
		public function keyDown(keyCodes:Array):void		
		{
			if (keyCodes.indexOf(Keyboard.LEFT) > -1)
				rotation -= ROTATION_ANGLE;
			else if (keyCodes.indexOf(Keyboard.RIGHT) > -1)
				rotation += ROTATION_ANGLE;
			
			if(keyCodes.indexOf(Keyboard.UP) > -1){
				position.x += Math.sin(rotation) * _speed;
				position.y += -Math.cos(rotation) * _speed;
			}
			
			if (keyCodes.indexOf(Keyboard.SPACE) > -1)
			{
				if (MainManager.inst.isMissileLaunched && MainManager.inst.missileWeapon.ammunition > 0)
				{
					var rocketPosition:Point = new Point(position.x + width/2 - MainManager.inst.missileWeapon.graphics.bitmap.width/2, 
						position.y + height/2 - MainManager.inst.missileWeapon.graphics.bitmap.height/2);
					
					var rocket:Bullet = Bullet.pool.getItem() as Bullet;
					rocket.rotation = rotation;
					rocket.startUp(MainManager.inst.missileWeapon, rocketPosition, new Point(Math.sin(rotation), -Math.cos(rotation)), CollisionUtils.COLLISION_BULLET_PLAYER);
					
					MainManager.inst.missileWeapon.ammunition -= MainManager.inst.missileWeapon.bulletsPerShot;
					SoundUtils.playSFX(MainManager.inst.missileWeapon.sound);
					
					MainManager.inst.isMissileLaunched = false;
				}
			}
		}
		
		public override function get collisionType():String{
			return CollisionUtils.COLLISION_PLAYER;
		}
		
		public override function handleCollision(collideWithObject:GameObject):void{
			if (collideWithObject.collisionType == CollisionUtils.COLLISION_BULLET_ENEMY)
			{
				// collision with enemy bullet
				this.energy -= (collideWithObject as Bullet).weapon.damage;
			}
			else if (collideWithObject.collisionType == CollisionUtils.COLLISION_ENEMY)
			{
				// direct collision with enemy object
				// exception for anti-aicraft enemy object
				if ((collideWithObject as Enemy).speed == Level1.BACKGROUND_SPEED)
					return;
				else
					this.energy = 0;
			}
			else
			{
				// collision with pick up item
				
				if ((collideWithObject as BackgroundElement).pickUpType == BackgroundElement.PICK_UP_WEAPON_ITEM_2BULLETS)
				{
					MainManager.inst.eventHandler.dispatchEvent(new CollectItemEvent(CollectItemEvent.PLAYER_WEAPON_CHANGED, Level1.inst.playerWeapons[1]));
				}
				if ((collideWithObject as BackgroundElement).pickUpType == BackgroundElement.PICK_UP_WEAPON_ITEM_3BULLETS)
				{
					MainManager.inst.eventHandler.dispatchEvent(new CollectItemEvent(CollectItemEvent.PLAYER_WEAPON_CHANGED, Level1.inst.playerWeapons[2]));
				}
				if ((collideWithObject as BackgroundElement).pickUpType == BackgroundElement.PICK_UP_AMMO_ITEM)
				{
					MainManager.inst.eventHandler.dispatchEvent(new CollectItemEvent(CollectItemEvent.AMMUNITION_RELOAD, this.weapon));
				}
				if ((collideWithObject as BackgroundElement).pickUpType == BackgroundElement.PICK_UP_ENERGY_ITEM)
				{
					MainManager.inst.eventHandler.dispatchEvent(new CollectItemEvent(CollectItemEvent.PLAYER_ENERGY_REFILL));
				}
				if ((collideWithObject as BackgroundElement).pickUpType == BackgroundElement.PICK_UP_MISSILE_ITEM)
				{
					MainManager.inst.eventHandler.dispatchEvent(new CollectItemEvent(CollectItemEvent.MISSILE_AMUNITION_COLLECTED, MainManager.inst.missileWeapon));
				}
				
				MainManager.inst.pickUpItem = null;
				
				// update score when picking up item
				MainManager.inst.eventHandler.dispatchEvent(new ChangeScoreEvent(ChangeScoreEvent.UPDATE_SCORE));
				
				return;
			}
			
			var widthDiff:Number = (Resources.ExplosionGraphics.bitmap.width / Resources.ExplosionGraphics.frames - width)/2;
			var heightDiff:Number = (Resources.ExplosionGraphics.bitmap.height - height)/2;
			if (this.energy <= 0)
			{
				// object is totally damaged
				// simulate explosion
				GraphicUtils.createAnimation(Resources.ExplosionGraphics, new Point(position.x - widthDiff, position.y - heightDiff), zOrder, false);
				SoundUtils.playSFX(Resources.ExplosionSound);
				dispose();
				
				// display GameOver screen
				MainManager.inst.gameOver = true;
				
			}
			else
			{
				// simulate missile hit by enemy
				GraphicUtils.createAnimation(Resources.MissileHit1, new Point(position.x - widthDiff/2, position.y - heightDiff), zOrder, false);
				SoundUtils.playSFX(Resources.MissileHitSound);
			}
		}
	}
}
