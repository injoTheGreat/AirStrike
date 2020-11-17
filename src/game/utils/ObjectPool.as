package game.utils
{
	import game.objects.GameObject;
	
	import mx.collections.ArrayCollection;

	/**
	 * Object pool, returns first inactive object or returns a brand new instance object 
	 * 
	 */	
	public class ObjectPool
	{
		private var _objects:ArrayCollection = new ArrayCollection();
		private var _objectBuilder:Function = null;
		
		public function ObjectPool(objectBuilder:Function)
		{
			_objectBuilder = objectBuilder;
		}
		
		public function getItem():GameObject{
			for each(var object:GameObject in _objects){
				if(!object.active)
				{
					object.energy = 1;
					return object;
				}
			}
			var newObject:GameObject = _objectBuilder();
			_objects.addItem(newObject);
			return newObject;
		}
	}
}