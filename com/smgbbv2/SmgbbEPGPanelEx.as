package com.smgbbv2
{
    import com.epg.*;
    import com.tvie.uisdk.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;

    public class SmgbbEPGPanelEx extends EPGPanelEx
    {
        private var _laodEPGReqPending:Boolean = false;
        private var _timeStampReqPending:Boolean = false;
        private var _timeStamp:Number;

        public function SmgbbEPGPanelEx(param1:Sprite = null)
        {
            super(param1);
            _autoStart = false;
            sole.visible = false;
            return;
        }// end function

        override protected function onBuildChannelEPGHandler(event:TVieEvent) : void
        {
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG;
            if (_timeStampReqPending)
            {
                _timeStampReqPending = false;
                if (_timeStamp == 0)
                {
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_BACK2LIVE, null));
                }
                else
                {
                    if (!_loc_2.setCursorByTime(_timeStamp))
                    {
                        tvie_tracer("can not find program by specified time:" + _timeStamp + " play first program");
                        _loc_2.cursor = 0;
                        _timeStamp = _loc_2.curProg.startTime;
                    }
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SELECT_PLAY, null));
                }
            }
            return;
        }// end function

        override protected function onLoadChannelEPGHandler(event:TVieEvent) : void
        {
            var _loc_2:ChannelEPG = null;
            var _loc_3:Number = NaN;
            if (EPGDataCenter.getInstance().curChannelEPG == null)
            {
                new ChannelsLoader(_api, EPGDataCenter.getInstance().channelEPGPool);
            }
            else
            {
                _loc_2 = EPGDataCenter.getInstance().curChannelEPG;
                if (_timeStamp == 0)
                {
                    _loc_3 = tvie_time() + UISDK.config.Params["timeOffset"];
                }
                else
                {
                    _loc_3 = _timeStamp;
                }
                if (_loc_2.progArray != Object(undefined) && _loc_3 >= _loc_2.totalStartTime && _loc_3 <= _loc_2.totalEndTime)
                {
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_EPG_COMPLETE, null));
                }
                else
                {
                    new ProgramLoader(_api, EPGDataCenter.getInstance().cid, EPGDataCenter.getInstance().channelEPGPool, _loc_3);
                }
            }
            return;
        }// end function

        override protected function initLoadChannel() : void
        {
            return;
        }// end function

        override protected function initListeners() : void
        {
            super.initListeners();
            UISDK.eDispather.addEventListener(UIEvent.UI_TIMESTAMP_PLAY, onTimeStampPlayHandler);
            return;
        }// end function

        override protected function initializeButtons() : void
        {
            return;
        }// end function

        override protected function get sole() : Object
        {
            return component as EPGPanel;
        }// end function

        override protected function onSelectPlayHandler(event:TVieEvent) : void
        {
            var _loc_5:String = null;
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG.curProg;
            var _loc_3:* = tvie_time() + UISDK.config.Params["timeOffset"];
            var _loc_4:* = new Object();
            if (canPlayerAcceptReq())
            {
                _loc_4["type"] = RequestType.TYPE_VOD;
                _loc_4["starttime"] = _loc_2.startTime;
                _loc_4["endtime"] = _loc_2.endTime;
                _loc_4["cid"] = EPGDataCenter.getInstance().cid;
                _loc_5 = Lang.LOAD_PROGRAM + ": " + _loc_2.name;
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_INFO, _loc_5));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_REMOTE_PLAY, _loc_4));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_UPDATE_PROG, _loc_2));
            }
            return;
        }// end function

        override protected function onBuilderChannelsHandler(event:TVieEvent) : void
        {
            var _loc_2:* = new Object();
            _loc_2.cid = EPGDataCenter.getInstance().cid;
            _loc_2.time = _timeStamp;
            onLoadChannelEPGHandler(new TVieEvent(UIEvent.UI_CHANNEL_CHANGE, _loc_2));
            return;
        }// end function

        private function onTimeStampPlayHandler(event:TVieEvent) : void
        {
            _timeStampReqPending = true;
            _timeStamp = Number(event.Info.timestamp);
            EPGDataCenter.getInstance().cid = Number(event.Info.cid);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_CHANGE, event.Info));
            return;
        }// end function

    }
}
