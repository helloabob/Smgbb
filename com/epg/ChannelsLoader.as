package com.epg
{
    import com.serialization.json.*;
    import com.tvie.uisdk.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.events.*;
    import flash.utils.*;

    public class ChannelsLoader extends Object
    {
        private var _waitTime:Number = 5000;
        private var _interval:Number = 100;
        private var _timer:Timer;
        private var _comm:Comm;
        private var _channelEPGPool:Object;
        private var _apiStr:String = "/api/getChannels";
        private var _allChannelEPG:Object;

        public function ChannelsLoader(UISDK:String, UISDK:Object) : void
        {
            _comm = new Comm();
            _timer = new Timer(_interval);
            _channelEPGPool = UISDK;
            var _loc_3:* = UISDK + _apiStr;
            _timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
            _comm.sendreq(_loc_3, channelsComplete, channelsFailed);
            _timer.start();
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_INFO, Lang.LOAD_CHANELS));
            return;
        }// end function

        private function channelsComplete(event:Event) : void
        {
            var channelsObj:Object;
            var channel:Channel;
            var event:* = event;
            _timer.reset();
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_HIDE_NOTICE, null));
            try
            {
                channelsObj = new Object();
                channelsObj = JSON.deserialize(event.target.data).result;
            }
            catch (event:Error)
            {
                tvie_tracer("parse channel json meeting an error, channelsComplete@ChannelsLoader");
                channelsFailed(null);
                return;
            }
            var idx:uint;
            while (idx < channelsObj.length)
            {
                
                if (channelsObj[idx].id == null || channelsObj[idx].id == undefined || channelsObj[idx].name == null && channelsObj[idx].name == undefined)
                {
                    channelsFailed(null);
                    return;
                }
                channel = new Channel(channelsObj[idx].id, channelsObj[idx].name);
                _channelEPGPool[channel.cid] = new ChannelEPG(channel, null);
                idx = (idx + 1);
            }
            tvie_tracer("get channels api succ.channelsComplete@ChannelsLoader");
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_COMPLETE, null));
            return;
        }// end function

        private function channelsFailed(event:Event) : void
        {
            tvie_tracer("get channels api failed, channelsFailed@ChannelsLoader");
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.GET_CHANEL_ERROR));
            return;
        }// end function

        private function onTimerHandler(event:TimerEvent) : void
        {
            if (_timer.currentCount > _waitTime / _interval)
            {
                _comm.loader.close();
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.GET_CHANEL_ERROR));
                _timer.reset();
            }
            return;
        }// end function

    }
}
