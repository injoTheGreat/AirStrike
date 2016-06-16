package serviceProxy
{    
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public dynamic final class ProxyManager
    {
        private static var _inst:ProxyManager = new ProxyManager();
        
        public function ProxyManager()
        {
        }
        
        public function registerServiceProxy(proxy:ServiceProxyBase):void{
             var proxyType:Class = Class(getDefinitionByName(getQualifiedClassName(proxy)));
             if(this[proxyType]){
                 throw new Error("Register proxy: Proxy already registered - " + getQualifiedClassName(proxy));
             }
            this[proxyType] = proxy;
        }
        
        public function unregisterServiceProxy(proxy:Class):void{
            if(!this[proxy]){
                throw new Error("Unregister proxy: Proxy never registered - " + proxy); 
            }
            
            this[proxy] = null;
        }
        
        public static function get instance():ProxyManager
        {
            return _inst;
        }
    }
}