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

        public static function sendreq(param1:String, func1:Function, func2:Function, param2:String = "GET", param3:URLVariables = null) : void
        {
            var _loc_6:* = new URLRequest(param1);
            if (param2 == "POST")
            {
                if (param3 != null)
                {
                    _loc_6.method = URLRequestMethod.POST;
                    _loc_6.data = param2;
                }
                else
                {
                    Logger.print("No Variables, so the POST request will be a GET request");
                }
            }
            var _loc_7:* = new URLLoader();
            _loc_7.load(_loc_6);
            _loc_7.addEventListener(Event.COMPLETE, func1);
            _loc_7.addEventListener(IOErrorEvent.IO_ERROR, func2);
            _loc_7.addEventListener(SecurityErrorEvent.SECURITY_ERROR, param2);
            Logger.print("Send Request To " + param1);
            return;
        }// end function

    }
}
