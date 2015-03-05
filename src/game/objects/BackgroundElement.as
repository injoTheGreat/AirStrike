package game.objects
{
	import flash.geom.Point;
	import flash.sampler.startSampling;
	
	import game.utils.GraphicsResource;
	import game.utils.ObjectPool;
	import game.utils.getGameHeight;

	public class BackgroundElement extends GameObject
	{
		public static var pool:ObjectPool = new ObjectPool(createElement);
		public var speed:Number = 0;
		
		public function BackgroundElement()
		{
			super();
		}
		
		private static function createElement():GameObject{
			return new BackgroundElement();
		}
		
		public function startUp(graphics:GraphicsResource, position:Point, z:int, speed:Number):void
		{
			this.speed = speed;
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
			return super.collisionType;
		}
		
	}
}