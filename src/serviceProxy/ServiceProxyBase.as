package serviceProxy
{
    import mx.rpc.AsyncToken;
    import mx.rpc.http.HTTPService;

    import serviceProxy.events.EventDispatcherBase;

    public class ServiceProxyBase extends EventDispatcherBase
    {
        public static const MEDIA_TYPE_APP_XML:String = "application/xml";
        public static const MEDIA_TYPE_APP_JSON:String = "application/json";
        public static const MEDIA_TYPE_OCTET:String = "application/octet-stream";
        public static const MEDIA_TYPE_TEXT_PLAIN:String = "text/plain";
        public static const MEDIA_TYPE_TEXT_XML:String = "text/xml";

        public static const CONTENT_TYPE_URL_ENCODED:String = "application/x-www-form-urlencoded";
        public static const CONTENT_TYPE_XML:String = "application/xml";
        public static const CONTENT_TYPE_JSON:String = "application/json";

        public static const RESULT_FORMAT_ARRAY:String = "array";
        public static const RESULT_FORMAT_E4X:String = "e4x";
        public static const RESULT_FORMAT_FLASH_VARS:String = "flashvars";
        public static const RESULT_FORMAT_OBJECT:String = "object";
        public static const RESULT_FORMAT_TEXT:String = "text";
        public static const RESULT_FORMAT_XML:String = "xml";

        public static const METHOD_GET:String = "GET";
        public static const METHOD_PUT:String = "PUT";
        public static const METHOD_POST:String = "POST";
        public static const METHOD_DELETE:String = "DELETE";


        private var _rootContext:String;

        protected var service:HTTPService = new HTTPService();


        protected function set rootContext(url:String):void
        {
            this._rootContext = url;
        }

        protected function get rootContext():String
        {
            return _rootContext;
        }

        protected function sendRequest(partialURL:String, method:String = METHOD_GET, resultFormat:String = RESULT_FORMAT_TEXT, mediaType:String = MEDIA_TYPE_APP_JSON, requestData:Object = null, contentType:String = CONTENT_TYPE_JSON):AsyncToken
        {
            if (partialURL.charAt(0) == "/")
            {
                partialURL = partialURL.slice(1);
            }

            this.service.url = _rootContext + "/" + partialURL;
            this.service.method = method;
            this.service.resultFormat = resultFormat;
            this.service.headers = {Accept: mediaType};
            this.service.contentType = contentType;

            if (requestData != null)
            {
                this.service.request = requestData;
            }

            return this.service.send(requestData ? requestData : null);
        }
        
        protected function sendGET(partialURL:String, resultFormat:String = RESULT_FORMAT_TEXT, mediaType:String = MEDIA_TYPE_APP_JSON, requestData:Object = null, contentType:String = CONTENT_TYPE_JSON):AsyncToken
        {
            return sendRequest(partialURL, METHOD_GET, resultFormat, mediaType, requestData, contentType);
        }
        
        
        protected function sendPUT(partialURL:String, resultFormat:String = RESULT_FORMAT_TEXT, mediaType:String = MEDIA_TYPE_APP_JSON, requestData:Object = null, contentType:String = CONTENT_TYPE_JSON):AsyncToken
        {
            return sendRequest(partialURL, METHOD_PUT, resultFormat, mediaType, requestData, contentType);
        }
        
        protected function sendPOST(partialURL:String, resultFormat:String = RESULT_FORMAT_TEXT, mediaType:String = MEDIA_TYPE_APP_JSON, requestData:Object = null, contentType:String = CONTENT_TYPE_JSON):AsyncToken
        {
            return sendRequest(partialURL, METHOD_POST, resultFormat, mediaType, requestData, contentType);
        }
        
        protected function sendDELETE(partialURL:String, resultFormat:String = RESULT_FORMAT_TEXT, mediaType:String = MEDIA_TYPE_APP_JSON, requestData:Object = null, contentType:String = CONTENT_TYPE_JSON):AsyncToken
        {
            return sendRequest(partialURL, METHOD_DELETE, resultFormat, mediaType, requestData, contentType);
        }
    }
}
