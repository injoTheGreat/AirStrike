package game.objects
{
	import flash.geom.Point;
	import flash.sampler.startSampling;
	
	import game.Resources;
	import game.utils.CollisionUtils;
	import game.utils.GraphicsResource;
	import game.utils.ObjectPool;
	import game.utils.getGameHeight;

	public class BackgroundElement extends GameObject
	{
		public static var pool:ObjectPool = new ObjectPool(createElement);
		
		// default value for most background 
		public static const NOT_COLLECTED_ITEM:int = -1;
		public static const PICK_UP_AMMO_ITEM:int = 1;
		public static const PICK_UP_WEAPON_ITEM:int = 2;
		public static const PICK_UP_ENERGY_ITEM:int = 3;
		
		private var _collisionType:String;

		public var speed:Number = 0;
		public var pickUpType:int;
		
		public function BackgroundElement()
		{
			super();
		}
		
		private static function createElement():GameObject{
			return new BackgroundElement();
		}
		
		public function startUp(graphics:GraphicsResource, position:Point, z:int, speed:Number, collision:String = CollisionUtils.COLLISION_NA, pickUpType:int = NOT_COLLECTED_ITEM):void
		{
			this.speed = speed;
			this._collisionType = collision;
			this.pickUpType = pickUpType;
			
			initialize(graphics, position, z);
		}
		
		public override function updateProperties(time:Number):void{
			if(position.y > getGameHeight()){
				dispose();
			}
			position.y += speed * time;
		}
		
		public override function get collisionType():String
		{
			return _collisionType;
		}
		
		public override function handleCollision(collideWithObject:GameObject):void
		{
			// removes background (ammunition/weapon pick up) element from display stage
			this.dispose();
		}
		
		public static function getPickUpGraphicMap(type:int):GraphicsResource
		{
			if (type == PICK_UP_AMMO_ITEM)
			{
				return Resources.AmmoBoxItem;
			}
			if (type == PICK_UP_WEAPON_ITEM)
			{
				return Resources.Weapon2BulletsItem;
			}
			
			return Resources.HelpItem;
		}
	}
}