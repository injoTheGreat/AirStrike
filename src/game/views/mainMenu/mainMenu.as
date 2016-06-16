import flash.display.Bitmap;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.FlexEvent;

import spark.collections.Sort;
import spark.collections.SortField;

import serviceProxy.PlayersProxy;
import serviceProxy.ProxyManager;
import serviceProxy.events.ServiceFaultEvent;
import serviceProxy.events.ServiceResultEvent;

[Embed(source="/assets/images/mainmenu.png")]
private static const mainMenu:Class;

private static const MAIN_MENU:Bitmap = new mainMenu();

protected function startGame(event:MouseEvent):void
{
	parentApplication.setCurrentState("gameplay", false);
	
}

protected function bordercontainer1_showHandler(event:FlexEvent):void
{
	highScoresScreen.visible = highScoresScreen.includeInLayout = false;
}

protected function highscores_clickHandler(event:MouseEvent):void
{
	var proxy:PlayersProxy = ProxyManager.instance[PlayersProxy] as PlayersProxy;
	
	proxy.addEventListener(PlayersProxy.GET_ALL_PLAYERS_RESULT, onRestGetPlayersResult);
	proxy.addEventListener(PlayersProxy.GET_ALL_PLAYERS_FAULT, onPlayersFaultHandler);
	
	proxy.getAllPlayers();
}

protected function onRestGetPlayersResult(ev:ServiceResultEvent):void
{
	(ProxyManager.instance[PlayersProxy] as PlayersProxy).removeGetAllPlayersListeners();
	
	// display high scores in dataGrid
	highScoresScreen.visible = highScoresScreen.includeInLayout = true;
	
	// sort collection before setting it to the grid provider
	var playersDP:ArrayCollection = ev.result as ArrayCollection;
	
	var sort:Sort = new Sort();
	sort.fields = [new SortField("score", true)];
	playersDP.sort = sort;
	playersDP.refresh();
	
	for each (var pl:Object in playersDP)
	{
		// set player's ID for correct score position
		pl.id = playersDP.getItemIndex(pl) + 1;
	}
	
	// set grid data provider
	highScoresScreen.scoresGrid.dataProvider = playersDP;
	
	// set newly added item as selected in grid
	highScoresScreen.scoresGrid.setSelectedIndex(0);
	highScoresScreen.scoresGrid.ensureCellIsVisible(0);
}

protected function onPlayersFaultHandler(ev:ServiceFaultEvent):void
{
	Alert.show(ev.message);
	
	(ProxyManager.instance[PlayersProxy] as PlayersProxy).removeGetAllPlayersListeners();
}