package com.tvie.model
{

    public class P2PModel extends Model
    {
        protected var _startplaytime:Number = 0;
        protected var _minDuration:Number = 60;
        protected var _duration_ratio:Number = 1.25;

        public function P2PModel(param1:Player, param2:Number = 512, param3:Number = 64)
        {
            _videodatarate = param2;
            _audiodatarate = param3;
            super(param1);
            return;
        }// end function

        override public function netStatusHandler(current:Object) : void
        {
            var _loc_2:Date = null;
            if (current.info.code == "NetStream.Buffer.Full")
            {
                if (_startplaytime == 0)
                {
                    _loc_2 = new Date();
                    _startplaytime = _loc_2.getTime();
                }
            }
            super.netStatusHandler(current);
            return;
        }// end function

        override public function get duration() : Number
        {
            var _loc_1:* = new Date();
            var _loc_2:* = (_loc_1.getTime() - _startplaytime * 1000) / 1000;
            if (_loc_2 < _minDuration)
            {
                _loc_2 = _minDuration;
            }
            return _loc_2 * _duration_ratio;
        }// end function

    }
}
