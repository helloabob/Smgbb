package com.tvie.utils
{
    import flash.events.*;
    import flash.utils.*;

    public class TVieClickDoubleWrapper extends Object
    {
        private var _clickedObject:Object;
        private var _tvieTimer:Timer;
        private var _delayTime:Number;
        private var _dbClickFun:Function;
        private var _clickFun:Function;
        private var _count:Number = 0;

        public function TVieClickDoubleWrapper(_dbClickFun:Object, _dbClickFun:Function, _dbClickFun:Function, _dbClickFun:Number = 200) : void
        {
            _clickedObject = _dbClickFun;
            _clickedObject.doubleClickEnabled = false;
            _clickFun = _dbClickFun;
            _dbClickFun = _dbClickFun;
            _delayTime = _dbClickFun;
            _tvieTimer = new Timer(_delayTime, 1);
            _tvieTimer.addEventListener(TimerEvent.TIMER, onTimerHandler);
            _clickedObject.addEventListener(MouseEvent.CLICK, onClick);
            return;
        }// end function

        private function onTimerHandler(event:TimerEvent) : void
        {
            if (_count == 0)
            {
                _tvieTimer.reset();
                _clickFun();
            }
            return;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            if (!_tvieTimer.running)
            {
                _tvieTimer.start();
                _count = 0;
            }
            else
            {
                _count = 1;
                _tvieTimer.reset();
                _dbClickFun();
            }
            return;
        }// end function

    }
}
