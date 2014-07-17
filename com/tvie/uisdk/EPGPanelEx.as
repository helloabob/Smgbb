package com.tvie.uisdk
{
    import com.epg.*;
    import com.tvie.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;

    public class EPGPanelEx extends Panel
    {
        protected var _reloadEPG:MovieClip;
        protected var _presReqPending:Boolean = false;
        protected var _nextReqPending:Boolean = false;
        protected var _programLayer:ProgramBuilder;
        protected var _state:String = "MODEL_STATE_IDLE";
        protected var _api:String;
        protected var _closeEPG:SimpleButton;
        protected var _channelLayer:ChannelsBuilder;
        protected var _epgPanelHeight:Number;
        protected var _autoStart:Boolean = true;
        protected var _loading:MovieClip;
        protected var _back2LivePending:Boolean = false;

        public function EPGPanelEx(param1:Sprite = null)
        {
            _api = UISDK.config.Params["site"];
            super(param1);
            initializeButtons();
            initListeners();
            initLoadChannel();
            return;
        }// end function

        override protected function hide(event:TVieEvent) : void
        {
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            var _loc_2:* = UISDK.config.Rect;
            sole.width = _loc_2.playerWidth / 1.4;
            sole.scaleY = sole.scaleX;
            sole.x = _loc_2.playerX + (_loc_2.playerWidth - sole.width) / 2;
            sole.y = _loc_2.playerY + _loc_2.playerHeight / 2;
            return;
        }// end function

        protected function onBuilderChannelsHandler(event:TVieEvent) : void
        {
            var _loc_2:* = new Object();
            _channelLayer.buildChannels(EPGDataCenter.getInstance().channelEPGPool);
            _loc_2.cid = EPGDataCenter.getInstance().cid;
            _loc_2.time = tvie_time();
            onLoadChannelEPGHandler(new TVieEvent(UIEvent.UI_CHANNEL_CHANGE, _loc_2));
            return;
        }// end function

        protected function onCloseEPGPanelHandler(event:MouseEvent) : void
        {
            onShowEPGHandler(null);
            return;
        }// end function

        protected function initLoadChannel() : void
        {
            new ChannelsLoader(_api, EPGDataCenter.getInstance().channelEPGPool);
            return;
        }// end function

        protected function onChangePayerStateHandler(event:TVieEvent) : void
        {
            _state = String(event.Info);
            return;
        }// end function

        protected function initializeButtons() : void
        {
            _closeEPG = sole.closeBtn;
            _closeEPG.addEventListener(MouseEvent.CLICK, onCloseEPGPanelHandler);
            _loading = sole.loading;
            _loading.closeLoading.addEventListener(MouseEvent.CLICK, onCloseLoadingHandler);
            _reloadEPG = sole.reloadEPG;
            _reloadEPG.reload.addEventListener(MouseEvent.CLICK, onReloadEPGHandler);
            _reloadEPG.cancel.addEventListener(MouseEvent.CLICK, onReloadEPGHandler);
            _reloadEPG.visible = false;
            _programLayer = new ProgramBuilder(sole.programPanel);
            _channelLayer = new ChannelsBuilder(sole.channelPanel);
            _epgPanelHeight = sole.height;
            return;
        }// end function

        protected function onLoadChannelEPGHandler(event:TVieEvent) : void
        {
            var _loc_4:Number = NaN;
            EPGDataCenter.getInstance().cid = Number(event.Info.cid);
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG;
            var _loc_3:* = tvie_time();
            if (_loc_2.progArray != Object(undefined) && _loc_3 >= _loc_2.totalStartTime && _loc_3 <= _loc_2.totalEndTime)
            {
                if (_loc_2.realEPG)
                {
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_EPG_COMPLETE, null));
                }
                else
                {
                    _loading.visible = true;
                    _loading.cycle2_stage.visible = false;
                    _loading.closeLoading.visible = false;
                    _reloadEPG.visible = true;
                }
            }
            else
            {
                _loc_4 = Number(event.Info.time);
                _loading.visible = true;
                new ProgramLoader(_api, EPGDataCenter.getInstance().cid, EPGDataCenter.getInstance().channelEPGPool, _loc_4);
            }
            return;
        }// end function

        protected function onReloadEPGHandler(event:MouseEvent) : void
        {
            var _loc_2:ChannelEPG = null;
            var _loc_3:Number = NaN;
            _reloadEPG.visible = false;
            if (event.target.name == "reload")
            {
                _loc_2 = EPGDataCenter.getInstance().curChannelEPG as ChannelEPG;
                _loc_3 = _loc_2.totalEndTime - 24 * 60 * 60;
                new ProgramLoader(_api, EPGDataCenter.getInstance().cid, EPGDataCenter.getInstance().channelEPGPool, _loc_3);
                _loading.cycle2_stage.visible = true;
                _loading.closeLoading.visible = true;
            }
            else
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_EPG_COMPLETE, null));
            }
            return;
        }// end function

        protected function onBack2LiveHandler(event:TVieEvent) : void
        {
            var _loc_5:Program = null;
            var _loc_6:Object = null;
            var _loc_7:String = null;
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG;
            var _loc_3:* = tvie_time() + UISDK.config.Params["timeOffset"];
            var _loc_4:* = new Object();
            if (canPlayerAcceptReq())
            {
                if (_loc_3 > _loc_2.totalStartTime && _loc_3 < _loc_2.totalEndTime)
                {
                    _loc_2.setCursorByTime(_loc_3);
                    _loc_5 = _loc_2.curProg;
                    _loc_6 = new Object();
                    _loc_6["type"] = RequestType.TYPE_LIVE;
                    _loc_6["starttime"] = _loc_5.startTime;
                    _loc_6["endtime"] = _loc_5.endTime;
                    _loc_6["cid"] = EPGDataCenter.getInstance().cid;
                    _loc_7 = Lang.LOAD_PROGRAM + ": " + _loc_5.name;
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_INFO, _loc_7));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_REMOTE_PLAY, _loc_6));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_UPDATE_PROG, _loc_5));
                }
                else
                {
                    _loc_4.time = tvie_time();
                    _loc_4.cid = EPGDataCenter.getInstance().cid;
                    onLoadChannelEPGHandler(new TVieEvent(UIEvent.UI_CHANNEL_CHANGE, _loc_4));
                    _back2LivePending = true;
                }
            }
            return;
        }// end function

        protected function initListeners() : void
        {
            UISDK.eDispather.addEventListener(UIEvent.UI_CHANNEL_COMPLETE, onBuilderChannelsHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_CHANNEL_EPG_COMPLETE, onBuildChannelEPGHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_CHANNEL_CHANGE, onLoadChannelEPGHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SHOW_EPG, onShowEPGHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SELECT_PLAY, onSelectPlayHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SWITCH2NEXT_PROG, onSwitch2NextProgHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SWITCH2PRES_PROG, onSwitch2PresProgHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_BACK2LIVE, onBack2LiveHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, onChangePayerStateHandler);
            return;
        }// end function

        override protected function show(event:TVieEvent) : void
        {
            return;
        }// end function

        protected function onSwitch2NextProgHandler(event:TVieEvent) : void
        {
            var _loc_6:Number = NaN;
            var _loc_7:Program = null;
            var _loc_8:Object = null;
            var _loc_9:String = null;
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG;
            var _loc_3:* = tvie_time() + UISDK.config.Params["timeOffset"];
            var _loc_4:* = _loc_2.getProgByTime(_loc_3);
            var _loc_5:* = new Object();
            if (canPlayerAcceptReq())
            {
                if (_loc_2.cursor == _loc_2.length)
                {
                    _loc_6 = _loc_2.totalEndTime + 10;
                    _loc_5.time = _loc_6;
                    _loc_5.cid = EPGDataCenter.getInstance().cid;
                    onLoadChannelEPGHandler(new TVieEvent(UIEvent.UI_CHANNEL_CHANGE, _loc_5));
                    _nextReqPending = true;
                }
                else
                {
                    (_loc_2.cursor + 1);
                    if (_loc_2.cursor > _loc_4.index)
                    {
                        tvie_tracer("bound back to live play, onSwitch2NextProgHandler@EPGPanelEx");
                        _loc_2.cursor = _loc_4.index;
                    }
                    _loc_7 = _loc_2.curProg;
                    _loc_8 = new Object();
                    _loc_8["type"] = RequestType.TYPE_VOD;
                    _loc_8["starttime"] = _loc_7.startTime;
                    _loc_8["endtime"] = _loc_7.endTime;
                    _loc_8["cid"] = EPGDataCenter.getInstance().cid;
                    _loc_9 = Lang.LOAD_PROGRAM + ": " + _loc_7.name;
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_INFO, _loc_9));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_REMOTE_PLAY, _loc_8));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_UPDATE_PROG, _loc_7));
                }
            }
            return;
        }// end function

        protected function onSwitch2PresProgHandler(event:TVieEvent) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Program = null;
            var _loc_6:Object = null;
            var _loc_7:String = null;
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG;
            var _loc_3:* = new Object();
            if (canPlayerAcceptReq())
            {
                if (_loc_2.cursor == 0)
                {
                    _loc_4 = _loc_2.totalStartTime - 10;
                    _loc_3.time = _loc_4;
                    _loc_3.cid = EPGDataCenter.getInstance().cid;
                    onLoadChannelEPGHandler(new TVieEvent(UIEvent.UI_CHANNEL_CHANGE, _loc_3));
                    _presReqPending = true;
                }
                else
                {
                    (_loc_2.cursor - 1);
                    _loc_5 = _loc_2.curProg;
                    _loc_6 = new Object();
                    _loc_6["type"] = RequestType.TYPE_VOD;
                    _loc_6["starttime"] = _loc_5.startTime;
                    _loc_6["endtime"] = _loc_5.endTime;
                    _loc_6["cid"] = EPGDataCenter.getInstance().cid;
                    _loc_7 = Lang.LOAD_PROGRAM + ": " + _loc_5.name;
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_INFO, _loc_7));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_REMOTE_PLAY, _loc_6));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_UPDATE_PROG, _loc_5));
                }
            }
            return;
        }// end function

        protected function onBuildChannelEPGHandler(event:TVieEvent) : void
        {
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG as ChannelEPG;
            _loading.visible = false;
            _programLayer.buildProgram(_loc_2);
            if (_autoStart)
            {
                _autoStart = false;
                if (!_loc_2.setCursorByTime(tvie_time() + UISDK.config.Params["timeOffset"]))
                {
                    _loc_2.cursor = 0;
                }
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SELECT_PLAY, null));
            }
            else if (_presReqPending)
            {
                _presReqPending = false;
                _loc_2.cursor = _loc_2.length - 1;
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SELECT_PLAY, null));
            }
            else if (_nextReqPending)
            {
                _nextReqPending = false;
                _loc_2.cursor = 0;
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SELECT_PLAY, null));
            }
            return;
        }// end function

        protected function canPlayerAcceptReq() : Boolean
        {
            return _state == PlayerStates.MODEL_STATE_PLAYING || _state == PlayerStates.MODEL_STATE_PAUSED || _state == PlayerStates.MODEL_STATE_WAIT_STREAM || _state == PlayerStates.MODEL_STATE_COMPLETED || _state == PlayerStates.MODEL_STATE_BUFFERING || _state == PlayerStates.MODEL_STATE_IDLE;
        }// end function

        protected function onCloseLoadingHandler(event:MouseEvent) : void
        {
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CANCEL_LOADING_EPG, null));
            return;
        }// end function

        protected function onShowEPGHandler(event:TVieEvent) : void
        {
            if (canPlayerAcceptReq())
            {
                if (sole.visible)
                {
                    TweenLite.to(sole, 0.5, {alpha:0, visible:false});
                }
                else
                {
                    _programLayer.buildProgram(EPGDataCenter.getInstance().curChannelEPG);
                    TweenLite.to(sole, 0.5, {alpha:1, visible:true});
                }
            }
            return;
        }// end function

        protected function get sole() : Object
        {
            return component as EPGPanel;
        }// end function

        protected function onSelectPlayHandler(event:TVieEvent) : void
        {
            var _loc_5:String = null;
            var _loc_2:* = EPGDataCenter.getInstance().curChannelEPG.curProg;
            var _loc_3:* = tvie_time() + UISDK.config.Params["timeOffset"];
            var _loc_4:* = new Object();
            if (canPlayerAcceptReq())
            {
                if (_loc_3 > _loc_2.startTime && _loc_3 < _loc_2.endTime)
                {
                    _loc_4["type"] = RequestType.TYPE_LIVE;
                }
                else
                {
                    _loc_4["type"] = RequestType.TYPE_VOD;
                }
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

    }
}
