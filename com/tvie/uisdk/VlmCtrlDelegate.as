package com.tvie.uisdk
{
    import com.tvie.utilities.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class VlmCtrlDelegate extends Object
    {
        protected var _valueBar:MovieClip;
        protected var _rect:Rectangle;
        protected var _container:MovieClip;
        protected var _muteButton:MovieClip;
        protected var _timer:Timer;
        protected var _isMute:Boolean = false;
        protected var _vlmIcon:MovieClip;
        protected var _scrubber:MovieClip;
        protected var _sole:MovieClip;
        protected var _2ndcontainer:MovieClip;
        protected var _volume:Number = 0.5;

        public function VlmCtrlDelegate(param1:MovieClip)
        {
            _timer = new Timer(1000, 1);
            initUI(param1);
            initListeners();
            return;
        }// end function

        protected function onClickMuteHandler(event:MouseEvent) : void
        {
            if (_isMute)
            {
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SOUND_ON, null));
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SET_VOLUME, _volume));
                _muteButton.gotoAndStop(1);
                _scrubber.y = _volume * _container.height;
            }
            else
            {
                _scrubber.y = 0;
                UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SOUND_OFF, null));
                _muteButton.gotoAndStop(2);
            }
            _valueBar.height = _scrubber.y;
            _isMute = !_isMute;
            return;
        }// end function

        protected function initListeners() : void
        {
            _sole.addEventListener(MouseEvent.ROLL_OVER, onRollOverVlmPanel);
            _sole.addEventListener(MouseEvent.ROLL_OUT, onRollOutMuteHandler);
            _muteButton.addEventListener(MouseEvent.CLICK, onClickMuteHandler);
            _scrubber.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragHandler);
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SET_VOLUME, _volume));
            return;
        }// end function

        private function onMSMovingHandler(event:MouseEvent) : void
        {
            _volume = _scrubber.y / _container.height;
            _volume = _volume > 1 ? (1) : (_volume);
            _volume = _volume < 0 ? (0) : (_volume);
            _valueBar.height = _scrubber.y;
            if (_volume == 0)
            {
                _muteButton.gotoAndStop(2);
            }
            else
            {
                _muteButton.gotoAndStop(1);
            }
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SET_VOLUME, _volume));
            return;
        }// end function

        protected function hide2ndcontainer(event:TimerEvent) : void
        {
            _2ndcontainer.visible = false;
            _timer.removeEventListener(TimerEvent.TIMER, hide2ndcontainer);
            return;
        }// end function

        protected function onRollOverVlmPanel(event:MouseEvent) : void
        {
            _2ndcontainer.visible = true;
            _timer.removeEventListener(TimerEvent.TIMER, hide2ndcontainer);
            return;
        }// end function

        protected function onRollOverMuteHandler(event:MouseEvent) : void
        {
            _2ndcontainer.visible = true;
            return;
        }// end function

        protected function initUI(_scrubber:MovieClip) : void
        {
            _sole = _scrubber;
            _2ndcontainer = _sole.slidePanel;
            _2ndcontainer.visible = false;
            _container = _2ndcontainer.slotContainer;
            _scrubber = _container.scrubber;
            _valueBar = _container.slideSlot;
            _muteButton = _sole.vlmButton;
            _rect = new Rectangle(_scrubber.x, 0, 0, _container.height);
            _muteButton.gotoAndStop(1);
            return;
        }// end function

        protected function onRollOutMuteHandler(event:MouseEvent) : void
        {
            _timer.addEventListener(TimerEvent.TIMER, hide2ndcontainer);
            _timer.start();
            return;
        }// end function

        protected function onStopDragHandler(event:MouseEvent) : void
        {
            _scrubber.stopDrag();
            _sole.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMSMovingHandler);
            _sole.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragHandler);
            return;
        }// end function

        protected function onStartDragHandler(event:MouseEvent) : void
        {
            _sole.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMSMovingHandler);
            _sole.stage.addEventListener(MouseEvent.MOUSE_UP, onStopDragHandler);
            _scrubber.startDrag(false, _rect);
            return;
        }// end function

    }
}
