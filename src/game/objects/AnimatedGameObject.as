package game.objects
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.Resources;
	import game.utils.GraphicsResource;
	import game.utils.ObjectPool;
	
	public class AnimatedGameObject extends GameObject
	{
		public static var pool:ObjectPool = new ObjectPool(createAnimatedObject);
		
		protected var frameTime:Number = 0;
		protected var frameWidth:Number = 0;
		protected var currentFrame:int = 0;
		protected var playOnce:Boolean = false;
		
		private var frameRect:Rectangle = null;
		
		public function AnimatedGameObject()
		{
			super();
		}
		
		private static function createAnimatedObject():GameObject{
			return new AnimatedGameObject();
		}
		
		public function startUp(graphics:GraphicsResource, position:Point, z:int = 0, playOnce:Boolean = false):void
		{			
			this.playOnce = playOnce;			
			this.frameWidth = graphics.bitmap.width / graphics.frames;
		
			initialize(graphics, position, z);
			
			sequenceBD = new BitmapData(frameWidth, graphics.bitmap.height, true, 0x00FFFFFF);
			alphaBD = new BitmapData(frameWidth, sequenceBD.height, true);
			defRect = new Rectangle(0, 0, frameWidth, sequenceBD.height);
			frameRect =  new Rectangle(0, 0, frameWidth, graphics.bitmap.height);
		}
		
		public override function updateProperties(time:Number):void{
			super.updateProperties(time);
			if(active)
			{
				frameTime += time;
				if (graphics.fps != -1)
				{
					var fpsTime:Number = 1/graphics.fps;
					
					while (frameTime > fpsTime)
					{
						frameTime -= fpsTime;
						currentFrame = (currentFrame + 1) % graphics.frames;
						if (currentFrame == 0 && playOnce)
						{
							dispose();
							break;
						}
					}
				}
			}
		}
		
		
	    public override function copyToBackBuffer(db:BitmapData):void
		{
			if (active)
			{
				if(sequenceBD) sequenceBD.dispose();
				sequenceBD = new BitmapData(frameWidth, graphics.bitmap.height, true, 0x00FFFFFF);
			    frameRect.x = currentFrame * frameWidth;
				//db.copyPixels(graphics.bitmap, drawRect, position, graphics.bitmapAlpha, new Point(drawRect.x, 0), true);
				
				rotateToPosition();
				
				sequenceBD.copyPixels(graphics.bitmap, frameRect, new Point(0,0), graphics.bitmapAlpha, new Point(frameRect.x, 0), true);
				
				alphaBD.draw(sequenceBD, rotationMatrix, null, BlendMode.ALPHA);
				var rotatedBD:BitmapData = new BitmapData(frameWidth, sequenceBD.height, true, 0x00FFFFFF);
				
				rotatedBD.draw(sequenceBD, rotationMatrix);
				
				db.copyPixels(rotatedBD, defRect, position, alphaBD, new Point(0, 0), true);
			}
		}
		
		override protected function setupBoundingBox():void
		{
			box = new Rectangle(0, 0, frameWidth, graphics.bitmap.height);
		}
		
		public override function get width():Number
		{
			return frameWidth;
		}			
	}
}