package com.tvie.uisdk
{
    import com.anttikupila.revolt.*;
    import com.epg.*;
    import com.tvie.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.ui.*;
    import flash.utils.*;

    public class PlayerPanelEx extends Panel
    {
        protected var _cid:uint;
        protected var _hasCheckLink:Boolean = false;
        protected var _isTrueLink:Boolean = true;
        protected var _state:String;
        protected var _contextMenuDelegate:ContextMenuDelegate;
        protected var _requestObj:Object;
        protected var _mouseClickDeletegate:TVieClickDoubleWrapper;
        protected var _pausePending:Boolean = false;
        protected var _buffTimer:Timer;
        protected var _switchDRPending:Boolean = false;
        protected var _isSeekInBuffer:Boolean = false;
        protected var _mask:Sprite;
        protected var _timer:Timer;
        protected var _revolt:Revolt;
        protected var _linkPattern:Array;

        public function PlayerPanelEx(param1:Sprite = null)
        {
            _linkPattern = new Array();
            _timer = new Timer(100);
            _buffTimer = new Timer(100);
            _requestObj = new Object();
            super(param1);
            addListeners();
            initPlayer();
            initRevolt();
            initMask();
            _timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
            _buffTimer.addEventListener(TimerEvent.TIMER, onBuffTimerHandler);
            _contextMenuDelegate = new ContextMenuDelegate(_mask, onContextMenuSelectHandler);
            _mouseClickDeletegate = new TVieClickDoubleWrapper(_mask, onClickPlayerHandler, onDbClickPlayerHandler);
            addJSCallBack();
            return;
        }// end function

        protected function onSetVolumeHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Number(event.Info);
            _loc_2 = _loc_2 > 1 ? (1) : (_loc_2);
            _loc_2 = _loc_2 < 0 ? (0) : (_loc_2);
            player.sendPlayerCommand(PlayerCommands.COMMAND_VOLUME, _loc_2);
            return;
        }// end function

        protected function onPlayHandler(event:TVieEvent) : void
        {
            if (_state == PlayerStates.MODEL_STATE_PAUSED)
            {
                player.sendPlayerCommand(PlayerCommands.COMMAND_RESUME);
            }
            return;
        }// end function

        private function initMask() : void
        {
            _mask = new Sprite();
            _mask.buttonMode = true;
            _mask.graphics.beginFill(0, 0);
            _mask.graphics.drawRect(0, 0, player.width, player.height);
            _mask.graphics.endFill();
            player.addChild(_mask);
            return;
        }// end function

        private function addListeners() : void
        {
            HideShowDelegate.getInstance().unSubscribe(player);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAY, onPlayHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_PAUSE, onPauseHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_REMOTE_PLAY, onRemotePlayHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SEEK, onSeekHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SEEKPLAY, onSeekPlayHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_FULLSCREEN, onFullScreenHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SWITCH_DR, onSwitchDatarateHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SWITCH_RATIO, onSwitchRatioHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SOUND_ON, onSetSoundOnHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SOUND_OFF, onSetSoundOffHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_SET_VOLUME, onSetVolumeHandler);
            return;
        }// end function

        protected function onContextMenuSelectHandler(event:ContextMenuEvent) : void
        {
            var _loc_4:RegExp = null;
            var _loc_2:* = player.getPlayerProperty(PlayerProperties.DATARATEPOOL);
            var _loc_3:* = _loc_2[_cid];
            if (_loc_3 != Object(undefined) && _loc_3 != null && _isTrueLink)
            {
                _loc_4 = /kbps""kbps/;
                _contextMenuDelegate.removeMenuItem(_loc_4, onChangeDatarateHandler);
                _contextMenuDelegate.addDataRateList(_loc_3, onChangeDatarateHandler);
            }
            return;
        }// end function

        protected function onSetSoundOnHandler(event:TVieEvent) : void
        {
            player.sendPlayerCommand(PlayerCommands.COMMAND_SOUND_ON);
            return;
        }// end function

        protected function onMetaDataHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Number(player.getPlayerProperty(PlayerProperties.PROGSTART));
            _timer.start();
            if (_loc_2 > UISDK.config.Params["endtime"])
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.STREAM_ERROR));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_BACK2LIVE, null));
            }
            else
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_TUNE_IN, _loc_2));
            }
            if (_pausePending)
            {
                player.sendPlayerCommand(PlayerCommands.COMMAND_PAUSE, null);
            }
            return;
        }// end function

        protected function onDbClickPlayerHandler() : void
        {
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_FULLSCREEN, null));
            return;
        }// end function

        protected function getServerTime() : Number
        {
            var _loc_1:* = Number(player.getPlayerProperty(PlayerProperties.TIMEOFFSET));
            var _loc_2:* = tvie_time() + _loc_1;
            _loc_2 = Math.round(_loc_2);
            return _loc_2;
        }// end function

        private function initPlayer() : void
        {
            player.addPlayerEventListener(PlayerEvents.RECV_METADATA, onMetaDataHandler);
            player.addPlayerEventListener(PlayerEvents.RECV_CDN_INFO, onCDNReadyHandler);
            player.addPlayerEventListener(PlayerEvents.STATE_CHANGE, onPlayerStateChangeHandler);
            player.addPlayerEventListener(PlayerEvents.TVIE_ERROR, onPlayerErrorHandler);
            return;
        }// end function

        override protected function onMouseRollOut(event:MouseEvent) : void
        {
            isMouseOn = false;
            return;
        }// end function

        protected function addJSCallBack() : void
        {
            UISDK.JsMgr.addCallBack(JSInterface.timeStampPlay, timeStampPlay);
            return;
        }// end function

        protected function onRemotePlayHandler(event:TVieEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:* = event.Info;
            var _loc_4:* = _loc_3["type"];
            if (!_hasCheckLink)
            {
                _isTrueLink = checkLinkGhoul();
                _hasCheckLink = true;
                if (!_isTrueLink)
                {
                    _loc_3["datarate"] = 1;
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.LINK_GHOUL));
                }
            }
            else if (!_isTrueLink)
            {
                _loc_3["datarate"] = 1;
            }
            if (_loc_4 == RequestType.TYPE_LIVE || !tvie_equalObj(_loc_3, _requestObj) || !tvie_equalObj(_requestObj, _loc_3))
            {
                _requestObj = _loc_3;
                _timer.reset();
                UISDK.config.Params["starttime"] = _loc_3["starttime"];
                UISDK.config.Params["endtime"] = _loc_3["endtime"];
                UISDK.config.Params["id"] = _loc_3["cid"];
                if (_loc_3["datarate"] != undefined)
                {
                    UISDK.config.Params["datarate"] = _loc_3["datarate"];
                }
                _cid = Number(_loc_3["cid"]);
                EPGDataCenter.getInstance().cid = _cid;
                player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, false);
                _loc_2 = UISDK.config.cloneObject(UISDK.config.Params);
                if (_loc_4 == RequestType.TYPE_LIVE)
                {
                    _loc_2 = UISDK.config.cloneObject(UISDK.config.Params);
                    _loc_2["starttime"] = 0;
                    player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, _loc_2);
                }
                else if (_loc_4 == RequestType.TYPE_NOTLIVE)
                {
                    _loc_2 = UISDK.config.cloneObject(UISDK.config.Params);
                    _loc_2["endtime"] = 0;
                    player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, _loc_2);
                }
                else if (_loc_4 == RequestType.TYPE_VOD)
                {
                    player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, UISDK.config.Params);
                }
            }
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            var _loc_2:Boolean = false;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            if (event.Info == null)
            {
                _loc_5 = player.width / player.height;
                _loc_6 = Math.abs(_loc_5 - 4 / 3);
                _loc_7 = Math.abs(_loc_5 - 16 / 9);
                if (_loc_7 > _loc_6)
                {
                    _loc_2 = true;
                }
                else
                {
                    _loc_2 = false;
                }
            }
            else
            {
                _loc_2 = Boolean(event.Info);
            }
            var _loc_3:* = UISDK.config.Rect;
            if (_loc_2)
            {
                _loc_8 = _loc_3.height * 4 / 3;
                if (_loc_8 < _loc_3.width)
                {
                    player.height = _loc_3.height;
                    player.width = player.height * 4 / 3;
                }
                else
                {
                    player.width = _loc_3.width;
                    player.height = _loc_3.width * 3 / 4;
                }
            }
            else
            {
                _loc_8 = _loc_3.height * 16 / 9;
                if (_loc_8 < _loc_3.width)
                {
                    player.height = _loc_3.height;
                    player.width = player.height * 16 / 9;
                }
                else
                {
                    player.width = _loc_3.width;
                    player.height = _loc_3.width * 9 / 16;
                }
            }
            player.x = (_loc_3.width - player.width) / 2;
            player.y = (_loc_3.height - player.height) / 2;
            var _loc_4:* = new Rectangle(player.x, player.y, player.width, player.height);
            HideShowDelegate.getInstance().setRectangle(_loc_4);
            UISDK.config.Rect.playerX = player.x;
            UISDK.config.Rect.playerY = player.y;
            UISDK.config.Rect.playerWidth = player.width;
            UISDK.config.Rect.playerHeight = player.height;
            return;
        }// end function

        protected function onBuffTimerHandler(event:TimerEvent) : void
        {
            var _loc_2:* = Number(player.getPlayerProperty(PlayerProperties.BUFFERTIME));
            var _loc_3:* = Number(player.getPlayerProperty(PlayerProperties.BUFFERLENGTH));
            var _loc_4:* = Math.round(_loc_3 / _loc_2 * 100);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_BUFFER_PERCENT, _loc_4));
            return;
        }// end function

        protected function onPlayerStateChangeHandler(event:TVieEvent) : void
        {
            _state = String(event.Info);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PLAYER_STATE, _state));
            if (_state == PlayerStates.MODEL_STATE_BUFFERING || _state == PlayerStates.MODEL_STATE_WAIT_STREAM)
            {
                _buffTimer.start();
            }
            else if (_state == PlayerStates.MODEL_STATE_PLAYING)
            {
                _timer.start();
                _buffTimer.reset();
            }
            if (_state == PlayerStates.MODEL_STATE_PAUSED)
            {
                _pausePending = true;
            }
            else if (_state != PlayerStates.MODEL_STATE_BUFFERING && _state != PlayerStates.MODEL_STATE_WAIT_STREAM)
            {
                _pausePending = false;
            }
            return;
        }// end function

        override protected function onMouseRollOver(event:MouseEvent) : void
        {
            isMouseOn = false;
            return;
        }// end function

        protected function getLoadedLength() : Number
        {
            var _loc_1:* = Number(player.getPlayerProperty(PlayerProperties.LOADEDLENGTH));
            var _loc_2:* = getServerTime();
            var _loc_3:* = Number(player.getPlayerProperty(PlayerProperties.PROGSTART));
            var _loc_4:* = Number(player.getPlayerProperty(PlayerProperties.PLAYPOSTIME));
            _loc_1 = _loc_1 > _loc_2 - _loc_3 ? (_loc_2 - _loc_3) : (_loc_1);
            _loc_1 = _loc_1 < _loc_4 - _loc_3 ? (_loc_4 - _loc_3) : (_loc_1);
            return _loc_1;
        }// end function

        protected function onCDNReadyHandler(event:TVieEvent) : void
        {
            var _loc_3:Number = NaN;
            var _loc_2:* = int(event.Info);
            if (_loc_2 == _cid)
            {
                _loc_3 = Number(player.getPlayerProperty(PlayerProperties.TIMEOFFSET));
                UISDK.config.Params["timeOffset"] = _loc_3;
                if (_switchDRPending)
                {
                    _switchDRPending = false;
                    onSwitchDatarateHandler(null);
                }
            }
            return;
        }// end function

        protected function checkLinkGhoul() : Boolean
        {
            var result:Object;
            var htmlpath:String;
            var isLink:Boolean;
            var idx:Number;
            var pattern:RegExp;
            var re:* = /^(http\:\/\/[\w\.\-\d]+)\/?.*""^(http\:\/\/[\w\.\-\d]+)\/?.*/;
            var reg_field_site:int;
            if (Capabilities.playerType != "StandAlone")
            {
                try
                {
                    if (ExternalInterface.available)
                    {
                        htmlpath = ExternalInterface.call("window.location.href.toString");
                        tvie_tracer("HTML Site is " + htmlpath);
                        result = re.exec(htmlpath);
                        if (result == null)
                        {
                            return false;
                        }
                        else
                        {
                            htmlpath = result[reg_field_site];
                            htmlpath = htmlpath.slice(0, htmlpath.length);
                        }
                    }
                }
                catch (e:Error)
                {
                    tvie_tracer("Get HTML Site Error" + e.toString());
                    return false;
                }
                isLink;
                idx;
                while (idx < _linkPattern.length)
                {
                    
                    pattern = new RegExp(_linkPattern[idx], "i");
                    if (htmlpath.search(pattern) == -1)
                    {
                        isLink;
                    }
                    else
                    {
                        isLink;
                        break;
                    }
                    idx = (idx + 1);
                }
                return isLink;
            }
            else
            {
                tvie_tracer("Capabilities.playerType is: StandAlone");
                return true;
            }
        }// end function

        protected function onTimerHandler(event:TimerEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            if (_state == PlayerStates.MODEL_STATE_PLAYING || _state == PlayerStates.MODEL_STATE_PAUSED || _state == PlayerStates.MODEL_STATE_BUFFERING)
            {
                _loc_2 = new Object();
                _loc_3 = Number(player.getPlayerProperty(PlayerProperties.PROGSTART));
                _loc_4 = Number(player.getPlayerProperty(PlayerProperties.PLAYPOSTIME));
                if (_state == PlayerStates.MODEL_STATE_PLAYING && _loc_4 > UISDK.config.Params["endtime"])
                {
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SWITCH2NEXT_PROG, null));
                    return;
                }
                _loc_2["streamStart"] = _loc_3;
                _loc_2["buffLength"] = getLoadedLength();
                _loc_2["playTime"] = _loc_4;
                _loc_5 = getServerTime();
                if (_loc_5 < _loc_4)
                {
                    _loc_2["liveTime"] = _loc_2["playTime"];
                }
                else
                {
                    _loc_2["liveTime"] = _loc_5;
                }
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_UPDATE_TIMEBAR, _loc_2));
            }
            if (_state == PlayerStates.MODEL_STATE_COMPLETED)
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SWITCH2NEXT_PROG, null));
            }
            return;
        }// end function

        protected function onClickPlayerHandler() : void
        {
            if (_state == PlayerStates.MODEL_STATE_PAUSED)
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PLAY, null));
            }
            else
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PAUSE, null));
            }
            return;
        }// end function

        override protected function hide(event:TVieEvent) : void
        {
            return;
        }// end function

        final public function timeStampPlay(UI_SWITCH_DR:Number, UI_SWITCH_DR:Number, UI_SWITCH_DR:Number = 0) : void
        {
            var _loc_4:* = new Object();
            UISDK.config.Params["datarate"] = UI_SWITCH_DR;
            _loc_4.cid = UI_SWITCH_DR;
            _loc_4.timestamp = UI_SWITCH_DR;
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_TIMESTAMP_PLAY, _loc_4));
            return;
        }// end function

        protected function onSetSoundOffHandler(event:TVieEvent) : void
        {
            player.sendPlayerCommand(PlayerCommands.COMMAND_SOUND_OFF);
            return;
        }// end function

        protected function onFullScreenHandler(event:TVieEvent) : void
        {
            if (stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                stage.displayState = StageDisplayState.NORMAL;
            }
            else
            {
                stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            return;
        }// end function

        protected function onSwitchRatioHandler(event:TVieEvent) : void
        {
            var _loc_2:* = player.width / player.height;
            var _loc_3:* = Math.abs(_loc_2 - 4 / 3);
            var _loc_4:* = Math.abs(_loc_2 - 16 / 9);
            if (_loc_4 < _loc_3)
            {
                resize(new TVieEvent(UIEvent.UI_RESIZE, true));
            }
            else
            {
                resize(new TVieEvent(UIEvent.UI_RESIZE, false));
            }
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
            return;
        }// end function

        protected function onSeekHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Number(event.Info);
            var _loc_3:* = Number(player.getPlayerProperty(PlayerProperties.PROGSTART));
            var _loc_4:* = getLoadedLength();
            var _loc_5:* = UISDK.config.Params["starttime"] + (UISDK.config.Params["endtime"] - UISDK.config.Params["starttime"]) * _loc_2;
            if (_state == PlayerStates.MODEL_STATE_BUFFERING || _state == PlayerStates.MODEL_STATE_PAUSED || _state == PlayerStates.MODEL_STATE_PLAYING)
            {
                player.removePlayerEventListener(PlayerEvents.STATE_CHANGE, onPlayerStateChangeHandler);
                player.sendPlayerCommand(PlayerCommands.COMMAND_PAUSE);
                _timer.reset();
                if (_loc_5 > _loc_3 && _loc_5 < _loc_3 + _loc_4)
                {
                    _isSeekInBuffer = true;
                    player.sendPlayerCommand(PlayerCommands.COMMAND_SEEK, _loc_5);
                }
                else
                {
                    _isSeekInBuffer = false;
                }
            }
            return;
        }// end function

        public function get player() : Player
        {
            return component as Player;
        }// end function

        protected function onPlayerErrorHandler(event:TVieEvent) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = String(event.Info);
            if (_loc_2 == PlayerErrors.CDN_UNAVAILABLE)
            {
                _loc_3 = Lang.CDN_UNAVAILABLE;
            }
            else if (_loc_2 == PlayerErrors.GET_OTP_FAIL)
            {
                _loc_3 = Lang.GET_OTP_FAIL;
            }
            else if (_loc_2 == PlayerErrors.OUT_OF_REGION)
            {
                _loc_3 = Lang.OUT_OF_REGION;
            }
            else if (_loc_2 == PlayerErrors.SRC_IS_VOID)
            {
                _loc_3 = Lang.SRC_IS_VOID;
            }
            else if (_loc_2 == PlayerErrors.STREAM_NOT_FOUND)
            {
                _loc_3 = Lang.STREAM_NOT_FOUND;
            }
            else
            {
                _loc_3 = Lang.UNKONW_ERROR;
            }
            tvie_tracer("core error happened: " + _loc_2 + " onPlayerErrorHandler@PlayerPanelEx");
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, _loc_3));
            return;
        }// end function

        private function initRevolt() : void
        {
            _revolt = new Revolt(player);
            player.addChild(_revolt);
            return;
        }// end function

        protected function onSwitchDatarateHandler(event:TVieEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            if (_state == PlayerStates.MODEL_STATE_PLAYING || _state == PlayerStates.MODEL_STATE_PAUSED || _state == PlayerStates.MODEL_STATE_BUFFERING)
            {
                if (_isTrueLink)
                {
                    _loc_2 = player.getPlayerProperty(PlayerProperties.DATARATEPOOL);
                    _loc_3 = _loc_2[_cid];
                    if (_loc_3 != Object(undefined) && _loc_3 != null)
                    {
                        _loc_4 = Number(player.getPlayerProperty(PlayerProperties.VIDEODATARATE));
                        if (_loc_3.length == 1)
                        {
                            tvie_tracer("only one daterate for this channel, onSwitchDatarateHandler@PlayerPanelEx");
                            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.DATARATE_INFO));
                            return;
                        }
                        _loc_5 = 0;
                        while (_loc_5 < _loc_3.length)
                        {
                            
                            if (_loc_3[_loc_5] == _loc_4)
                            {
                                break;
                            }
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_5 = ++_loc_5 % _loc_3.length;
						_loc_5++;
                        if (_pausePending)
                        {
                            player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, true);
                        }
                        else
                        {
                            player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, false);
                        }
                        UISDK.config.Params["datarate"] = _loc_3[++_loc_5];
                        player.sendPlayerCommand(PlayerCommands.COMMAND_DATARATE, _loc_3[_loc_5]);
                    }
                    else
                    {
                        _switchDRPending = true;
                        player.sendPlayerCommand(PlayerCommands.COMMAND_GETCDNINFO, _cid);
                    }
                }
                else
                {
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.DATARATE_GHOUL));
                }
            }
            return;
        }// end function

        protected function onChangeDatarateHandler(event:ContextMenuEvent) : void
        {
            var _loc_2:* = event.currentTarget as ContextMenuItem;
            var _loc_3:* = _loc_2.caption;
            var _loc_4:* = Number(_loc_3.substr(0, _loc_3.length - 4));
            if (_state == PlayerStates.MODEL_STATE_PLAYING || _state == PlayerStates.MODEL_STATE_PAUSED || _state == PlayerStates.MODEL_STATE_BUFFERING)
            {
                if (_pausePending)
                {
                    player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, true);
                }
                else
                {
                    player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, false);
                }
                UISDK.config.Params["datarate"] = _loc_4;
                player.sendPlayerCommand(PlayerCommands.COMMAND_DATARATE, _loc_4);
            }
            return;
        }// end function

        protected function onPauseHandler(event:TVieEvent) : void
        {
            if (_state == PlayerStates.MODEL_STATE_PLAYING || _state == PlayerStates.MODEL_STATE_BUFFERING)
            {
                player.sendPlayerCommand(PlayerCommands.COMMAND_PAUSE);
            }
            return;
        }// end function

        override protected function show(event:TVieEvent) : void
        {
            return;
        }// end function

        protected function onSeekPlayHandler(event:TVieEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Object = null;
            player.addPlayerEventListener(PlayerEvents.STATE_CHANGE, onPlayerStateChangeHandler);
            if (!_isSeekInBuffer)
            {
                _loc_2 = Number(event.Info);
                _loc_3 = getLoadedLength();
                _loc_4 = UISDK.config.Params["starttime"] + (UISDK.config.Params["endtime"] - UISDK.config.Params["starttime"]) * _loc_2;
                _loc_5 = getServerTime();
                _loc_4 = _loc_4 > _loc_5 ? (_loc_5) : (_loc_4);
                _loc_4 = _loc_4 < UISDK.config.Params["starttime"] ? (UISDK.config.Params["starttime"]) : (_loc_4);
                _loc_4 = _loc_4 >= UISDK.config.Params["endtime"] - 10 ? (UISDK.config.Params["endtime"] - 10) : (_loc_4);
                _loc_6 = UISDK.config.cloneObject(UISDK.config.Params);
                _loc_6["starttime"] = _loc_4;
                player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, _loc_6);
            }
            else if (_pausePending)
            {
                player.sendPlayerCommand(PlayerCommands.COMMAND_PAUSE);
            }
            else
            {
                player.sendPlayerCommand(PlayerCommands.COMMAND_RESUME);
            }
            return;
        }// end function

    }
}
