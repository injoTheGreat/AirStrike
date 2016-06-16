package serviceProxy
{
    
    import mx.collections.ArrayCollection;
    import mx.rpc.AsyncResponder;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import model.Player;
    
    import serviceProxy.events.ServiceFaultEvent;
    import serviceProxy.events.ServiceResultEvent;

    public class PlayersProxy extends ServiceProxyBase
    {
        private static const PLAYERS_CONTEXT:String = "players";
        private static const PLAYERS_COUNT_CONTEXT:String = "count";

        public static const GET_ALL_PLAYERS_RESULT:String = "GetAllPlayersResult";
        public static const GET_ALL_PLAYERS_FAULT:String = "GetAllPlayersFault";
        
        public static const ADD_PLAYER_RESULT:String = "AddPlayerResult";
        public static const ADD_PLAYER_FAULT:String = "AddPlayerFault";
        
        public static const GET_PLAYERS_COUNT_RESULT:String = "GetPlayersCountResult";
        public static const GET_PLAYERS_COUNT_FAULT:String = "GetPlayersCountFault";
        

        public function PlayersProxy()
        {
            this.rootContext = "http://localhost:8080/JerseyRestService/rest/players";
            this.service.showBusyCursor = true;
        }
        
        
        public function removeGetAllPlayersListeners():void{
            removeEventListeners(PlayersProxy.GET_ALL_PLAYERS_RESULT);
            removeEventListeners(PlayersProxy.GET_ALL_PLAYERS_FAULT);
        }

		public function removeGetPlayersCountListeners():void{
            removeEventListeners(PlayersProxy.GET_PLAYERS_COUNT_RESULT);
            removeEventListeners(PlayersProxy.GET_PLAYERS_COUNT_FAULT);
        }

		public function removeAddPlayerListeners():void{
            removeEventListeners(PlayersProxy.ADD_PLAYER_RESULT);
            removeEventListeners(PlayersProxy.ADD_PLAYER_FAULT);
        }

        public function getAllPlayers():void
        {
            var asyncToken:AsyncToken = sendGET("");
            asyncToken.addResponder(new AsyncResponder(getAllPlayersResult, getAllPlayersFault));
        }

        protected function getAllPlayersResult(event:ResultEvent, token:Object = null):void
        {
            var result:ArrayCollection = new ArrayCollection();
			var decodedArray:Object = JSON.parse(event.result.toString());
			
            for each (var pl:Object in decodedArray)
            {
                result.addItem(pl);
            }
            dispatchEvent(new ServiceResultEvent(GET_ALL_PLAYERS_RESULT, result, event));

        }

        protected function getAllPlayersFault(event:FaultEvent, token:Object = null):void
        {
            dispatchEvent(new ServiceFaultEvent(GET_ALL_PLAYERS_FAULT, event.fault.message, event));
        }
        
        public function addPlayer(player:Player):void
        {
            var jsonPlayer:String = JSON.stringify(player);
            var asyncToken:AsyncToken = sendPOST("", RESULT_FORMAT_TEXT, MEDIA_TYPE_APP_JSON, jsonPlayer);
            asyncToken.addResponder(new AsyncResponder(addPlayerResult, addPlayerFault));
        }
        
        protected function addPlayerResult(event:ResultEvent, token:Object = null):void
        {
            var res:Object = event.result;
            dispatchEvent(new ServiceResultEvent(ADD_PLAYER_RESULT, null, event));
        }
        
        protected function addPlayerFault(event:FaultEvent, token:Object = null):void
        {
            dispatchEvent(new ServiceFaultEvent(ADD_PLAYER_FAULT, event.fault.message, event));
        }
        
		public function getNumberOfPlayers():void
		{
			var asyncToken:AsyncToken = sendGET(PLAYERS_COUNT_CONTEXT, RESULT_FORMAT_TEXT, MEDIA_TYPE_TEXT_PLAIN, null, CONTENT_TYPE_JSON);
			asyncToken.addResponder(new AsyncResponder(getPlayersCountResult, getPlayersCountFault));
		}
		
		protected function getPlayersCountResult(event:ResultEvent, token:Object = null):void
		{
			var playersNo:int = int(event.result.toString());
			dispatchEvent(new ServiceResultEvent(GET_PLAYERS_COUNT_RESULT, playersNo, event));
		}

		protected function getPlayersCountFault(event:FaultEvent, token:Object = null):void
		{
			dispatchEvent(new ServiceFaultEvent(GET_PLAYERS_COUNT_FAULT, event.fault.message, event));
		}
    }
}
