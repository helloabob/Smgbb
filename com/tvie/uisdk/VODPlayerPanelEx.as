package com.tvie.uisdk
{
    import com.tvie.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class VODPlayerPanelEx extends PlayerPanelEx
    {
        private var _vodStreamStart:Number;

        public function VODPlayerPanelEx(param1:Sprite = null)
        {
            super(param1);
            return;
        }// end function

        override protected function onRemotePlayHandler(event:TVieEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:* = event.Info;
            if (!tvie_equalObj(_loc_3, _requestObj) || !tvie_equalObj(_requestObj, _loc_3))
            {
                _requestObj = _loc_3;
            }
            else
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.SAME_REQUEST));
                return;
            }
            _timer.reset();
            UISDK.config.Params["starttime"] = 0;
            if (_loc_3["datarate"] != undefined)
            {
                UISDK.config.Params["datarate"] = _loc_3["datarate"];
            }
            UISDK.config.Params["id"] = _loc_3["vid"];
            _cid = Number(_loc_3["vid"]);
            _vodStreamStart = 0;
            player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, false);
            _loc_2 = UISDK.config.cloneObject(UISDK.config.Params);
            _loc_2["starttime"] = _vodStreamStart;
            player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, _loc_2);
            return;
        }// end function

        final public function externalVODPlay(UISDK:uint, UISDK:Number = 0) : void
        {
            var _loc_3:Object = null;
            if (player != null)
            {
                _loc_3 = new Object();
                _loc_3["datarate"] = UISDK;
                _loc_3["vid"] = UISDK;
                _isTrueLink = checkLinkGhoul();
                if (!_isTrueLink)
                {
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                    UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.LINK_GHOUL));
                    _loc_3["datarate"] = 1;
                }
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_REMOTE_PLAY, _loc_3));
            }
            else
            {
                tvie_tracer("player core is not initalized, initalize it first. externalPlay@VODPlayerPanelEx");
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.PLAYER_NOT_INIT));
            }
            return;
        }// end function

        override protected function getLoadedLength() : Number
        {
            var _loc_1:* = Number(player.getPlayerProperty(PlayerProperties.LOADEDLENGTH));
            var _loc_2:* = getServerTime();
            var _loc_3:* = Number(player.getPlayerProperty(PlayerProperties.PLAYPOSTIME));
            _loc_1 = _loc_1 > _loc_2 - _vodStreamStart ? (_loc_2 - _vodStreamStart) : (_loc_1);
            _loc_1 = _loc_1 < _loc_3 - _vodStreamStart ? (_loc_3 - _vodStreamStart) : (_loc_1);
            return _loc_1;
        }// end function

        override protected function onPlayerStateChangeHandler(event:TVieEvent) : void
        {
            super.onPlayerStateChangeHandler(event);
            if (_state == PlayerStates.MODEL_STATE_COMPLETED)
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SHOW_NOTICE, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.PLAY_COMPLETED));
                _buffTimer.reset();
                _timer.reset();
            }
            return;
        }// end function

        override protected function onSeekHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Number(event.Info);
            var _loc_3:* = getLoadedLength();
            var _loc_4:* = UISDK.config.Params["starttime"] + (UISDK.config.Params["endtime"] - UISDK.config.Params["starttime"]) * _loc_2;
            player.removePlayerEventListener(PlayerEvents.STATE_CHANGE, onPlayerStateChangeHandler);
            player.sendPlayerCommand(PlayerCommands.COMMAND_PAUSE);
            _timer.reset();
            if (_loc_4 > _vodStreamStart && _loc_4 < _vodStreamStart + _loc_3)
            {
                _isSeekInBuffer = true;
                player.sendPlayerCommand(PlayerCommands.COMMAND_SEEK, _loc_4);
            }
            else
            {
                _isSeekInBuffer = false;
            }
            return;
        }// end function

        override protected function onMetaDataHandler(event:TVieEvent) : void
        {
            _timer.start();
            var _loc_2:* = Number(player.getPlayerProperty(PlayerProperties.DURATION));
            UISDK.config.Params["endtime"] = _loc_2;
            return;
        }// end function

        override protected function onTimerHandler(event:TimerEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Number = NaN;
            if (_state == PlayerStates.MODEL_STATE_PLAYING || _state == PlayerStates.MODEL_STATE_PAUSED || _state == PlayerStates.MODEL_STATE_BUFFERING)
            {
                _loc_2 = new Object();
                _loc_3 = Number(player.getPlayerProperty(PlayerProperties.PLAYPOSTIME));
                _loc_2["streamStart"] = _vodStreamStart;
                _loc_2["buffLength"] = getLoadedLength();
                _loc_2["playTime"] = _loc_3;
                _loc_2["liveTime"] = getServerTime();
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_UPDATE_TIMEBAR, _loc_2));
            }
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PLAYER_STATE, _state));
            return;
        }// end function

        override protected function onSeekPlayHandler(event:TVieEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Object = null;
            player.addPlayerEventListener(PlayerEvents.STATE_CHANGE, onPlayerStateChangeHandler);
            if (!_isSeekInBuffer)
            {
                _loc_2 = Number(event.Info);
                _loc_3 = UISDK.config.Params["starttime"] + (UISDK.config.Params["endtime"] - UISDK.config.Params["starttime"]) * _loc_2;
                _loc_4 = getServerTime();
                _loc_3 = _loc_3 < 0 ? (0) : (_loc_3);
                _loc_3 = _loc_3 >= UISDK.config.Params["endtime"] - 10 ? (UISDK.config.Params["endtime"] - 10) : (_loc_3);
                _vodStreamStart = _loc_3;
                _loc_5 = UISDK.config.cloneObject(UISDK.config.Params);
                _loc_5["starttime"] = _loc_3;
                if (_pausePending)
                {
                    player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, true);
                }
                else
                {
                    player.sendPlayerCommand(PlayerCommands.COMMAND_STARTPAUSE, false);
                }
                player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, _loc_5);
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

        override protected function addJSCallBack() : void
        {
            UISDK.JsMgr.addCallBack(JSInterface.timeStampPlay, externalVODPlay);
            return;
        }// end function

    }
}
