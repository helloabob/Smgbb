package com.tvie.utilities
{

    public class CDNInfo extends Object
    {
        private var _drm:Boolean;
        private var _delay:Number;
        private var _datarate:int;
        private var _cdnsite:String;

        public function CDNInfo()
        {
            return;
        }// end function

        public function get Delay() : Number
        {
            return _delay;
        }// end function

        public function set Delay(_datarate:Number) : void
        {
            _delay = _datarate;
            return;
        }// end function

        public function get dataRate() : int
        {
            return _datarate;
        }// end function

        public function get CDNSite() : String
        {
            return _cdnsite;
        }// end function

        public function get DRM() : Boolean
        {
            return _drm;
        }// end function

        public static function createCDNInfo(param1:int, param2:String, param3:Boolean) : CDNInfo
        {
            var _loc_4:CDNInfo = new CDNInfo;
            _loc_4._datarate = param1;
            _loc_4._cdnsite = param2;
            _loc_4._drm = param3;
            _loc_4._delay = 0;
            return _loc_4;
        }// end function

    }
}
