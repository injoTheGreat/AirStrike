package game.objects
{
	import mx.core.SoundAsset;
	
	import game.utils.GraphicsResource;

	public class WeaponDefinition
	{
		public static const TOTAL_DAMAGE:Number = 1;
		public static const HARD_DAMAGE:Number = 0.5;
		public static const LOW_DAMAGE:Number = 0.333;
		public static const VERY_LOW_DAMAGE:Number = 0.25;
		
		public static const ONE_BULLET_SHOT:uint = 1;
		public static const TWO_BULLETS_SHOT:uint = 2;
		public static const THREE_BULLETS_SHOT:uint = 3;
		
		public var timeBetweenBullets:Number;
		public var graphics:GraphicsResource;
		public var bulletSpeed:Number;
		public var damage:Number;
		
		private var _fullAmmo:int;
		[Bindable]
		public var ammunition:int = 50;
		public var bulletsPerShot:uint;
		
		public var collected:Boolean = false;
		public var sound:SoundAsset;
		
		public function WeaponDefinition(graphics:GraphicsResource, bulletSpeed:Number, bulletInterval:Number, sound:SoundAsset, damage:Number = TOTAL_DAMAGE, bulletsPerShot:uint = ONE_BULLET_SHOT){
			this.timeBetweenBullets = bulletInterval;
			this.graphics = graphics;
			this.bulletSpeed = bulletSpeed;
			this.damage = damage;
			this.bulletsPerShot = bulletsPerShot;
			this.sound = sound;
			
			this._fullAmmo = this.ammunition *= bulletsPerShot;
		}
		
		public function get fullAmmo():int
		{
			return _fullAmmo;
		}
	}
}