import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Mouse;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

import game.MainManager;
import game.Resources;
import game.events.CollectItemEvent;
import game.utils.SoundUtils;

[Embed(source="/assets/images/sound_on.png")]
private static const SOUND_ON:Class;

[Embed(source="/assets/images/sound_off.png")]
private static const SOUND_OFF:Class;

[Embed(source="/assets/images/energy1.png")]
private static const PLAYER_ENERGY:Class;


private var _gameStarted:Boolean = false;
private var _keyCodes:ArrayCollection = new ArrayCollection();

[Bindable]
private var _weaponImage:BitmapData = MainManager.inst.playerWeapon.graphics.bitmap;

//application created
protected function appCreationComplete(event:FlexEvent):void
{
	Mouse.hide();
	MainManager.inst.init(gamePanel.width, gamePanel.height);
	
	_gameStarted = true;
	
	/*gamePanel.graphics.clear();
	gamePanel.graphics.beginBitmapFill(MainManager.inst.backBuffer);
	gamePanel.graphics.drawRect(0, 0, gamePanel.width, gamePanel.height);
	gamePanel.graphics.endFill();*/
	
}

//enter frame handler
protected function onEnterFrame(event:Event):void
{
	if (_gameStarted)
	{
		if (_keyCodes.length > 0)
		{
			MainManager.inst.keyDown(_keyCodes.toArray());
		}
		
		MainManager.inst.render();
		
		gamePanel.graphics.clear();
		gamePanel.graphics.beginBitmapFill(MainManager.inst.backBuffer);
		gamePanel.graphics.drawRect(0, 0, gamePanel.width, gamePanel.height);
		gamePanel.graphics.endFill();
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
	if (!_keyCodes.contains(event.keyCode))
		_keyCodes.addItem(event.keyCode);
}

protected function onKeyUp(event:KeyboardEvent):void
{
	if (_keyCodes.contains(event.keyCode))
	{
		_keyCodes.removeItemAt(_keyCodes.getItemIndex(event.keyCode))
	}
}

protected function onAppCompleted(event:FlexEvent):void
{
	stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	
	MainManager.inst.eventHandler.addEventListener(CollectItemEvent.PLAYER_WEAPON_CHANGED, collectItemHandler);
	MainManager.inst.eventHandler.addEventListener(CollectItemEvent.AMMUNITION_RELOAD, collectItemHandler);
	MainManager.inst.eventHandler.addEventListener(CollectItemEvent.PLAYER_ENERGY_REFILL, collectItemHandler);
}

protected function gameSound_clickHandler(event:MouseEvent):void
{
	if (MainManager.inst.soundEnabled)
	{
		gameSound.source = new SOUND_OFF().bitmapData;
	}
	else
	{
		gameSound.source = new SOUND_ON().bitmapData;
	}
	
	MainManager.inst.soundEnabled = !MainManager.inst.soundEnabled;
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
			MainManager.inst.playerWeapon = ev.weapon;
			
			// play pick up weapon item sound
			SoundUtils.play(Resources.PickUpItemSound);
			
			_weaponImage = ev.weapon.graphics.bitmap;
			
			break;
		}
		case CollectItemEvent.AMMUNITION_RELOAD:
		{
			// reload weapon ammuntion
			ev.weapon.ammunition = ev.weapon.fullAmmo;
			
			// play pick up ammunition item sound
			SoundUtils.play(Resources.PickUpItem2Sound);
			
			break;
		}
		case CollectItemEvent.PLAYER_ENERGY_REFILL:
		{
			// refill player energy
			MainManager.inst.player.energy = 1;
			
			// play pick up ammunition item sound
			SoundUtils.play(Resources.PickUpItem1Sound);
			
			break;
		}
			
		default:
		{
			throw new ArgumentError("such event type of CollectItemEvent is not defined");
			break;
		}
	}
	/*if (ev.type == CollectItemEvent.PLAYER_WEAPON_CHANGED)
	{
		// set collected status
		ev.weapon.collected = true;
		
		// set player's current weapon
		MainManager.inst.playerWeapon = ev.weapon;
		
		// play pick up weapon item sound
		SoundUtils.play(Resources.PickUpItemSound);
		
		_weaponImage = ev.weapon.graphics.bitmap;
	}
	else if (ev.type == CollectItemEvent.AMMUNITION_RELOAD)
	{
		// reload weapon ammuntion
		ev.weapon.ammunition = ev.weapon.fullAmmo;
		
		// play pick up ammunition item sound
		SoundUtils.play(Resources.PickUpItem2Sound);
	}*/
	
}