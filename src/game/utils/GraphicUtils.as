package game.utils
{
	import flash.geom.Point;
	
	import game.objects.AnimatedGameObject;

	public class GraphicUtils
	{
		public static function createAnimation(graphics:GraphicsResource, position:Point, zOrder:int, loop:Boolean = true):void{
			var animation:AnimatedGameObject = AnimatedGameObject.pool.getItem() as AnimatedGameObject;
			
			animation.startUp(graphics, position, zOrder, !loop);
		}
	
	}
}