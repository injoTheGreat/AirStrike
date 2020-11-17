package game.levels
{
	import flash.geom.Point;
	
	import game.MainManager;
	import game.Resources;
	import game.objects.BackgroundElement;
	import game.objects.Enemy;
	import game.objects.GameZOrders;
	import game.objects.WeaponDefinition;
	import game.utils.GraphicsResource;
	import game.utils.MathUtils;
	import game.utils.SoundUtils;
	import game.utils.getGameWidth;

	public class Level1
	{
		private var bgElementGraphics:Array = [
			Resources.BigIslandGraphics,
			Resources.SmallIslandGraphics,
			Resources.VolcanoIslandGraphics,
			Resources.IslandGraphics,
			Resources.BigIsland1Graphics,
			Resources.Island1Graphics,
			Resources.SmallIsland1Graphics,
			Resources.BigIsland2Graphics
		];
		
		/*private var enemyGraphics:Array = [
			Resources.AntiAicraft,
			Resources.AntiAicraft1
		];
		
		private var enemySpeeds:Array = [
			BACKGROUND_SPEED,
			BACKGROUND_SPEED
		];*/
		private var enemyGraphics:Array = [
			Resources.BlueEnemy,
			Resources.GreenEnemy,
			Resources.WhiteEnemy,
			Resources.CoolPlaneEnemy,
			Resources.AircraftEnemy,
			Resources.BomberAirCraftEnemy1,
			Resources.BomberAirCraftEnemy2,
			Resources.F16Enemy,
			Resources.AntiAicraft,
			Resources.AntiAicraft1,
			Resources.AircraftMasterHelp,
			Resources.MasterEnemy
		];
		
		private var enemySpeeds:Array = [
			Enemy.BLUE_PLANE_SPEED,
			Enemy.GREEN_PLANE_SPEED,
			Enemy.WHITE_PLANE_SPEED,
			Enemy.COOL_PLANE_SPEED,
			Enemy.AIRCRAFT_PLANE_SPEED,
			Enemy.AIRCRAFT_PLANE_SPEED,
			Enemy.AIRCRAFT_PLANE_SPEED,
			Enemy.COOL_PLANE_SPEED,
			BACKGROUND_SPEED,
			BACKGROUND_SPEED,
			Enemy.AIRCRAFT_PLANE_SPEED,
			Enemy.AIRCRAFT_MASTER_SPEED
		];
		
		private const TIME_BETWEEN_ELEMENTS_DISPLAY:int = 3;
		private const TIME_BETWEEN_CLOUDS_DISPLAY:int = 2.5;
		private const TIME_BETWEEN_ENEMIES_START:int = 2;
		private const TIME_BETWEEN_ENEMIES_END:int = 1.5;
		
		public static const DEFAULT_SCORE:int = 10;
		public static const PICK_UP_HELP_KILLS:int = 17;

		public static const ENEMY_KILLS_COUNT:Array = [7, 10, 20, 35, 40, 52];
//		public static const ENEMY_KILLS_COUNT:Array = [3, 7, 12, 16, 20, 2];
		
		private var timeToNextElement:Number = 0;
		private var timeToNextCloud:Number = 0;
		private var timeToNextEnemy:Number = 0;
		
		public var levelCompleted:Boolean = false;
		
		public static const BACKGROUND_SPEED:Number = 40;
		public static const PICK_UP_ITEM_SPEED:Number = 60;
		public static const UPPER_CLOUD_SPEED:Number = 90;
		public static const LOWER_CLOUD_SPEED:Number = 70;
		
		public var playerWeapons:Array = [
			new WeaponDefinition(Resources.RoundBullets, 7, 1.7, Resources.GunSound2, WeaponDefinition.HARD_DAMAGE),
			new WeaponDefinition(Resources.TwoBullets, 10, 0.4, Resources.GunSound1, WeaponDefinition.TOTAL_DAMAGE, WeaponDefinition.TWO_BULLETS_SHOT),		
			new WeaponDefinition(Resources.ThreeBullets, 11, 0.4, Resources.ThreeRoundShot, WeaponDefinition.HARD_DAMAGE, WeaponDefinition.THREE_BULLETS_SHOT),
			new WeaponDefinition(Resources.MissileWeapon, 12, 0, Resources.RocketLaunchSound, WeaponDefinition.TOTAL_DAMAGE, WeaponDefinition.ONE_BULLET_SHOT, true)
		];
		
		public var enemyWeapons:Array = [
			new WeaponDefinition(Resources.OneBullet, 6, 2.2, Resources.EnemyOneShot, WeaponDefinition.WEAK_DAMAGE),
			new WeaponDefinition(Resources.OneBullet, 8, 1.5, Resources.EnemyOneShot, WeaponDefinition.WEAK_DAMAGE),
			new WeaponDefinition(Resources.TwoBullets, 9, 1, Resources.GunSound1, WeaponDefinition.STRONG_DAMAGE),
			new WeaponDefinition(Resources.TwoBullets, 10, 0.6, Resources.GunSound1, WeaponDefinition.STRONG_DAMAGE),
			new WeaponDefinition(Resources.OneBullet, 7, 1.7, Resources.AntiAircraftSound, WeaponDefinition.HARD_DAMAGE),
			new WeaponDefinition(Resources.ThreeBullets, 12, 0.4, Resources.GunSound1, WeaponDefinition.STRONG_DAMAGE)
		];
		
		private static var _inst:Level1 = new Level1();
		
		public static function get inst():Level1
		{
			return _inst;
		} 

		public static function setInst():void
		{
			_inst = new Level1();
		} 
		
		public function Level1()
		{
		}
		
		public function startUp():void{
			timeToNextElement = 0;
			timeToNextCloud = 0;
			timeToNextEnemy = 0;
		}
		
		//add new elements if needed
		public function updateProperties(time:Number):void
		{
			timeToNextElement -= time; //update time after each frame
			if(timeToNextElement <= 0)
			{
				timeToNextElement = TIME_BETWEEN_ELEMENTS_DISPLAY; //start over
				
				//get next random graphics
				var graphics:GraphicsResource = bgElementGraphics[MathUtils.randomInteger(0, MainManager.inst.kills < ENEMY_KILLS_COUNT[1] ? (bgElementGraphics.length-5) : 
					MainManager.inst.kills < ENEMY_KILLS_COUNT[2] ? (bgElementGraphics.length-3) : (bgElementGraphics.length))] as GraphicsResource;
				
				//get next available background element (or create if none available)
				var bgElement:BackgroundElement = BackgroundElement.pool.getItem() as BackgroundElement;
				bgElement.startUp(graphics, new Point(Math.random() * getGameWidth(), -graphics.bitmap.height), GameZOrders.BACKGROUND, BACKGROUND_SPEED);
			}
			
			timeToNextEnemy -= time;
			if(timeToNextEnemy <= 0)
			{
				timeToNextEnemy = MainManager.inst.kills < ENEMY_KILLS_COUNT[4] || MainManager.inst.masterEnemy ? TIME_BETWEEN_ENEMIES_START : TIME_BETWEEN_ENEMIES_END;
				
				var enemyGraphic:GraphicsResource;
				
				if (MainManager.inst.kills < ENEMY_KILLS_COUNT[2])
				{
					enemyGraphic = enemyGraphics[MathUtils.randomInteger(0, enemyGraphics.length-9)] as GraphicsResource;
				}
				else if (MainManager.inst.kills < ENEMY_KILLS_COUNT[3])
				{
					enemyGraphic = enemyGraphics[MathUtils.randomInteger(3, enemyGraphics.length-4)] as GraphicsResource;
				}
				else if (MainManager.inst.kills < ENEMY_KILLS_COUNT[5])
				{
					// include anti-aircraft enemy
					enemyGraphic = enemyGraphics[MathUtils.randomInteger(3, enemyGraphics.length-2)] as GraphicsResource;
				}
				else
				{
					// include only smaller master enemies - alongside with master enemy
					// like help enemies to the  master :)
					enemyGraphic = Resources.AircraftMasterHelp;
				}
				
				var enemyElement:Enemy = Enemy.pool.getItem() as Enemy;
				if (MainManager.inst.kills == ENEMY_KILLS_COUNT[5] && !MainManager.inst.masterEnemy)
				{
					// set master enemy
					enemyGraphic = Resources.MasterEnemy;
					MainManager.inst.masterEnemy = enemyElement;
					
					// set missile weapon damage to lower value
					MainManager.inst.missileWeapon.damage = WeaponDefinition.LOW_DAMAGE;
					MainManager.inst.player.weapon.damage = WeaponDefinition.STRONG_DAMAGE;
					
					//stop gameplay sound
					SoundUtils.stop();
					// play duel music sound
					SoundUtils.playMusic(Resources.DuelSound, 2);
				}
				
				var isAntiAirCraft:Boolean = Enemy.getDifficultyLevel(enemyGraphic) == Enemy.VETERAN_LEVEL;
				if (isAntiAirCraft)
				{
					var aaBgGraphic:GraphicsResource = BackgroundElement.getAircraftIslands()[MathUtils.randomInteger(0, BackgroundElement.getAircraftIslands().length)] as GraphicsResource;
					var antiAicraftBackground:BackgroundElement = BackgroundElement.pool.getItem() as BackgroundElement;
					antiAicraftBackground.startUp(aaBgGraphic, 
						new Point(Math.random() * getGameWidth() * 0.45, -aaBgGraphic.bitmap.height), 
						GameZOrders.BACKGROUND, 
						BACKGROUND_SPEED);
					
					// set anti-aircraft enemy position only if its background object is still active
					if (antiAicraftBackground.active)
					{
						enemyElement.startUpEnemy(enemyGraphic, 
							new Point(antiAicraftBackground.position.x + (antiAicraftBackground.width - enemyGraphic.bitmap.width)/2,
								antiAicraftBackground.position.y + (antiAicraftBackground.height -enemyGraphic.bitmap.height)/2), 
							enemySpeeds[enemyGraphics.indexOf(enemyGraphic)],
							GameZOrders.BACKGROUND);
					}
				}
				else
				{
					enemyElement.startUpEnemy(enemyGraphic,
						new Point(Enemy.getDifficultyLevel(enemyGraphic) == Enemy.MASTER_LEVEL ? (getGameWidth() - enemyGraphic.bitmap.width)/2 : 
							Math.random() * getGameWidth(), -enemyGraphic.bitmap.height), 
						enemySpeeds[enemyGraphics.indexOf(enemyGraphic)],
						GameZOrders.PLAYER);
				}
				
				
				MainManager.inst.enemyCount++;
			}
			
			timeToNextCloud -= time;
			if(timeToNextCloud <= 0){
				timeToNextCloud = TIME_BETWEEN_CLOUDS_DISPLAY;
				
				var clElement:BackgroundElement = BackgroundElement.pool.getItem() as BackgroundElement;
				var cloudZ:int = MathUtils.randomInteger(0, 10) % 2 != 0 ? GameZOrders.CLOUDS_ABOVE : GameZOrders.CLOUDS_BELOW;
				clElement.startUp(Resources.CloudGraphics, new Point(Math.random() * getGameWidth(), - Resources.CloudGraphics.bitmap.height), 
					cloudZ, 
					cloudZ == GameZOrders.CLOUDS_ABOVE ? UPPER_CLOUD_SPEED : LOWER_CLOUD_SPEED);
			}
		}
		
	}
} 