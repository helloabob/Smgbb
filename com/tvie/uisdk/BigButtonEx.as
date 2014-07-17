package com.tvie.uisdk
{
    import com.tvie.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class BigButtonEx extends Panel
    {
        private var _timer:Timer;

        public function BigButtonEx(param1:Sprite = null)
        {
            _timer = new Timer(500);
            super(param1);
            HideShowDelegate.getInstance().unSubscribe(sole);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, onChangePlayerStateHandler);
            sole.addEventListener(MouseEvent.CLICK, onClickHandler);
            sole.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
            _timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
            sole.visible = false;
            sole.buttonMode = true;
            return;
        }// end function

        private function onClickHandler(event:MouseEvent) : void
        {
            sole.visible = false;
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PLAY, null));
            return;
        }// end function

        private function onMouseDownHandler(event:MouseEvent) : void
        {
            sole.gotoAndStop(3);
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            var _loc_2:* = UISDK.config.Rect;
            sole.x = _loc_2.playerX + _loc_2.playerWidth / 2;
            sole.y = _loc_2.playerY + _loc_2.playerHeight / 2;
            return;
        }// end function

        private function get sole() : BigButton
        {
            return component as BigButton;
        }// end function

        override protected function onMouseRollOver(event:MouseEvent) : void
        {
            isMouseOn = false;
            sole.gotoAndStop(2);
            return;
        }// end function

        private function onChangePlayerStateHandler(event:TVieEvent) : void
        {
            var _loc_2:* = String(event.Info);
            if (_loc_2 == PlayerStates.MODEL_STATE_PAUSED)
            {
                sole.gotoAndStop(1);
                _timer.start();
                sole.visible = true;
            }
            else
            {
                _timer.reset();
                sole.visible = false;
            }
            return;
        }// end function

        override protected function onMouseRollOut(event:MouseEvent) : void
        {
            isMouseOn = false;
            sole.gotoAndStop(1);
            return;
        }// end function

        private function onTimerHandler(event:TimerEvent) : void
        {
            if (sole.currentFrame == 1 && sole.pause != null)
            {
                sole.pause.visible = !sole.pause.visible;
            }
            return;
        }// end function

    }
}
