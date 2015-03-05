package game.levels
{
	import flash.geom.Point;
	import flash.ui.GameInput;
	
	import mx.collections.ArrayCollection;
	import mx.utils.object_proxy;
	
	import game.Resources;
	import game.objects.BackgroundElement;
	import game.objects.Enemy;
	import game.objects.GameZOrders;
	import game.objects.WeaponDefinition;
	import game.utils.GraphicsResource;
	import game.utils.MathUtils;
	import game.utils.getGameWidth;

	public class Level1
	{
		private var bgElementGraphics:Array = [	
			Resources.BigIslandGraphics,
			Resources.SmallIslandGraphics,
			Resources.VolcanoIslandGraphics
		];
		
		private var enemyGraphics:Array = [
			Resources.WhiteEnemy,
			Resources.BlueEnemy,
			Resources.GreenEnemy
		];
		
		private var enemySpeeds:Array = [
			Enemy.WHITE_PLANE_SPEED,
			Enemy.BLUE_PLANE_SPEED,
			Enemy.GREEN_PLANE_SPEED
		];
		
		private const TIME_BETWEEN_ELEMENTS_DISPLAY:int = 3;
		private const TIME_BETWEEN_CLOUDS_DISPLAY:int = 2.5;
		private const TIME_BETWEEN_ENEMIES:int = 2;
		
		private var timeToNextElement:Number = 0;
		private var timeToNextCloud:Number = 0;
		private var timeToNextEnemy:Number = 0;
		
		
		public static const BACKGROUND_SPEED:Number = 40;
		public static const UPPER_CLOUD_SPEED:Number = 90;
		public static const LOWER_CLOUD_SPEED:Number = 70;
		
		public var weapons:Array = [
			new WeaponDefinition(Resources.RoundBullets, 7, 1.3, Resources.GunSound2, WeaponDefinition.ENEMY_MEDIUM_DAMAGE),
			new WeaponDefinition(Resources.TwoBullets, 10, 0.4, Resources.GunSound1),			
			new WeaponDefinition(Resources.OneBullet, 6, 2.2, Resources.EnemyOneShot, WeaponDefinition.PLAYER_DAMAGE)
			];
		
		private static var _inst:Level1 = new Level1();
		
		public static function get inst():Level1{
			return _inst;
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
		public function updateProperties(time:Number):void{
			
			timeToNextElement -= time; //update time after each frame
			if(timeToNextElement <= 0){
				timeToNextElement = TIME_BETWEEN_ELEMENTS_DISPLAY; //start over
				
				//get next random graphics
				var graphics:GraphicsResource = bgElementGraphics[MathUtils.randomInteger(0, bgElementGraphics.length)] as GraphicsResource;
				
				//get next available background element (or create if none available)
				var bgElement:BackgroundElement = BackgroundElement.pool.getItem() as BackgroundElement;
				bgElement.startUp(graphics, new Point(Math.random() * getGameWidth(), -graphics.bitmap.height), GameZOrders.BACKGROUND, BACKGROUND_SPEED);
			}
			
			timeToNextEnemy -= time;
			if(timeToNextEnemy <= 0){
				timeToNextEnemy = TIME_BETWEEN_ENEMIES;
				
				var enemyGraphic:GraphicsResource = enemyGraphics[MathUtils.randomInteger(0, enemyGraphics.length)] as GraphicsResource;
				var enemyElement:Enemy = Enemy.pool.getItem() as Enemy;
				enemyElement.startUpEnemy(enemyGraphic, 
					new Point(Math.random() * getGameWidth(), -enemyGraphic.bitmap.height), 
					enemySpeeds[enemyGraphics.indexOf(enemyGraphic)]);
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