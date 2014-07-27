package com.smgbbv2
{
    import com.epg.*;
    import com.tvie.*;
    import com.tvie.uisdk.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
	import com.tvie.utils.Comm;
    import flash.display.*;
    import flash.events.*;

    public class SmgbbPlayerPanelEx extends PlayerPanelEx
    {

        public function SmgbbPlayerPanelEx(param1:Sprite = null)
        {
            super(param1);
            _linkPattern = new Array("smgbb", "bbtv");
            return;
        }// end function

        override protected function onRemotePlayHandler(event:TVieEvent) : void
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
            if (_loc_4 == RequestType.TYPE_LIVE || !(com.tvie.utils.Comm.tvie_equalObj(_loc_3, _requestObj)) || !(com.tvie.utils.Comm.tvie_equalObj(_requestObj, _loc_3)))
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
                    _loc_2["starttime"] = com.tvie.utils.Comm.tvie_time() + UISDK.config.Params["timeOffset"];
                    player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, _loc_2);
                }
                else
                {
                    player.sendPlayerCommand(PlayerCommands.COMMAND_PLAY, UISDK.config.Params);
                }
            }
            return;
        }// end function

        override protected function onTimerHandler(event:TimerEvent) : void
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
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            player.x = UISDK.config.Rect.playerX;
            player.y = UISDK.config.Rect.playerY;
            player.width = UISDK.config.Rect.playWidth;
            player.height = UISDK.config.Rect.playerHeight - UISDK.config.Rect.playHeight;
            return;
        }// end function

    }
}
