package com.tvie.uisdk
{
    import com.tvie.*;
    import com.tvie.utilities.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;

    public class PlayPanelEx extends Panel
    {
        protected var _bkButton:SimpleButton;
        protected var _fwButton:SimpleButton;
        protected var _pauseButton:SimpleButton;
        protected var _state:String;
        protected var _playButton:SimpleButton;
        protected var _timeBarDelegate:TimeBarCtrlDelegate;
        protected var _vlmWrapper:VlmCtrlDelegate;
        protected var _fsButton:MovieClip;

        public function PlayPanelEx(param1:Sprite = null)
        {
            super(param1);
            initUI();
            initListeners();
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            sole.width = UISDK.config.Rect.playerWidth;
            sole.scaleY = sole.scaleX;
            sole.x = UISDK.config.Rect.playerX;
            sole.y = UISDK.config.Rect.playerHeight + UISDK.config.Rect.playerY - sole.height;
            return;
        }// end function

        protected function onClickFullScreenHandler(event:MouseEvent) : void
        {
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_FULLSCREEN, null));
            return;
        }// end function

        protected function initListeners() : void
        {
            _playButton.addEventListener(MouseEvent.CLICK, onClickPlayBtnHandler);
            _pauseButton.addEventListener(MouseEvent.CLICK, onClickPauseBtnHandler);
            _fsButton.addEventListener(MouseEvent.CLICK, onClickFullScreenHandler);
            _bkButton.addEventListener(MouseEvent.CLICK, onClickBackBtnHandler);
            _fwButton.addEventListener(MouseEvent.CLICK, onClickForwardBtnHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, onChangePlayerStateHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_FULLSCREEN_STATE, onFullScreenHandler);
            return;
        }// end function

        protected function onFullScreenHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Boolean(event.Info);
            if (_loc_2)
            {
                sole.part3.FullScreenButton.gotoAndStop(2);
            }
            else
            {
                sole.part3.FullScreenButton.gotoAndStop(1);
            }
            return;
        }// end function

        protected function onClickForwardBtnHandler(event:MouseEvent) : void
        {
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SWITCH2NEXT_PROG, null));
            return;
        }// end function

        protected function onClickPauseBtnHandler(event:MouseEvent) : void
        {
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PAUSE, null));
            return;
        }// end function

        protected function get sole() : Object
        {
            return component as PlayPanel;
        }// end function

        override protected function hide(event:TVieEvent) : void
        {
            TweenLite.to(sole, 0.5, {alpha:0, visible:false});
            return;
        }// end function

        protected function onClickBackBtnHandler(event:MouseEvent) : void
        {
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SWITCH2PRES_PROG, null));
            return;
        }// end function

        protected function onChangePlayerStateHandler(event:TVieEvent) : void
        {
            _state = String(event.Info);
            if (_state == PlayerStates.MODEL_STATE_PLAYING)
            {
                _pauseButton.visible = true;
                _playButton.visible = false;
            }
            if (_state == PlayerStates.MODEL_STATE_PAUSED)
            {
                _playButton.visible = true;
                _pauseButton.visible = false;
            }
            return;
        }// end function

        protected function onClickPlayBtnHandler(event:MouseEvent) : void
        {
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PLAY, null));
            return;
        }// end function

        protected function initUI() : void
        {
            _vlmWrapper = new VlmCtrlDelegate(sole.part3.vlmCtrl);
            _timeBarDelegate = new TimeBarCtrlDelegate(sole.part2.timeBar, null, sole.part3.playerTimeText);
            _playButton = sole.part1.playButton;
            _pauseButton = sole.part1.pauseButton;
            _playButton.visible = true;
            _pauseButton.visible = false;
            _fsButton = sole.part3.FullScreenButton;
            _bkButton = sole.part1.bkButton;
            _fwButton = sole.part3.fwButton;
            return;
        }// end function

        override protected function show(event:TVieEvent) : void
        {
            TweenLite.to(sole, 0.5, {alpha:1, visible:true});
            return;
        }// end function

    }
}
