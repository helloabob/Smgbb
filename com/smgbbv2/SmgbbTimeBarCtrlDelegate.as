package com.smgbbv2
{
    import com.tvie.uisdk.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class SmgbbTimeBarCtrlDelegate extends TimeBarCtrlDelegate
    {

        public function SmgbbTimeBarCtrlDelegate(param1:MovieClip, param2:TextField, param3:TextField)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override protected function playingText(param1:Number, param2:Number) : void
        {
            _playingTime.text = formatTime(param1);
            _durationTime.text = formatTime(param2);
            return;
        }// end function

        override protected function initUI(param1:MovieClip, param2:TextField, param3:TextField) : void
        {
            _timeBar = param1;
            _timeLine = _timeBar.timeLine;
            _buffLine = _timeBar.bufferingLine;
            _liveTime = _timeBar.liveTime;
            _playedLine = _timeBar.playedLine;
            _seekSuite = _timeBar.seekSuite;
            _seekButton = _seekSuite.seekButton;
            _playingTime = param2;
            _durationTime = param3;
            return;
        }// end function

        override protected function absTime(param:Number) : void
        {
            return;
        }// end function

        override protected function initListeners() : void
        {
            _seekButton.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_UPDATE_TIMEBAR, onUpdateTimeBarHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, onChangePlayerState);
            return;
        }// end function

    }
}
