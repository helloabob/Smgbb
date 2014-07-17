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

        override protected function playingText(com.smgbbv2:Number, com.smgbbv2:Number) : void
        {
            _playingTime.text = formatTime(com.smgbbv2);
            _durationTime.text = formatTime(com.smgbbv2);
            return;
        }// end function

        override protected function initUI(com.smgbbv2:MovieClip, com.smgbbv2:TextField, com.smgbbv2:TextField) : void
        {
            _timeBar = com.smgbbv2;
            _timeLine = _timeBar.timeLine;
            _buffLine = _timeBar.bufferingLine;
            _liveTime = _timeBar.liveTime;
            _playedLine = _timeBar.playedLine;
            _seekSuite = _timeBar.seekSuite;
            _seekButton = _seekSuite.seekButton;
            _playingTime = com.smgbbv2;
            _durationTime = com.smgbbv2;
            return;
        }// end function

        override protected function absTime(com.smgbbv2:Number) : void
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
