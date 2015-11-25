package game.objects
{
	import mx.core.SoundAsset;
	
	import game.utils.GraphicsResource;

	public class WeaponDefinition
	{
		public static const TOTAL_DAMAGE:Number = 1;
		public static const HARD_DAMAGE:Number = 0.5;
		public static const STRONG_DAMAGE:Number = 0.334;
		public static const WEAK_DAMAGE:Number = 0.25;
		// this is planned for rocket damage when master enemy is on the stage
		public static const LOW_DAMAGE:Number = 0.1;
		// this is planned for master enemy damage
		public static const VERY_LOW_DAMAGE:Number = 0.033;
		
		public static const ONE_BULLET_SHOT:uint = 1;
		public static const TWO_BULLETS_SHOT:uint = 2;
		public static const THREE_BULLETS_SHOT:uint = 3;
		
		public static const DEFAULT_AMMO:uint = 100;
		public static const MISSILE_DEFAULT_AMMO:uint = 5;
		
		public var timeBetweenBullets:Number;
		public var graphics:GraphicsResource;
		public var bulletSpeed:Number;
		public var damage:Number;
		
		private var _fullAmmo:int;
		[Bindable]
		public var ammunition:int;
		public var bulletsPerShot:uint;
		
		public var collected:Boolean = false;
		public var sound:SoundAsset;
		
		public function WeaponDefinition(graphics:GraphicsResource, bulletSpeed:Number, bulletInterval:Number, sound:SoundAsset, damage:Number = TOTAL_DAMAGE, bulletsPerShot:uint = ONE_BULLET_SHOT, isMissile:Boolean = false){
			this.timeBetweenBullets = bulletInterval;
			this.graphics = graphics;
			this.bulletSpeed = bulletSpeed;
			this.damage = damage;
			this.bulletsPerShot = bulletsPerShot;
			this.sound = sound;
			
			if (isMissile)
			{
				this._fullAmmo = MISSILE_DEFAULT_AMMO * bulletsPerShot;
			}
			else
			{
				this.ammunition = DEFAULT_AMMO;
				this._fullAmmo = this.ammunition *= bulletsPerShot;
			}
		}
		
		public function get fullAmmo():int
		{
			return _fullAmmo;
		}
	}
}