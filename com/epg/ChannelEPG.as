package com.epg
{
	import com.epg.Channel;
	import com.tvie.utils.Comm;
    

    public class ChannelEPG extends Object
    {
        private var _channel:Channel;
        private var _length:Number;
        private var _totalEnd:Number;
        private var _realEPG:Boolean;
        private var _progArray:Object;
        private var _cursor:Number;
        private var _totalStart:Number;

        public function ChannelEPG(param1:Channel, param2:Array) : void
        {
            this.channel = param1;
            this.progArray = param2;
            return;
        }// end function

        public function setCursorByTime(param:Number) : Boolean
        {
            var _loc_2:String = null;
            var _loc_3:Program = null;
            for (_loc_2 in _progArray)
            {
                
                _loc_3 = _progArray[_loc_2] as Program;
                if (param >= _loc_3.startTime && param < _loc_3.endTime)
                {
                    if (Number(_loc_2) == 70)
                    {
                    }
                    _cursor = Number(_loc_2);
                    return true;
                }
            }
            com.tvie.utils.Comm.tvie_tracer("can not find program by time: " + param + " setCursorByTime@ChannelEPG");
            return false;
        }


// end function

        public function set channel(param:Channel) : void
        {
            _channel = param;
            return;
        }// end function

        public function set progArray(param:Object) : void
        {
            _progArray = null;
            _progArray = param;
            return;
        }// end function

        public function get channel():Channel
        {
            return _channel;
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

        public function getProgByTime(param:Number) : Program
        {
            var _loc_2:String = null;
            var _loc_3:Program = null;
            for (_loc_2 in _progArray)
            {
                
                _loc_3 = _progArray[_loc_2] as Program;
                if (_cursor > _loc_3.startTime && _cursor < _loc_3.endTime)
                {
                    return _loc_3;
                }
            }
            com.tvie.utils.Comm.tvie_tracer("can not find demand program by time:" + _cursor + "getProgByTime@ChannelEPG");
            return null;
        }// end function

        public function get curProg() : Program
        {
            return _progArray[cursor] as Program;
        }// end function

		public function get cursor():Number
		{
			return _cursor;
		}
		
        public function set cursor(param:Number) : void
        {
            _cursor = param;
            if (_cursor < 0)
            {
            }
            else
            {
            }
            return;
        }// end function

        public function set realEPG(param:Boolean) : void
        {
            _realEPG = param;
            return;
        }// end function

    }
}
