package game.objects
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.MainManager;
	import game.Resources;
	import game.events.ChangeScoreEvent;
	import game.levels.Level1;
	import game.utils.CollisionUtils;
	import game.utils.GraphicUtils;
	import game.utils.GraphicsResource;
	import game.utils.MathUtils;
	import game.utils.ObjectPool;
	import game.utils.SoundUtils;
	import game.utils.getGameHeight;
	import game.utils.getGameWidth;
	

	public class Enemy extends AnimatedGameObject
	{
		public static var pool:ObjectPool = new ObjectPool(createEnemy);
		public static const GREEN_PLANE_SPEED:Number = 80;
		public static const BLUE_PLANE_SPEED:Number = 60;
		public static const WHITE_PLANE_SPEED:Number = 90;
		public static const COOL_PLANE_SPEED:Number = 100;
		public static const AIRCRAFT_PLANE_SPEED:Number = 110;
		public static const AIRCRAFT_MASTER_SPEED:Number = 120;
		
		private var timeToNextBullet:Number = 0;
		private var _moveRight:Boolean = true;
		public var speed:Number = 0;
		
		private static const ANTI_AIRCRAFT_BULLET_ANGLE:Number = 40 * Math.PI/180;
		
		public static const EASY_LEVEL:int = 1;
		public static const INTERMEDIATE_LEVEL:int = 2;
		public static const PRO_LEVEL:int = 3;
		public static const VETERAN_LEVEL:int = 4;
		public static const MASTER_LEVEL:int = 5;
		
		public function Enemy()
		{
			super();
		}
		
		private static function createEnemy():GameObject{
			return new Enemy();
		}
		
		public function startUpEnemy(graphics:GraphicsResource, position:Point, speed:Number, z:int):void{
			this.speed = speed;
			super.startUp(graphics, position, z);
		}
		
		// move down
		// except for master enemy
		public override function updateProperties(time:Number):void
		{
			super.updateProperties(time);
			if(position.y > getGameHeight() || position.x > getGameWidth() || position.x < 0)
			{
				dispose();
			}
			
			if (position.y >= 0 && getDifficultyLevel(this.graphics) == MASTER_LEVEL)
			{
				// move master enemy left/right
				if (position.x + this.width < getGameWidth()-5 && _moveRight)
				{
					position.x += this.speed * time;
				}
				else if (position.x < 10)
				{
					_moveRight = true;
				}
				else
				{
					_moveRight = false;
					position.x -= this.speed * time;
				}
				
			}
			else
			{
				position.y += this.speed * time;
			}
//			position.x += _speed * time;
			
			timeToNextBullet -= time;
			
			if (timeToNextBullet <= 0)
			{
				var isAntiAircraft:Boolean = getDifficultyLevel(this.graphics) == VETERAN_LEVEL;
				
				var weaponDef:WeaponDefinition = isAntiAircraft ? Level1.inst.enemyWeapons[4] : 
					getDifficultyLevel(this.graphics) == MASTER_LEVEL ? Level1.inst.enemyWeapons[5] : MainManager.inst.enemyWeapon;

				timeToNextBullet = weaponDef.timeBetweenBullets; 

				var bulletPosition:Point = new Point(position.x + width/2 - weaponDef.graphics.bitmap.width/2, 
					position.y + height - weaponDef.graphics.bitmap.height);
				if (isAntiAircraft)
				{
					// anti-aircraft bullet position
					bulletPosition = new Point(position.x + 0.8*width, position.y);
				}
				if (getDifficultyLevel(this.graphics) == MASTER_LEVEL)
				{
					// master enemy bullet position
					bulletPosition = new Point(position.x + 0.48*width - weaponDef.graphics.bitmap.width/2, 
						position.y + height - weaponDef.graphics.bitmap.height);
				}
				
				var bullet:Bullet = Bullet.pool.getItem() as Bullet;
				bullet.rotation = isAntiAircraft ? ANTI_AIRCRAFT_BULLET_ANGLE : rotation;
				bullet.startUp(weaponDef, 
					bulletPosition, 
					new Point(Math.sin(bullet.rotation), isAntiAircraft ? -Math.cos(bullet.rotation) : Math.cos(bullet.rotation)), 
					CollisionUtils.COLLISION_BULLET_ENEMY);
				
				SoundUtils.playSFX(weaponDef.sound);
			}
		}
		
		public override function get collisionType():String{
			return CollisionUtils.COLLISION_ENEMY;
		}
		
		public static function getDifficultyLevel(graphics:GraphicsResource):uint
		{
			if (([Resources.WhiteEnemy, Resources.BlueEnemy, Resources.GreenEnemy] as Array).indexOf(graphics) > -1)
			{
				return EASY_LEVEL;
			}
			
			if (([Resources.AircraftEnemy, Resources.CoolPlaneEnemy] as Array).indexOf(graphics) > -1)
			{
				return INTERMEDIATE_LEVEL;
			}
			if (([Resources.BomberAirCraftEnemy1, Resources.BomberAirCraftEnemy2, Resources.F16Enemy, Resources.AircraftMasterHelp] as Array).indexOf(graphics) > -1)
			{
				return PRO_LEVEL;
			}
			if (([Resources.AntiAicraft, Resources.AntiAicraft1] as Array).indexOf(graphics) > -1)
			{
				return VETERAN_LEVEL;
			}
			
			return MASTER_LEVEL;
		}
		
		public override function handleCollision(collideWithObject:GameObject):void{
			
			if (collideWithObject.collisionType == CollisionUtils.COLLISION_BULLET_PLAYER)
			{
				// collision with player bullet
				this.energy -= getDifficultyLevel(this.graphics) == MASTER_LEVEL ? WeaponDefinition.VERY_LOW_DAMAGE : 
					(collideWithObject as Bullet).weapon.damage;
			}
			else
			{
				// direct collision with player
				// except if enemy is anti-aircraft
				if (getDifficultyLevel(this.graphics) == VETERAN_LEVEL)
					return;
				else
					this.energy = 0;
			}
			
			var widthDiff:Number;
			var heightDiff:Number; 
			
			if (this.energy <= 0)
			{
				// object is totally damaged
				// simulate explosion
				
				MainManager.inst.kills++;
				
				widthDiff = (Resources.ExplosionGraphics.bitmap.width / Resources.ExplosionGraphics.frames - width)/2;
				heightDiff = (Resources.ExplosionGraphics.bitmap.height - height)/2;
				GraphicUtils.createAnimation(Resources.ExplosionGraphics, new Point(position.x - widthDiff, position.y - heightDiff), zOrder, false);
				SoundUtils.playSFX(Resources.ExplosionSound);
				dispose();
				
				// change enemy's weapon
				if (MainManager.inst.kills == Level1.ENEMY_KILLS_COUNT[0])
					MainManager.inst.enemyWeapon = Level1.inst.enemyWeapons[1];
				
				if (MainManager.inst.kills == Level1.ENEMY_KILLS_COUNT[2])
				{
					MainManager.inst.enemyWeapon = Level1.inst.enemyWeapons[2];
					
					Level1.inst.playerWeapons[0].damage = WeaponDefinition.WEAK_DAMAGE;
					Level1.inst.playerWeapons[1].damage = WeaponDefinition.WEAK_DAMAGE;
				}
				
				if (MainManager.inst.kills == Level1.ENEMY_KILLS_COUNT[3])
					MainManager.inst.enemyWeapon = Level1.inst.enemyWeapons[3];

				// checks if enemy can be replaced with pickUp item
				// if pickUp item already exists then skip checking
				if (!MainManager.inst.pickUpItem)
				{
					MainManager.inst.checkForPickUpItem(this);
				}
				
				MainManager.inst.eventHandler.dispatchEvent(new ChangeScoreEvent(ChangeScoreEvent.UPDATE_SCORE, true, getDifficultyLevel(this.graphics)));
			}
			else
			{
				//simulate missile hit by player
				widthDiff = (Resources.MissileHit.bitmap.width / Resources.MissileHit.frames - width)/2;
				heightDiff = (Resources.MissileHit.bitmap.height - height)/2;
				GraphicUtils.createAnimation(Resources.MissileHit, new Point(position.x + width/3, position.y + height/2), zOrder, false);
				SoundUtils.playSFX(Resources.MissileHitSound);
			}
		}
		
	}
}