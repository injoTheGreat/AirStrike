package game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.sampler.startSampling;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.utils.object_proxy;
	
	import game.levels.Level1;
	import game.objects.Bullet;
	import game.objects.Enemy;
	import game.objects.GameObject;
	import game.objects.WarriorPlane;
	import game.objects.WeaponDefinition;
	import game.objects.interfaces.IInteractiveObject;
	import game.utils.CollisionUtils;

	public class MainManager implements IInteractiveObject
	{
		private static var _inst:MainManager = new MainManager();

		private static const BACK_COLOR:uint=0xFF0043AB;

		//background bitmap data
		public var backBuffer:BitmapData;

		public var frameTime:Number=0;
		public var gameWidth:Number;
		public var gameHeight:Number;

		[Bindable]
		public var kills:int = 0;
		
		public var soundEnabled:Boolean = true;
		//date for time lapse
		private var _lastTime:Date;

		private var _objects:ArrayCollection = new ArrayCollection();
		private var _removedObjects:ArrayCollection = new ArrayCollection();
		private var _insertedObjects:ArrayCollection = new ArrayCollection();
		private var _interactiveObjects:ArrayCollection = new ArrayCollection();
		
		public var playerWeapon:WeaponDefinition = Level1.inst.weapons[0];
		public var enemyWeapon:WeaponDefinition = Level1.inst.weapons[2];


		public function MainManager()
		{
		}

		public static function get inst():MainManager
		{
			return _inst;
		}

		//initialize manager
		public function init(width:Number, height:Number):void
		{
			backBuffer = new BitmapData(width, height, false);
			_lastTime = new Date();
			gameWidth = width;
			gameHeight = height;

			Level1.inst.startUp();

			new WarriorPlane().startUpWarrior();
		}

		//adds object for rendering
		public function addObject(gameObject:GameObject):void
		{
			_insertedObjects.addItem(gameObject);
		}

		//removes object from rendering
		public function removeObject(gameObject:GameObject):void
		{
			_removedObjects.addItem(gameObject);
		}

		//remove objects flagged for removal
		private function removeAllObjects():void
		{
			for each (var remObject:GameObject in _removedObjects)
			{
				var index:int=_objects.getItemIndex(remObject);
				if (index > -1)
				{
					_objects.removeItemAt(index);
				}
				if (remObject is IInteractiveObject && _interactiveObjects.contains(remObject))
				{
					_interactiveObjects.removeItemAt(_interactiveObjects.getItemIndex(remObject));
				}
			}
			_removedObjects.removeAll();
		}

		//inserts objects flagged for insertion
		private function insertAllObjects():void
		{
			for each (var gameObject:GameObject in _insertedObjects)
			{
				for (var i:int=0; i < _objects.length; ++i)
				{
					if (_objects.getItemAt(i).zOrder > gameObject.zOrder || _objects.getItemAt(i).zOrder == -1)
						break;
				}

				_objects.addItemAt(gameObject, i);
				if (gameObject is IInteractiveObject)
					_interactiveObjects.addItem(gameObject);
			}
			_insertedObjects.removeAll();
		}

		//updates properties for all objects for current game time
		private function updateObjectsForCurrentFrame():void
		{
			for each (var gameObject:GameObject in _objects)
			{
				if (gameObject.active)
					gameObject.updateProperties(frameTime);
			}
		}



		//frame loop
		public function render():void
		{
			frameTime = getFrameTime();

			removeAllObjects();
			insertAllObjects();
			Level1.inst.updateProperties(frameTime);
			checkCollisions();
			updateObjectsForCurrentFrame();
			renderObjects();
		}

		//renders background all game objects
		private function renderObjects():void
		{
			backBuffer.fillRect(backBuffer.rect, BACK_COLOR);

			for each (var gameObject:GameObject in _objects)
			{
				if (gameObject.active)
					gameObject.copyToBackBuffer(backBuffer);
			}
		}

		//checks for collisions
		private function checkCollisions():void
		{
			for (var i:int=0; i < _objects.length - 1; i++)
			{
				var iObject:GameObject=_objects.getItemAt(i) as GameObject;

				if (iObject.collisionType != CollisionUtils.COLLISION_NA)
				{
					for (var j:int=i + 1; j < _objects.length; j++)
					{
						//check for collision
						var jObject:GameObject=_objects.getItemAt(j) as GameObject;

						if (jObject.collisionType != CollisionUtils.COLLISION_NA && 
							(CollisionUtils.COLLISION_MAP[iObject.collisionType] as Array).indexOf(jObject.collisionType) > -1 && 
							iObject.active && jObject.active && 
							iObject.boundingBox.intersects(jObject.boundingBox))
						{
							iObject.handleCollision(jObject);
							jObject.handleCollision(iObject);
						}

					}
				}
			}
		}

		//gets seconds lapsed since last frame
		private function getFrameTime():Number
		{
			var now:Date = new Date();
			var seconds:Number = (now.time - _lastTime.time) / 1000;
			_lastTime = now;
			return seconds;
		}

		public function mouseClick(event:MouseEvent):void
		{
			//additional logic here

			for each (var interactive:IInteractiveObject in _interactiveObjects)
			{
				interactive.mouseClick(event);
			}
		}

		public function mouseUp(event:MouseEvent):void
		{
			//additional logic here

			for each (var interactive:IInteractiveObject in _interactiveObjects)
			{
				interactive.mouseUp(event);
			}
		}

		public function mouseDown(event:MouseEvent):void
		{
			//additional logic here

			for each (var interactive:IInteractiveObject in _interactiveObjects)
			{
				interactive.mouseDown(event);
			}
		}

		public function mouseMove(event:MouseEvent):void
		{
			//additional logic here

			for each (var interactive:IInteractiveObject in _interactiveObjects)
			{
				interactive.mouseMove(event);
			}
		}
		
		
		public function keyDown(keyCodes:Array):void
		{
			//additional logic here
			
			if(keyCodes.indexOf(Keyboard.NUMBER_1)>-1){
				playerWeapon = Level1.inst.weapons[0];
			}
			// TODO: add logic for collecting some point for second weapon to be enabled
			// message will be displayed 
			else if(keyCodes.indexOf(Keyboard.NUMBER_2) > -1){
				playerWeapon = Level1.inst.weapons[1];
			}
			
			
			for each (var interactive:IInteractiveObject in _interactiveObjects)
			{
				interactive.keyDown(keyCodes);
			}
		}
	}
}
