package game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.startSampling;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.utils.object_proxy;
	
	import game.events.ChangeScoreEvent;
	import game.events.CollectItemEvent;
	import game.levels.Level1;
	import game.objects.BackgroundElement;
	import game.objects.Bullet;
	import game.objects.Enemy;
	import game.objects.GameObject;
	import game.objects.GameZOrders;
	import game.objects.WarriorPlane;
	import game.objects.WeaponDefinition;
	import game.objects.interfaces.IInteractiveObject;
	import game.utils.CollisionUtils;
	import game.utils.GraphicsResource;

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
		
		[Bindable]
		public var score:int = 0;
		
		[Bindable]
		public var player:WarriorPlane = new WarriorPlane();
		
		// indicates displayed pickUp item
		public var pickUpItem:BackgroundElement;
		public var soundEnabled:Boolean = true;
		//date for time lapse
		private var _lastTime:Date;

		private var _objects:ArrayCollection = new ArrayCollection();
		private var _removedObjects:ArrayCollection = new ArrayCollection();
		private var _insertedObjects:ArrayCollection = new ArrayCollection();
		private var _interactiveObjects:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var playerWeapon:WeaponDefinition = Level1.inst.weapons[0];
		public var enemyWeapon:WeaponDefinition = Level1.inst.weapons[2];
		
		public var eventHandler:EventDispatcher = new EventDispatcher();


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

			player.startUpWarrior();
			
			this.eventHandler.addEventListener(ChangeScoreEvent.UPDATE_SCORE, updateScore);
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
			
			if(keyCodes.indexOf(Keyboard.NUMBER_1)>-1 && playerWeapon != Level1.inst.weapons[0])
			{
				this.eventHandler.dispatchEvent(new CollectItemEvent(CollectItemEvent.PLAYER_WEAPON_CHANGED, Level1.inst.weapons[0]));
			}
			else if(keyCodes.indexOf(Keyboard.NUMBER_2) > -1 && playerWeapon != Level1.inst.weapons[1] && Level1.inst.weapons[1].collected)
			{
				this.eventHandler.dispatchEvent(new CollectItemEvent(CollectItemEvent.PLAYER_WEAPON_CHANGED, Level1.inst.weapons[1]));
			}
			
			for each (var interactive:IInteractiveObject in _interactiveObjects)
			{
				interactive.keyDown(keyCodes);
			}
		}
		
		/**
		 * Calculates and updates player game score
		 * @param ev indicates ChangeScoreEvent type
		 * 
		 */		
		protected function updateScore(ev:ChangeScoreEvent):void
		{
			this.score += ev.isEnemyKilled ? this.playerWeapon.damage * Level1.DEFAULT_SCORE : Level1.ITEM_SCORE;
		}
		
		/**
		 * Checks if destoyed object can be replaced with pick up item.<br/> 
		 * Pick up item can be - new weapon or ammunition reloading item
		 * @param destroyedObject indicates game object that has been destroyed
		 * 
		 */			
		public function checkForPickUpItem(destroyedObject:GameObject):void
		{
			var destroyedObjectPos:Point = new Point(destroyedObject.position.x, destroyedObject.position.y);
		
			if (this.score == Level1.PICK_UP_WEAPON_SCORE)
			{
				// replace enemy with new weapon item
				insertPickUpItem(destroyedObjectPos);
			}
			// check if current weapon ammunition is equal to 10% of the full ammunition
			else if (this.playerWeapon.ammunition <= this.playerWeapon.fullAmmo * 0.1 && this.kills % 5 <= 2)
			{
				// replace enemy with reload ammunition item 
				insertPickUpItem(destroyedObjectPos, BackgroundElement.PICK_UP_AMMO_ITEM)
			}
			// replace enemy with energy pick up item
			else if (this.player.energy <= 0.5 && this.score > Level1.PICK_UP_WEAPON_SCORE)
			{
				insertPickUpItem(destroyedObjectPos, BackgroundElement.PICK_UP_ENERGY_ITEM);
			}
		}
		
		/**
		 * Adds picUp item to display stage instead of destoyed game object - killed enemy, etc.
		 * @param position indicates killed enemy (destroyed object) position
		 * @param type indicates pick up item type
		 * 
		 */		 
		public function insertPickUpItem(position:Point, type:int = BackgroundElement.PICK_UP_WEAPON_ITEM):void
		{
			var graphic:GraphicsResource = BackgroundElement.getPickUpGraphicMap(type);
			pickUpItem = BackgroundElement.pool.getItem() as BackgroundElement;
			pickUpItem.startUp(graphic, position, GameZOrders.PLAYER, Level1.AMMO_ITEM_SPEED, CollisionUtils.COLLISION_PICK_UP_ITEM, type);
		}
	}
}
