package serviceProxy.events
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    
    public class EventDispatcherBase extends EventDispatcher
    {
        private var _listeners:Dictionary = new Dictionary();
        
        public function EventDispatcherBase(target:IEventDispatcher=null)
        {
            super(target);
        }
        
        
        public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            if(!_listeners[type]){
                _listeners[type] = new  ArrayCollection();
            }
            
        	(_listeners[type] as ArrayCollection).addItem(listener);
        }
        
        public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
            super.addEventListener(type, listener, useCapture);
            if(_listeners[type]){
                var handlers:ArrayCollection = _listeners[type] as ArrayCollection;
                if(handlers.contains(listener)){
                    handlers.removeItemAt(handlers.getItemIndex(listener));
                }
            }
        }
        
        public function removeEventListeners(type:String):void{
            if(_listeners[type]){
                for each(var listener:Function in _listeners[type] as ArrayCollection){
                    this.removeEventListener(type, listener);
                }
            }
        }
        
        public function removeAllEventListeners():void{
            for (var type:String in _listeners){
                removeEventListeners(type);
            }
        }
    }
}