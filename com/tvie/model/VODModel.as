package com.tvie.model
{
    import com.tvie.utilities.*;

    public class VODModel extends CDNModel
    {

        public function VODModel(param1:Player)
        {
            _cdnformat = "/api/getCDNByVodId/";
            super(param1);
            return;
        }// end function

        override protected function formatURL(Object:CDNInfo) : String
        {
            var _loc_2:String = null;
            if (Object != null)
            {
                _loc_2 = "http://" + Object.CDNSite + "/vod/" + _id.toString() + "/" + Object.dataRate.toString() + ".flv";
                if (_starttime != 0)
                {
                    _loc_2 = _loc_2 + "/" + (_starttime * 1000).toString();
                }
                return _loc_2;
            }
            return null;
        }// end function

        override public function get loadedLength() : Number
        {
            return _ns.bytesLoaded / (super.dataRate * 1000 / 8);
        }// end function

        override public function get duration() : Number
        {
            return _duration / 1000;
        }// end function

        override protected function play(param:Object) : void
        {
            if (param["id"] != undefined)
            {
                _id = int(param["id"]);
                if (param["starttime"] != undefined)
                {
                    _starttime = Math.round(Number(param["starttime"]));
                }
                if (param["datarate"] != undefined)
                {
                    _nominalDataRate = Math.round(Number(param["datarate"]));
                }
                CDNProbe();
            }
            return;
        }// end function

    }
}
