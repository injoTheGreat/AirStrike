package serviceProxy.events
{
    import flash.events.Event;

    public class ServiceResultEvent extends Event
    {
        private var _result:Object;
        private var _origEvent:Event;

        public function ServiceResultEvent(type:String, result:Object, innerEvent:Event = null)
        {
            super(type);
            _result = result;
            _origEvent = innerEvent;
        }
        
        public function get result():Object{
            return _result;
        }
        
        public function get originalEvent():Event{
            return _origEvent;
        }
        
        public override function clone():Event{
            return new ServiceResultEvent(type, _result, _origEvent);
        }
    }
}
