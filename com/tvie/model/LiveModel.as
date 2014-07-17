package com.tvie.model
{
    import com.tvie.*;
    import com.tvie.utilities.*;

    public class LiveModel extends CDNModel
    {
        protected var _is_live:Boolean = true;
        protected var _is_time_traveler:Boolean = true;
        protected var _program_start_base:Number = 0;
        protected var _endtime:Number = 0;
        protected var _program_start:Number = 0;
        protected var _live_head_time:Number = 0;

        public function LiveModel(param1:Player)
        {
            _cdnformat = "/api/getCDNByChannelId/";
            super(param1);
            return;
        }// end function

        override public function get playPos() : Number
        {
            return _ns.time + _program_start_base / 1000;
        }// end function

        override protected function formatURL(com.tvie.model:LiveModel/LiveModel:CDNInfo) : String
        {
            var _loc_2:String = null;
            var _loc_3:Date = null;
            var _loc_4:Number = NaN;
            if (com.tvie.model:LiveModel/LiveModel != null)
            {
                _loc_2 = "http://" + com.tvie.model:LiveModel/LiveModel.CDNSite + "/channels/" + _id.toString() + "/" + com.tvie.model:LiveModel/LiveModel.dataRate.toString() + ".flv/";
                if (_starttime != 0)
                {
                    if (_endtime != 0)
                    {
                        _loc_2 = _loc_2 + (_starttime * 1000).toString() + "," + (_endtime * 1000).toString();
                    }
                    else
                    {
                        _loc_2 = _loc_2 + (_starttime * 1000).toString();
                    }
                }
                else
                {
                    _loc_3 = new Date();
                    _loc_4 = Math.round(_loc_3.getTime() + _server_client_time_offset * 1000);
                    _loc_2 = _loc_2 + "live?" + _loc_4.toString();
                }
                return _loc_2;
            }
            return null;
        }// end function

        override protected function seek(com.tvie.model:LiveModel/programStart/get:Object) : void
        {
            var _loc_2:* = Number(com.tvie.model:LiveModel/programStart/get) - _program_start_base / 1000;
            super.seek(_loc_2);
            return;
        }// end function

        override public function getProperty(D:\ASS\TViePlayerV2-Core\src;com\tvie\model;LiveModel.as:String) : Object
        {
            var _loc_2:Object = null;
            switch(D:\ASS\TViePlayerV2-Core\src;com\tvie\model;LiveModel.as)
            {
                case PlayerProperties.PROGSTART:
                {
                    _loc_2 = programStart;
                    break;
                }
                default:
                {
                    _loc_2 = super.getProperty(D:\ASS\TViePlayerV2-Core\src;com\tvie\model;LiveModel.as);
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

        override public function onMetaData(com.tvie.model:LiveModel/programStart/get:Object) : void
        {
            var _loc_2:Number = NaN;
            if (com.tvie.model:LiveModel/programStart/get.program_start != undefined)
            {
                _loc_2 = Number(com.tvie.model:LiveModel/programStart/get.program_start);
                _program_start = _loc_2 % 2147483648;
                _program_start_base = _loc_2 - _program_start;
            }
            if (com.tvie.model:LiveModel/programStart/get.live_head_time != undefined)
            {
                _live_head_time = Number(com.tvie.model:LiveModel/programStart/get.live_head_time);
            }
            if (com.tvie.model:LiveModel/programStart/get.is_live != undefined)
            {
                _is_live = Boolean(com.tvie.model:LiveModel/programStart/get.is_live);
            }
            if (com.tvie.model:LiveModel/programStart/get.is_time_traveler != undefined)
            {
                _is_time_traveler = Boolean(com.tvie.model:LiveModel/programStart/get.is_time_traveler);
            }
            super.onMetaData(com.tvie.model:LiveModel/programStart/get);
            return;
        }// end function

        override public function get duration() : Number
        {
            if (_endtime != 0)
            {
                return _endtime - programStart;
            }
            return 2147483647 / (dataRate / 8192);
        }// end function

        override public function get loadedLength() : Number
        {
            return _ns.bytesLoaded / (super.dataRate * 1000 / 8);
        }// end function

        override protected function play(com.tvie.model:LiveModel/programStart/get:Object) : void
        {
            if (com.tvie.model:LiveModel/programStart/get["id"] != undefined)
            {
                _id = int(com.tvie.model:LiveModel/programStart/get["id"]);
                if (com.tvie.model:LiveModel/programStart/get["starttime"] != undefined)
                {
                    _starttime = Math.round(Number(com.tvie.model:LiveModel/programStart/get["starttime"]));
                }
                else
                {
                    _starttime = 0;
                }
                if (com.tvie.model:LiveModel/programStart/get["endtime"] != undefined)
                {
                    _endtime = Math.round(Number(com.tvie.model:LiveModel/programStart/get["endtime"]));
                }
                else
                {
                    _endtime = 0;
                }
                if (com.tvie.model:LiveModel/programStart/get["datarate"] != undefined)
                {
                    _nominalDataRate = Math.round(Number(com.tvie.model:LiveModel/programStart/get["datarate"]));
                }
                CDNProbe();
            }
            return;
        }// end function

        public function get programStart() : Number
        {
            return (_program_start_base + _program_start) / 1000;
        }// end function

    }
}
