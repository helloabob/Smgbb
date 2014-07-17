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

        override protected function play(com.tvie.model:VODModel/loadedLength/get:Object) : void
        {
            if (com.tvie.model:VODModel/loadedLength/get["id"] != undefined)
            {
                _id = int(com.tvie.model:VODModel/loadedLength/get["id"]);
                if (com.tvie.model:VODModel/loadedLength/get["starttime"] != undefined)
                {
                    _starttime = Math.round(Number(com.tvie.model:VODModel/loadedLength/get["starttime"]));
                }
                if (com.tvie.model:VODModel/loadedLength/get["datarate"] != undefined)
                {
                    _nominalDataRate = Math.round(Number(com.tvie.model:VODModel/loadedLength/get["datarate"]));
                }
                CDNProbe();
            }
            return;
        }// end function

    }
}
