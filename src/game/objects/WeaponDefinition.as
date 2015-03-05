package game.objects
{
	import mx.core.SoundAsset;
	
	import game.utils.GraphicsResource;

	public class WeaponDefinition
	{
		public static const PLAYER_DAMAGE:Number = 0.25;
		public static const ENEMY_EASY_DAMAGE:Number = 1;
		public static const ENEMY_MEDIUM_DAMAGE:Number = 0.5;
		public static const ENEMY_HARD_DAMAGE:Number = 0.333;
		
		public var timeBetweenBullets:Number;
		public var graphics:GraphicsResource;
		public var bulletSpeed:Number;
		public var damage:Number;
		public var sound:SoundAsset;
		
		public function WeaponDefinition(graphics:GraphicsResource, bulletSpeed:Number, bulletInterval:Number, sound:SoundAsset, damage:Number = ENEMY_EASY_DAMAGE){
			this.timeBetweenBullets = bulletInterval;
			this.graphics = graphics;
			this.bulletSpeed = bulletSpeed;
			this.damage = damage;
			this.sound = sound;
		}
	}
}