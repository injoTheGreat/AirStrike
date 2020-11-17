import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import flash.ui.Mouse;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

import game.MainManager;
import game.Resources;
import game.events.CollectItemEvent;
import game.levels.Level1;
import game.objects.WeaponDefinition;
import game.utils.SoundUtils;

[Embed(source="/assets/images/energy1.png")]
private static const PlayerEnergy:Class;
[Embed(source="/assets/images/airplanes/longsword_fighter.png")]
private static const EnemyEnergy:Class;
[Embed(source="/assets/images/weapons/rocket_straight_up.png")]
private static const RocketWeapon:Class;

private static const PLAYER_ENERGY:Bitmap = new PlayerEnergy();
private static const MASTER_ENERGY:Bitmap = new EnemyEnergy();
private static const ROCKET_WEAPON:Bitmap = new RocketWeapon();


private var _keyCodes:ArrayCollection = new ArrayCollection();

public var gameStarted:Boolean = false;

[Bindable]
private var _gamePaused:Boolean = false; 

[Bindable]
private var _weaponImage:BitmapData = MainManager.inst.player.weapon.graphics.bitmap;

[Bindable]
private var _rocketWeaponEnabled:Boolean = false;


protected function onInit(event:FlexEvent):void
{
	MainManager.inst.eventHandler.addEventListener(CollectItemEvent.PLAYER_WEAPON_CHANGED, collectItemHandler);
	MainManager.inst.eventHandler.addEventListener(CollectItemEvent.AMMUNITION_RELOAD, collectItemHandler);
	MainManager.inst.eventHandler.addEventListener(CollectItemEvent.PLAYER_ENERGY_REFILL, collectItemHandler);
	MainManager.inst.eventHandler.addEventListener(CollectItemEvent.MISSILE_AMUNITION_COLLECTED, collectItemHandler);
}

protected function onCreationComplete(event:FlexEvent):void
{
	stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

	Mouse.hide();
	MainManager.inst.init(this.width, this.height);
	
	gameStarted = true;
	
	/*this.graphics.clear();
	this.graphics.beginBitmapFill(MainManager.inst.backBuffer);
	this.graphics.drawRect(0, 0, this.width, this.height);
	this.graphics.endFill();*/
	
}

//enter frame handler
protected function onEnterFrame(event:Event):void
{
	if (gameStarted && !_gamePaused && !MainManager.inst.gameOver)
	{
		if (_keyCodes.length > 0)
		{
			MainManager.inst.keyDown(_keyCodes.toArray());
		}
		
		MainManager.inst.render();
		
		this.graphics.clear();
		this.graphics.beginBitmapFill(MainManager.inst.backBuffer);
		this.graphics.drawRect(0, 0, this.width, this.height);
		this.graphics.endFill();
	}
}

protected function onClick(event:MouseEvent):void
{
	MainManager.inst.mouseClick(event);
}

protected function onMouseMove(event:MouseEvent):void
{
	MainManager.inst.mouseMove(event);
}

protected function onMouseUp(event:MouseEvent):void
{
	MainManager.inst.mouseUp(event);
}

protected function onMouseDown(event:MouseEvent):void
{
	MainManager.inst.mouseDown(event);
}

protected function onKeyDown(event:KeyboardEvent):void
{
	if (!_keyCodes.contains(event.keyCode) && this.enabled)
	{
		_keyCodes.addItem(event.keyCode);
		
		if (event.keyCode == Keyboard.M)
		{
			// mute/unmute sound
			gameSound.setGameSound(null);
		}
		
		if (event.keyCode == Keyboard.P)
		{
			// pause/unPause game
			_gamePaused = !_gamePaused;
		}
		
		if (event.keyCode == Keyboard.SPACE)
		{
			MainManager.inst.isMissileLaunched = true;	
		}
	
		if (event.keyCode == Keyboard.Q)
		{
			// player cheatting - increasing ammunition
			// TODO: this is temporarily, for developing phase only
			collectItemHandler(new CollectItemEvent(CollectItemEvent.AMMUNITION_RELOAD));	
		}

		if (event.keyCode == Keyboard.CONTROL)
		{
			// player can also use CTRL key for shooting
			MainManager.inst.mouseDown(new MouseEvent(MouseEvent.MOUSE_DOWN));	
		}
		
	}
}

protected function onKeyUp(event:KeyboardEvent):void
{	
	if (_keyCodes.contains(event.keyCode))
	{
		_keyCodes.removeItemAt(_keyCodes.getItemIndex(event.keyCode))
	}
}

/**
 * Player collects item - ammunition reload or weapon changed  
 * @param ev indicates CollectItemEvent event
 * 
 */	
protected function collectItemHandler(ev:CollectItemEvent):void
{
	switch(ev.type)
	{
		case CollectItemEvent.PLAYER_WEAPON_CHANGED:
		{
			// set collected status
			ev.weapon.collected = true;
			
			// set player's current weapon
			MainManager.inst.player.weapon = ev.weapon;
			
			// play pick up weapon item sound
			SoundUtils.playSFX(Resources.PickUpItemSound);
			
			_weaponImage = ev.weapon.graphics.bitmap;
			
			break;
		}
		case CollectItemEvent.AMMUNITION_RELOAD:
		case CollectItemEvent.MISSILE_AMUNITION_COLLECTED:
		{
			// reload weapon ammuntion
			if (ev.type == CollectItemEvent.AMMUNITION_RELOAD)
			{
				for each (var weapon:WeaponDefinition in Level1.inst.playerWeapons)
				{
					weapon.ammunition = weapon.fullAmmo;
				}
			}
			else if (ev.type == CollectItemEvent.MISSILE_AMUNITION_COLLECTED)
			{
				ev.weapon.ammunition = ev.weapon.fullAmmo;
				
				_rocketWeaponEnabled = true;
			}
			
			// play pick up ammunition item sound
			SoundUtils.playSFX(Resources.PickUpItem2Sound);
			
//			if (ev.type == CollectItemEvent.MISSILE_AMUNITION_COLLECTED)
			
			break;
		}
		case CollectItemEvent.PLAYER_ENERGY_REFILL:
		{
			// refill player energy
			MainManager.inst.player.energy = 1;
			
			// play pick up energy item sound
			SoundUtils.playSFX(Resources.PickUpItem1Sound);
			
			break;
		}
		default:
		{
			throw new ArgumentError("such event type of CollectItemEvent is not defined");
			break;
		}
	}
}
