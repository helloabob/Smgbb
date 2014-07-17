package com.tvie.utilities
{
    import flash.events.*;
    import flash.net.*;

    public class Comm extends Object
    {

        public function Comm()
        {
            return;
        }// end function

        public static function sendreq(com.tvie.utilities:String, com.tvie.utilities:Function, com.tvie.utilities:Function, com.tvie.utilities:String = "GET", com.tvie.utilities:URLVariables = null) : void
        {
            var _loc_6:* = new URLRequest(com.tvie.utilities);
            if (com.tvie.utilities == "POST")
            {
                if (com.tvie.utilities != null)
                {
                    _loc_6.method = URLRequestMethod.POST;
                    _loc_6.data = com.tvie.utilities;
                }
                else
                {
                    Logger.print("No Variables, so the POST request will be a GET request");
                }
            }
            var _loc_7:* = new URLLoader();
            _loc_7.load(_loc_6);
            _loc_7.addEventListener(Event.COMPLETE, com.tvie.utilities);
            _loc_7.addEventListener(IOErrorEvent.IO_ERROR, com.tvie.utilities);
            _loc_7.addEventListener(SecurityErrorEvent.SECURITY_ERROR, com.tvie.utilities);
            Logger.print("Send Request To " + com.tvie.utilities);
            return;
        }// end function

    }
}
