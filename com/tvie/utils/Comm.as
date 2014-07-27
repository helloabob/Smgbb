package com.tvie.utils
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.external.ExternalInterface;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;

    public class Comm extends Object
    {
        private var _loader:URLLoader;

        public function Comm()
        {
            _loader = new URLLoader();
            return;
        }// end function

        public function get loader() : URLLoader
        {
            return _loader;
        }// end function

		public static function tvie_tracer(param:String):void{
			trace(param);
			flash.external.ExternalInterface.call("console.log",param);
		}
		
		public static function tvie_equalObj(param1:Object, param2:Object):Boolean{
			if(param1==param2)return true;
			return false;
		}
		
		public static function tvie_time():Number{
			return Number(new Date());
		}
		
        public function sendreq(param1:String, param2:Function, param3:Function, param4:String = "GET") : void
        {
            var _loc_5:* = new URLRequest(param1);
            if (param4 == "POST")
            {
                _loc_5.method = URLRequestMethod.POST;
            }
            loader.load(_loc_5);
            loader.addEventListener(Event.COMPLETE, param2);
            loader.addEventListener(IOErrorEvent.IO_ERROR, param3);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, param3);
            tvie_tracer("load request: " + param1);
            return;
        }// end function

    }
}
