package com.epg
{
    import com.tvie.utils.*;

    public class ChannelEPG extends Object
    {
        private var _channel:Channel;
        private var _length:Number;
        private var _totalEnd:Number;
        private var _realEPG:Boolean;
        private var _progArray:Object;
        private var _cursor:Number;
        private var _totalStart:Number;

        public function ChannelEPG(D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as:Channel, D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as:Array = null) : void
        {
            this.channel = D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as;
            this.progArray = D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as;
            return;
        }// end function

        public function setCursorByTime(com.epg:ChannelEPG/curProg/get:Number) : Boolean
        {
            var _loc_2:String = null;
            var _loc_3:Program = null;
            for (_loc_2 in _progArray)
            {
                
                _loc_3 = _progArray[_loc_2] as Program;
                if (com.epg:ChannelEPG/curProg/get >= _loc_3.startTime && com.epg:ChannelEPG/curProg/get < _loc_3.endTime)
                {
                    if (Number(_loc_2) == 70)
                    {
                    }
                    _cursor = Number(_loc_2);
                    return true;
                }
            }
            tvie_tracer("can not find program by time: " + com.epg:ChannelEPG/curProg/get + " setCursorByTime@ChannelEPG");
            return false;
        }// end function

        public function set channel(D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as:Channel) : void
        {
            _channel = D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as;
            return;
        }// end function

        public function set progArray(D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as:Object) : void
        {
            _progArray = null;
            _progArray = D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as;
            return;
        }// end function

        public function get channel() : Channel
        {
            return _channel;
        }// end function

        public function get cursor() : int
        {
            return _cursor;
        }// end function

        public function get realEPG() : Boolean
        {
            return _realEPG;
        }// end function

        public function get totalEndTime() : Number
        {
            if (_progArray != null)
            {
                return (_progArray[(length - 1)] as Program).endTime;
            }
            return 0;
        }// end function

        public function get length() : Number
        {
            var _loc_2:String = null;
            var _loc_1:Number = 0;
            if (_progArray != null)
            {
                for (_loc_2 in _progArray)
                {
                    
                    _loc_1 = _loc_1 + 1;
                }
                return _loc_1;
            }
            else
            {
                return 0;
            }
        }// end function

        public function get totalStartTime() : Number
        {
            if (_progArray != null)
            {
                return (_progArray[0] as Program).startTime;
            }
            return 0;
        }// end function

        public function get progArray() : Object
        {
            return _progArray;
        }// end function

        public function getProgByTime(com.epg:Number) : Program
        {
            var _loc_2:String = null;
            var _loc_3:Program = null;
            for (_loc_2 in _progArray)
            {
                
                _loc_3 = _progArray[_loc_2] as Program;
                if (com.epg > _loc_3.startTime && com.epg < _loc_3.endTime)
                {
                    return _loc_3;
                }
            }
            tvie_tracer("can not find demand program by time:" + com.epg + "getProgByTime@ChannelEPG");
            return null;
        }// end function

        public function get curProg() : Program
        {
            return _progArray[cursor] as Program;
        }// end function

        public function set cursor(D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as:int) : void
        {
            _cursor = D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as;
            if (_cursor < 0)
            {
            }
            else
            {
            }
            return;
        }// end function

        public function set realEPG(D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as:Boolean) : void
        {
            _realEPG = D:\ASS\uisdk_refactor1;com\epg;ChannelEPG.as;
            return;
        }// end function

    }
}
