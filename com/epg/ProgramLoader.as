package com.epg
{
    import com.serialization.json.*;
    import com.tvie.uisdk.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.events.*;

    public class ProgramLoader extends Object
    {
        private var _pesudoInterval:Number = 3600;
        private var _epgSpan:Number = 15;
        private var _comm:Comm;
        private var _channelEPGPool:Object;
        private var _epgStr:String = "/api/getEPGByChannelTime/";
        private var _days:uint;
        private var _cid:int;

        public function ProgramLoader(onLoadFailedHandler:String, onLoadFailedHandler:int, onLoadFailedHandler:Object, onLoadFailedHandler:Number) : void
        {
            var _loc_5:String = null;
            _comm = new Comm();
            _cid = onLoadFailedHandler;
            _channelEPGPool = onLoadFailedHandler;
            _days = UISDK.config.Params["days"];
            UISDK.eDispather.addEventListener(UIEvent.UI_CANCEL_LOADING_EPG, onLoadFailedHandler);
            _loc_5 = onLoadFailedHandler + _epgStr + _cid + "/" + _days + "/" + tvie_dayEndTime(onLoadFailedHandler);
            _comm.sendreq(_loc_5, onCompleteHandler, onLoadFailedHandler);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_INFO, Lang.LOAD_EPG));
            return;
        }// end function

        private function checkProg(onLoadFailedHandler, onLoadFailedHandler:Number, onLoadFailedHandler:Array) : void
        {
            var _loc_4:Number = NaN;
            if (onLoadFailedHandler.startTime > onLoadFailedHandler.endTime)
            {
                _loc_4 = onLoadFailedHandler.startTime;
                onLoadFailedHandler.startTime = onLoadFailedHandler.endTime;
                onLoadFailedHandler.endTime = _loc_4;
            }
            return;
        }// end function

        private function reviseEPG(/:Object, /:Number, /:Number) : Object
        {
            var _loc_6:String = null;
            var _loc_7:Number = NaN;
            var _loc_9:Program = null;
            var _loc_10:Number = NaN;
            var _loc_4:* = new Object();
            var _loc_5:* = new Array();
            for (_loc_6 in /)
            {
                
                _loc_5.push(/[_loc_6]);
            }
            _loc_5.forEach(checkProg);
            _loc_5.sortOn("startTime", Array.NUMERIC);
            _loc_5.forEach(setIndex);
            _loc_7 = 0;
            if (_loc_5[0].startTime > /)
            {
                _loc_9 = Program.pseudoProg(/, _loc_5[0].startTime, _loc_5[0].cid, _loc_7);
                _loc_4[_loc_7] = _loc_9;
                _loc_7 = _loc_7 + 1;
            }
            var _loc_8:Number = 0;
            while (_loc_8 < _loc_5.length - 2)
            {
                
                if (_loc_5[_loc_8].endTime == _loc_5[(_loc_8 + 1)].startTime)
                {
                    _loc_5[_loc_8].index = _loc_7;
                    _loc_4[_loc_7] = _loc_5[_loc_8];
                    _loc_7 = _loc_7 + 1;
                }
                else if (_loc_5[_loc_8].endTime < _loc_5[(_loc_8 + 1)].startTime)
                {
                    _loc_10 = _loc_5[(_loc_8 + 1)].startTime - _loc_5[_loc_8].endTime;
                    if (_loc_10 <= _epgSpan)
                    {
                        _loc_5[_loc_8].endTime = _loc_5[(_loc_8 + 1)].startTime;
                        _loc_5[_loc_8].index = _loc_7;
                        _loc_4[_loc_7] = _loc_5[_loc_8];
                    }
                    else
                    {
                        _loc_4[_loc_7] = _loc_5[_loc_8];
                        _loc_7 = _loc_7 + 1;
                        _loc_9 = Program.pseudoProg(_loc_5[_loc_8].endTime, _loc_5[(_loc_8 + 1)].startTime, _loc_5[_loc_8].cid, _loc_7);
                        _loc_4[_loc_7] = _loc_9;
                    }
                    _loc_7 = _loc_7 + 1;
                }
                else if (_loc_5[_loc_8].endTime > _loc_5[(_loc_8 + 1)].startTime)
                {
                    if (_loc_5[_loc_8].endTime < _loc_5[(_loc_8 + 1)].endTime)
                    {
                        _loc_5[_loc_8].endTime = _loc_5[(_loc_8 + 1)].startTime;
                        _loc_5[_loc_8].index = _loc_7;
                        _loc_4[_loc_7] = _loc_5[_loc_8];
                        _loc_7 = _loc_7 + 1;
                    }
                    else if (_loc_5[_loc_8].endTime > _loc_5[_loc_8 + 2].startTime)
                    {
                        _loc_5[_loc_8].endTime = _loc_5[(_loc_8 + 1)].startTime;
                        _loc_5[_loc_8].index = _loc_7;
                        _loc_4[_loc_7] = _loc_5[_loc_8];
                        _loc_7 = _loc_7 + 1;
                    }
                    else
                    {
                        _loc_10 = _loc_5[_loc_8 + 2].startTime - _loc_5[_loc_8].endTime;
                        if (_loc_10 <= _epgSpan)
                        {
                            _loc_5[_loc_8].endTime = _loc_5[_loc_8 + 2].startTime;
                            _loc_5[_loc_8].index = _loc_7;
                            _loc_4[_loc_7] = _loc_5[_loc_8];
                        }
                        else
                        {
                            _loc_4[_loc_7] = _loc_5[_loc_8];
                            _loc_7 = _loc_7 + 1;
                            _loc_9 = Program.pseudoProg(_loc_5[_loc_8].endTime, _loc_5[_loc_8 + 2].startTime, _loc_5[_loc_8].cid, _loc_7);
                            _loc_4[_loc_7] = _loc_9;
                        }
                        _loc_7 = _loc_7 + 1;
                        _loc_8 = _loc_8 + 1;
                    }
                }
                _loc_8 = _loc_8 + 1;
            }
            _loc_5[_loc_5.length - 2].startTime = _loc_5[_loc_5.length - 3].endTime;
            _loc_5[_loc_5.length - 2].index = _loc_7;
            _loc_4[_loc_7] = _loc_5[_loc_5.length - 2];
            _loc_7 = _loc_7 + 1;
            _loc_5[(_loc_5.length - 1)].startTime = _loc_5[_loc_5.length - 2].endTime;
            _loc_5[(_loc_5.length - 1)].endTime = /;
            _loc_5[(_loc_5.length - 1)].index = _loc_7;
            _loc_4[_loc_7] = _loc_5[(_loc_5.length - 1)];
            return _loc_4;
        }// end function

        private function setIndex(onLoadFailedHandler, onLoadFailedHandler:Number, onLoadFailedHandler:Array) : void
        {
            onLoadFailedHandler.index = onLoadFailedHandler;
            return;
        }// end function

        private function onCompleteHandler(event:Event) : void
        {
            var totalST:Number;
            var totalET:Number;
            var channelProg:Object;
            var startTime:Number;
            var endTime:Number;
            var isNull:Boolean;
            var idx:String;
            var length:Number;
            var middle:int;
            var xx:int;
            var prog:Program;
            var t:Number;
            var pesedoPeog:Program;
            var event:* = event;
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_HIDE_NOTICE, null));
            try
            {
                channelProg = new Object();
                channelProg = JSON.deserialize(event.target.data).result;
            }
            catch (error:Error)
            {
                tvie_tracer("parse epg josn meeting an error, onCompleteHandler@ProgramLoader");
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.GET_EPG_ERROR));
                onLoadFailedHandler(null);
                return;
            }
            if (_days == 0)
            {
                totalST = tvie_dayStartTime(tvie_time());
            }
            else if (_days > 0)
            {
                totalST = tvie_dayEndTime(tvie_time()) + 24 * 60 * 60 - (_days + 1) * 24 * 60 * 60;
            }
            totalET = totalST + (_days + 1) * 24 * 60 * 60;
            var index:int;
            var progs:* = new Object();
            var day:uint;
            while (day <= _days)
            {
                
                startTime = totalST + day * 24 * 60 * 60;
                endTime = startTime + 24 * 60 * 60;
                isNull;
                var _loc_3:int = 0;
                var _loc_4:* = channelProg;
                while (_loc_4 in _loc_3)
                {
                    
                    idx = _loc_4[_loc_3];
                    length = channelProg[idx].length;
                    if (length == 0)
                    {
                        continue;
                    }
                    middle = Math.floor(length / 2);
                    if (channelProg[idx][middle].start_time >= startTime && channelProg[idx][middle].end_time <= endTime)
                    {
                        isNull;
                        xx;
                        while (xx < length)
                        {
                            
                            prog = Program.normalProg(channelProg[idx][xx].name, channelProg[idx][xx].start_time, channelProg[idx][xx].end_time, channelProg[idx][xx].encrypted_id, channelProg[idx][xx].channel_id, index);
                            progs[index] = prog;
                            index = (index + 1);
                            if (index == 55)
                            {
                            }
                            xx = (xx + 1);
                        }
                    }
                }
                if (isNull)
                {
                    t = startTime;
                    while (t < endTime)
                    {
                        
                        pesedoPeog = Program.pseudoProg(t, t + _pesudoInterval, _cid, index);
                        progs[index] = pesedoPeog;
                        index = (index + 1);
                        t = t + _pesudoInterval;
                    }
                }
                day = (day + 1);
            }
            tvie_traceObject(progs);
            var revisedEPG:* = reviseEPG(progs, totalST, totalET);
            _channelEPGPool[_cid].realEPG = true;
            _channelEPGPool[_cid].progArray = revisedEPG;
            tvie_tracer("get epg api succ, channel id:" + _cid);
            UISDK.eDispather.removeEventListener(UIEvent.UI_CANCEL_LOADING_EPG, onLoadFailedHandler);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_EPG_COMPLETE, null));
            return;
        }// end function

        private function onLoadFailedHandler(event:Event) : void
        {
            var _loc_2:Number = NaN;
            var _loc_6:Object = null;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Program = null;
            _comm.loader.close();
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_HIDE_NOTICE, null));
            if (_days == 0)
            {
                _loc_2 = tvie_dayStartTime(tvie_time());
            }
            else if (_days > 0)
            {
                _loc_2 = tvie_dayEndTime(tvie_time()) + 24 * 60 * 60 - (_days + 1) * 24 * 60 * 60;
            }
            var _loc_3:int = 0;
            var _loc_4:* = new Object();
            var _loc_5:int = 0;
            while (_loc_5 <= _days)
            {
                
                _loc_6 = new Object();
                _loc_7 = _loc_2 + _loc_5 * 24 * 60 * 60;
                _loc_8 = _loc_7 + 24 * 60 * 60;
                _loc_9 = _loc_7;
                while (_loc_9 < _loc_8)
                {
                    
                    _loc_10 = Program.pseudoProg(_loc_9, _loc_9 + _pesudoInterval, _cid, _loc_3);
                    _loc_4[_loc_3] = _loc_10;
                    _loc_3++;
                    _loc_9 = _loc_9 + _pesudoInterval;
                }
                _loc_5++;
            }
            _channelEPGPool[_cid].realEPG = false;
            _channelEPGPool[_cid].progArray = _loc_4;
            tvie_tracer("get pesudo epg succ, channel id:" + _cid);
            UISDK.eDispather.removeEventListener(UIEvent.UI_CANCEL_LOADING_EPG, onLoadFailedHandler);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_EPG_COMPLETE, null));
            return;
        }// end function

    }
}
