package com.tvie.utils
{
    import flash.events.*;
    import flash.net.*;

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

        public function sendreq(load:String, load:Function, load:Function, load:String = "GET") : void
        {
            var _loc_5:* = new URLRequest(load);
            if (load == "POST")
            {
                _loc_5.method = URLRequestMethod.POST;
            }
            loader.load(_loc_5);
            loader.addEventListener(Event.COMPLETE, load);
            loader.addEventListener(IOErrorEvent.IO_ERROR, load);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, load);
            tvie_tracer("load request: " + load);
            return;
        }// end function

    }
}
