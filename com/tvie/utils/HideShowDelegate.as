package com.tvie.utils
{
    import HideShowDelegate.as$53.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import flash.utils.*;

    public class HideShowDelegate extends Sprite
    {
        private var _cusArr:Array;
        private var _idleCount:Number = 0;
        private var _nMouseX:Number = 0;
        private var _nMouseY:Number = 0;
        private var _interval:int = 66;
        private var _tvietimer:Timer;
        private var _isLitmited:Boolean = false;
        private var _bIsMouseOn:Boolean = false;
        private var _idleThreshold:int = 5000;
        private static var _self:HideShowDelegate;

        public function HideShowDelegate(param1:PrivateClass)
        {
            _cusArr = new Array();
            _tvietimer = new Timer(_interval);
            _tvietimer.addEventListener(TimerEvent.TIMER, timerHandler);
            _tvietimer.start();
            return;
        }// end function

        private function hide() : void
        {
            var _loc_2:Function = null;
            if (stage != null && stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                Mouse.hide();
            }
            var _loc_1:int = 0;
            while (_loc_1 < _cusArr.length)
            {
                
                _loc_2 = _cusArr[_loc_1].hide;
                this._loc_2(null);
                _loc_1++;
            }
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            if (_nMouseX == this.mouseX && _nMouseY == this.mouseY)
            {
                if (_bIsMouseOn == true)
                {
                    show();
                }
                else
                {
                    _idleCount = _idleCount + _interval;
                    if (_idleCount > _idleThreshold)
                    {
                        hide();
                    }
                }
            }
            else
            {
                _nMouseX = this.mouseX;
                _nMouseY = this.mouseY;
                if (_isLitmited == true && (this.mouseX * this.scaleX < 0 || this.mouseX * this.scaleX > this.width || this.mouseY * this.scaleY < 0 || this.mouseY * this.scaleY > this.height))
                {
                    _idleCount = _idleCount + _interval;
                    if (_idleCount > _idleThreshold)
                    {
                        hide();
                    }
                }
                else
                {
                    _idleCount = 0;
                    show();
                }
            }
            return;
        }// end function

        public function subscribe(TIMER:Object, TIMER:Function, TIMER:Function) : void
        {
            var _loc_4:* = new Object();
            _loc_4.customer = Sprite(TIMER);
            _loc_4.customer.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
            _loc_4.customer.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
            _loc_4.hide = TIMER;
            _loc_4.show = TIMER;
            _cusArr.push(_loc_4);
            stage.addEventListener(FullScreenEvent.FULL_SCREEN, FullScreenHandler);
            return;
        }// end function

        private function FullScreenHandler(event:FullScreenEvent) : void
        {
            _bIsMouseOn = false;
            return;
        }// end function

        private function onMouseRollOver(event:MouseEvent) : void
        {
            _bIsMouseOn = true;
            return;
        }// end function

        private function onMouseRollOut(event:MouseEvent) : void
        {
            _bIsMouseOn = false;
            return;
        }// end function

        public function setRectangle(TIMER:Rectangle = null) : void
        {
            if (TIMER != null)
            {
                this.x = TIMER.x;
                this.y = TIMER.y;
                this.width = TIMER.width;
                this.height = TIMER.height;
                _isLitmited = true;
            }
            else
            {
                _isLitmited = false;
            }
            return;
        }// end function

        public function unSubscribe(TIMER:Object) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < _cusArr.length)
            {
                
                if (_cusArr[_loc_2].customer == TIMER)
                {
                    _cusArr[_loc_2].customer.removeEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
                    _cusArr[_loc_2].customer.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
                    _cusArr.splice(_loc_2, 1);
                }
                _loc_2++;
            }
            return;
        }// end function

        private function show() : void
        {
            var _loc_2:Function = null;
            Mouse.show();
            var _loc_1:int = 0;
            while (_loc_1 < _cusArr.length)
            {
                
                _loc_2 = _cusArr[_loc_1].show;
                this._loc_2(null);
                _loc_1++;
            }
            return;
        }// end function

        public static function getInstance() : HideShowDelegate
        {
            if (_self == null)
            {
                _self = new HideShowDelegate(new PrivateClass());
                _self.graphics.drawRect(0, 0, 1, 1);
            }
            return _self;
        }// end function

    }
}
