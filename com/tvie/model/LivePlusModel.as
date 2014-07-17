package com.tvie.model
{
    import com.tvie.*;
    import com.tvie.utilities.*;

    public class LivePlusModel extends LiveModel
    {
        protected var _cliplength:Number;
        protected var _realendtime:Number;

        public function LivePlusModel(param1:Player)
        {
            _cliplength = 120;
            _realendtime = 0;
            param1.addPlayerEventListener(PlayerEvents.CORE_BEAT, onCoreBeat);
            super(param1);
            return;
        }// end function

        override public function netStatusHandler(para:Object) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Object = null;
            if (para.info.code == "NetStream.Play.Stop")
            {
                _loc_2 = Math.round(playPos);
                if (_loc_2 < _realendtime)
                {
                    release();
                    _loc_3 = new Object();
                    _loc_3["id"] = _id;
                    _loc_3["starttime"] = _loc_2;
                    _loc_3["endtime"] = _realendtime;
                    play(_loc_3);
                }
            }
            super.netStatusHandler(para);
            return;
        }// end function

        override protected function play(para:Object) : void
        {
            var _loc_2:Number = NaN;
            if (para["starttime"] != undefined)
            {
                _loc_2 = Math.round(Number(para["starttime"]));
                if (_loc_2 != 0)
                {
                    if (para["endtime"] != undefined)
                    {
                        _realendtime = Math.round(Number(para["endtime"]));
                        if (_realendtime > _loc_2 + _cliplength)
                        {
                            para["endtime"] = _loc_2 + _cliplength;
                        }
                    }
                    else
                    {
                        _realendtime = 0;
                        para["endtime"] = _loc_2 + _cliplength;
                    }
                }
            }
            super.play(para);
            return;
        }// end function

        private function replaceNetStream() : void
        {
            return;
        }// end function

        private function onCoreBeat(event:TVieEvent) : void
        {
            return;
        }// end function

    }
}
