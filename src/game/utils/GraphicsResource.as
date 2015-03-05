package game.utils
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;

    public class GraphicsResource
    {
        //bitmap data copied from given image (display object)
        //both are used in copyPixel methods
        public var bitmap:BitmapData = null;
        public var bitmapAlpha:BitmapData = null;
		
		
		public var frames:int = 1;
		public var fps:Number = 0;

        public function GraphicsResource(image:DisplayObject, frames:int = 1, fps:Number = 0)
        {
            bitmap = createBitmapData(image);
            bitmapAlpha = createAlphaBitmapData(image);
			
			this.frames = frames;
			this.fps = fps;
        }

        protected function createBitmapData(image:DisplayObject):BitmapData
        {
            var bitmap:BitmapData = new BitmapData(image.width, image.height);
            bitmap.draw(image);

            return bitmap;

        }

        protected function createAlphaBitmapData(image:DisplayObject):BitmapData
        {
            var bitmap:BitmapData = new BitmapData(image.width, image.height);
            bitmap.draw(image, null, null, flash.display.BlendMode.ALPHA);

            return bitmap;
        }
    }
}
