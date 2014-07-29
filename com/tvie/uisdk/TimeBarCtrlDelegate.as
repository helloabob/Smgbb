package com.tvie.uisdk
{
    import com.tvie.*;
    import com.tvie.utilities.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class TimeBarCtrlDelegate extends Object
    {
        protected var _playedLine:MovieClip;
        protected var _buffLine:MovieClip;
        protected var _timeBar:MovieClip;
        protected var _timeLine:MovieClip;
        protected var _state:String;
        protected var _ratio:Number;
        protected var _playingTime:TextField;
        protected var _clickLine:MovieClip;
        protected var _durationTime:TextField;
        protected var _seekSuite:MovieClip;
        protected var _absTime:TextField;
        protected var _seekButton:SimpleButton;
        protected var _liveTime:SimpleButton;

        public function TimeBarCtrlDelegate(param1:MovieClip, param2:TextField, param3:TextField)
        {
            initUI(param1, param2, param3);
            initListeners();
            return;
        }// end function

        protected function buffLineWidth(_playedLine:Number, _playedLine:Number, _playedLine:Number, _playedLine:Number) : void
        {
            var _loc_5:* = (_playedLine - _playedLine) / _playedLine * _timeLine.width;
            _loc_5 = _loc_5 > _timeLine.width ? (0) : (_loc_5);
            _buffLine.width = _playedLine / _playedLine * _timeLine.width + _loc_5;
            _buffLine.width = _buffLine.width < 1 ? (1) : (_buffLine.width);
            if (_buffLine.width >= _liveTime.x)
            {
                _buffLine.width = _liveTime.x;
            }
            return;
        }// end function

        protected function onChangePlayerState(event:TVieEvent) : void
        {
            _state = String(event.Info);
            return;
        }// end function

        protected function updateRatio(width:Number) : Number
        {
            var _loc_2:Number = NaN;
            _loc_2 = width / _timeLine.width;
            _loc_2 = _loc_2 < 0 ? (0) : (_loc_2);
            _loc_2 = _loc_2 > 0.99 ? (1) : (_loc_2);
            return _loc_2;
        }// end function

        protected function onStartDragHandler(event:MouseEvent) : void
        {
            if (_state == PlayerStates.MODEL_STATE_BUFFERING || _state == PlayerStates.MODEL_STATE_PAUSED || _state == PlayerStates.MODEL_STATE_PLAYING)
            {
                _timeBar.stage.addEventListener(MouseEvent.MOUSE_UP, onStopDragSeekBtn);
                _timeBar.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMovingHandler);
                _seekSuite.startDrag(false, new Rectangle(0, _seekSuite.y, _timeLine.width, 0));
                _ratio = updateRatio(_seekSuite.x);
                updateTime();
            }
            return;
        }// end function

        protected function initListeners() : void
        {
            _seekSuite.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragHandler);
            _seekButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverSeekBtnHandler);
            _seekButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutSeekBtnHandler);
            _clickLine.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownClickLineHander);
            _clickLine.addEventListener(MouseEvent.MOUSE_UP, onMouseUpClickLineHander);
            UISDK.eDispather.addEventListener(UIEvent.UI_UPDATE_TIMEBAR, onUpdateTimeBarHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, onChangePlayerState);
            return;
        }// end function

        protected function onMouseUpClickLineHander(event:MouseEvent) : void
        {
            _ratio = updateRatio(_timeBar.mouseX);
            updateTime();
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SEEKPLAY, _ratio));
            return;
        }// end function

        protected function seekButtonPosition(offset:Number, total:Number) : void
        {
            offset = offset < 0 ? (0) : (offset);
            _seekSuite.x = offset / total * _timeLine.width;
            _playedLine.width = _seekSuite.x;
            return;
        }// end function

        protected function onMouseOverSeekBtnHandler(event:MouseEvent) : void
        {
            _absTime.visible = true;
            return;
        }// end function

        protected function absTime(_playedLine:Number) : void
        {
            var _loc_2:* = UISDK.config.Params["starttime"] + _playedLine;
            var _loc_3:* = new Date();
            _loc_3.setTime(_loc_2 * 1000);
            var _loc_4:* = _loc_3.getHours() < 10 ? ("0" + _loc_3.getHours().toString()) : (_loc_3.getHours().toString());
            var _loc_5:* = _loc_3.getMinutes() < 10 ? ("0" + _loc_3.getMinutes().toString()) : (_loc_3.getMinutes().toString());
            var _loc_6:* = _loc_3.getSeconds() < 10 ? ("0" + _loc_3.getSeconds().toString()) : (_loc_3.getSeconds().toString());
            _absTime.text = _loc_4 + ":" + _loc_5 + ":" + _loc_6;
            return;
        }// end function

        protected function initUI(timeBar:MovieClip, playingTime:TextField, durationTime:TextField) : void
        {
            _timeBar = timeBar;
            _timeLine = _timeBar.timeLine;
            _buffLine = _timeBar.bufferingLine;
            _liveTime = _timeBar.liveTime;
            _playedLine = _timeBar.playedLine;
            _seekSuite = _timeBar.seekSuite;
            _seekButton = _seekSuite.seekButton;
            _absTime = _seekSuite.absTime;
            _absTime.visible = false;
            _clickLine = _timeBar.clickLine;
            _clickLine.buttonMode = true;
            _playingTime = playingTime;
            _durationTime = durationTime;
            return;
        }// end function

        protected function onMouseOutSeekBtnHandler(event:MouseEvent) : void
        {
            _absTime.visible = false;
            return;
        }// end function

        protected function onStopDragSeekBtn(event:MouseEvent) : void
        {
            _ratio = updateRatio(_seekSuite.x);
            updateTime();
            _seekSuite.stopDrag();
            _timeBar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMovingHandler);
            _timeBar.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragSeekBtn);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SEEKPLAY, _ratio));
            return;
        }// end function

        protected function liveTimePosition(_playedLine:Number, _playedLine:Number, _playedLine:Number) : void
        {
            if (_playedLine >= _playedLine)
            {
                _liveTime.visible = false;
                _liveTime.x = _timeLine.width;
            }
            else
            {
                _liveTime.visible = true;
                _liveTime.x = (_playedLine - _playedLine) / (_playedLine - _playedLine) * _timeLine.width;
            }
            return;
        }// end function

        protected function onMouseMovingHandler(event:MouseEvent) : void
        {
            _ratio = updateRatio(_seekSuite.x);
            updateTime();
            _playedLine.width = _seekSuite.x;
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SEEK, _ratio));
            return;
        }// end function

        protected function onMouseDownClickLineHander(event:MouseEvent) : void
        {
            _ratio = updateRatio(_timeBar.mouseX);
            updateTime();
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SEEK, _ratio));
            return;
        }// end function

        protected function onUpdateTimeBarHandler(event:TVieEvent) : void
        {
            var _loc_2:* = event.Info["streamStart"];
            var _loc_3:* = event.Info["playTime"];
            var _loc_4:* = event.Info["liveTime"];
            var _loc_5:* = event.Info["buffLength"];
            var _loc_6:* = UISDK.config.Params["starttime"];
            var _loc_7:* = UISDK.config.Params["endtime"];
            var _loc_8:* = _loc_7 - _loc_6;
            var _loc_9:* = _loc_3 - _loc_6 > _loc_8 ? (_loc_8) : (_loc_3 - _loc_6);
            _loc_9 = _loc_9 < 0 ? (0) : (_loc_9);
            seekButtonPosition(_loc_9, _loc_8);
            playingText(_loc_9, _loc_8);
            absTime(_loc_9);
            buffLineWidth(_loc_5, _loc_2, _loc_8, _loc_6);
            liveTimePosition(_loc_4, _loc_6, _loc_7);
            return;
        }// end function

        protected function playingText(_playedLine:Number, _playedLine:Number) : void
        {
            _durationTime.text = formatTime(_playedLine) + " " + "/" + " " + formatTime(_playedLine);
            return;
        }// end function

        protected function formatTime(removeEventListener:int) : String
        {
            var _loc_2:* = int(removeEventListener % 60).toString();
            var _loc_3:* = int(removeEventListener / 60 % 60).toString();
            var _loc_4:* = int(removeEventListener / 60 / 60).toString();
            _loc_2 = int(_loc_2) < 10 ? ("0" + _loc_2) : (_loc_2);
            _loc_3 = int(_loc_3) < 10 ? ("0" + _loc_3) : (_loc_3);
            _loc_4 = int(_loc_4) < 10 ? ("0" + _loc_4) : (_loc_4);
            return _loc_4 + ":" + _loc_3 + ":" + _loc_2;
        }// end function

        protected function updateTime() : void
        {
            var _loc_1:* = UISDK.config.Params["endtime"] - UISDK.config.Params["starttime"];
            var _loc_2:* = _ratio * _loc_1;
            playingText(_loc_2, _loc_1);
            absTime(_loc_2);
            return;
        }// end function

    }
}
