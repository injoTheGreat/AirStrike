package serviceProxy.events
{
    import flash.events.Event;
    
    public class ServiceFaultEvent extends Event
    {
        private var _message:String;
        private var _origEvent:Event;
        
        public function ServiceFaultEvent(type:String, message:String, innerEvent:Event = null)
        {
            super(type);
            _message = message;
            _origEvent = innerEvent;
        }
        
        public function get message():String{
            return _message;
        }
        
        public function get originalEvent():Event{
            return _origEvent;
        }
        
        public override function clone():Event{
            return new ServiceFaultEvent(type, _message, _origEvent);
        }
    }
}