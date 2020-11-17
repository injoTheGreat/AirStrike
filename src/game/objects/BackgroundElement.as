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
		public static const PICK_UP_WEAPON_ITEM_2BULLETS:int = 2;
		public static const PICK_UP_WEAPON_ITEM_3BULLETS:int = 3;
		public static const PICK_UP_ENERGY_ITEM:int = 4;
		public static const PICK_UP_MISSILE_ITEM:int = 5;
		
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
			// removes background element from display stage
			this.dispose();
		}
		
		public static function getPickUpGraphicMap(type:int):GraphicsResource
		{
			if (type == PICK_UP_ENERGY_ITEM)
			{
				return Resources.HelpItem;
			}
			if (type == PICK_UP_WEAPON_ITEM_2BULLETS)
			{
				return Resources.Weapon2BulletsItem;
			}
			if (type == PICK_UP_WEAPON_ITEM_3BULLETS)
			{
				return Resources.Weapon3BulletsItem;
			}
			if (type == PICK_UP_MISSILE_ITEM)
			{
				return Resources.MissileItem;
			}
			
			return Resources.AmmoBoxItem;
		}
		
		public static function getAircraftIslands():Array
		{
			return [Resources.BigIslandGraphics, Resources.BigIsland1Graphics, Resources.BigIsland2Graphics];
		}
	}
}