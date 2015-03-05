package game.objects
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import game.MainManager;
    import game.objects.interfaces.IDisposable;
    import game.utils.CollisionUtils;
    import game.utils.GraphicsResource;

    //base class for all displayable game objects
    public class GameObject implements IDisposable
    {
        public var position:Point = new Point(); //0,0 by default
        public var zOrder:int = 0;
        public var graphics:GraphicsResource = null;
        public var active:Boolean = false;
		
		// object will be disposed if energy comes to 0
		// depending of weapon damage value
		public var energy:Number = 1;
		
		protected var box:Rectangle = null;
	
		protected var direction:Point = null;
		
		protected var sequenceBD:BitmapData = null;
		protected var angle:Number = 0;
		protected var alphaBD:BitmapData = null;
		protected var rotationMatrix:Matrix = new Matrix();
		protected var defRect:Rectangle = null;
		protected var zeroPoint:Point = new Point(0,0);
        
        
        public function GameObject()
        {
        }
        
        //initialize object and add for rendering
        public function initialize(graphics:GraphicsResource, position:Point, z:int = 0):void{
            if(!active){
                this.graphics = graphics;
                this.position = position;
                this.zOrder = z;
                this.active = true;
				this.defRect = new Rectangle(0, 0, width, height);
				this.alphaBD = new BitmapData(width, height, true);
				setupBoundingBox();                
                MainManager.inst.addObject(this);
            }
        }
        
        //remove object from rendering
        public function dispose():void{
            if(active){
                this.active = false;
                this.graphics = null;
                
                MainManager.inst.removeObject(this);
            }
        }
        
        //draws graphics on background bitmap buffer
        public function copyToBackBuffer(background:BitmapData):void{	 
			if(sequenceBD) sequenceBD.dispose();
			sequenceBD = new BitmapData(width, height, true, 0x00FFFFFF);
			sequenceBD.copyPixels(graphics.bitmap, defRect, zeroPoint, graphics.bitmapAlpha, zeroPoint, true);
			
		    rotateToPosition();
			
			alphaBD.draw(sequenceBD, rotationMatrix, null, BlendMode.ALPHA);
			
			var rotatedBD:BitmapData = new BitmapData(width, height, true, 0x00FFFFFF);
			rotatedBD.draw(sequenceBD, rotationMatrix);
			
            background.copyPixels(rotatedBD, defRect, position, alphaBD, zeroPoint, true);
        }
        
		protected function rotateToPosition(pos:Point = null):Matrix{
			rotationMatrix.identity();
			rotationMatrix.translate(-width/2, -height/2);
			rotationMatrix.rotate(angle);
			if(!pos)
				rotationMatrix.translate(width/2, height/2);
			else
				rotationMatrix.translate(pos.x, pos.y);
			return rotationMatrix;
		}
        //update properties for every frame with given time
        public function updateProperties(time:Number):void{
            
        }
		
		public function get width():Number
		{
			return graphics ? graphics.bitmap.width : 0;
		}
		
		public function get height():Number
		{
			return graphics? graphics.bitmap.height : 0;
		}
		
		public function get boundingBox():Rectangle{
			box.x = position.x;
			box.y = position.y;
			return box;
		}
		
		public function get collisionType():String{
			return CollisionUtils.COLLISION_NA;
		}
		
		public function handleCollision(collideWithObject:GameObject):void{
			
		}
		
		protected function setupBoundingBox():void
		{
			box = new Rectangle(position.x, position.y, width, height);
		}
		
		public function set rotation(value:Number):void{
			angle = value;
		}
		
		public function get rotation():Number{
			return angle;
		}
		
    }
}