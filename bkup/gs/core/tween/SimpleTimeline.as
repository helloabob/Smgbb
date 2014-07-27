package gs.core.tween
{

    public class SimpleTimeline extends Tweenable
    {
        public var autoRemoveChildren:Boolean;
        protected var _lastChild:Tweenable;
        protected var _firstChild:Tweenable;

        public function SimpleTimeline(param1:Object = null)
        {
            super(0, param1);
            return;
        }// end function

        override public function renderTime(gc:Number, gc:Boolean = false) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Tweenable = null;
            var _loc_6:* = gc;
            this.cachedTime = gc;
            this.cachedTotalTime = _loc_6;
            var _loc_3:* = _firstChild;
            while (_loc_3 != null)
            {
                
                _loc_5 = _loc_3.nextNode;
                if (_loc_3.active || gc >= _loc_3.startTime && !_loc_3.cachedPaused)
                {
                    if (!_loc_3.cachedReversed)
                    {
                        _loc_3.renderTime((gc - _loc_3.startTime) * _loc_3.cachedTimeScale);
                    }
                    else
                    {
                        _loc_4 = _loc_3.cacheIsDirty ? (_loc_3.totalDuration) : (_loc_3.cachedTotalDuration);
                        _loc_3.renderTime(_loc_4 - (gc - _loc_3.startTime) * _loc_3.cachedTimeScale);
                    }
                }
                _loc_3 = _loc_5;
            }
            return;
        }// end function

        public function addChild(gc:Tweenable) : void
        {
            if (gc.timeline != null && !gc.gc)
            {
                gc.timeline.remove(gc, true);
            }
            gc.timeline = this;
            if (gc.gc)
            {
                gc.setEnabled(true, true);
            }
            if (_firstChild != null)
            {
                _firstChild.prevNode = gc;
                gc.nextNode = _firstChild;
            }
            else
            {
                gc.nextNode = null;
            }
            _firstChild = gc;
            gc.prevNode = null;
            return;
        }// end function

        public function remove(gc:Tweenable, gc:Boolean = false) : void
        {
            if (!gc.gc && !gc)
            {
                gc.setEnabled(false, true);
            }
            if (gc.nextNode != null)
            {
                gc.nextNode.prevNode = gc.prevNode;
            }
            else if (_lastChild == gc)
            {
                _lastChild = gc.prevNode;
            }
            if (gc.prevNode != null)
            {
                gc.prevNode.nextNode = gc.nextNode;
            }
            else if (_firstChild == gc)
            {
                _firstChild = gc.nextNode;
            }
            var _loc_3:String = null;
            gc.prevNode = null;
            gc.nextNode = _loc_3;
            return;
        }// end function

        public function get rawTime() : Number
        {
            return this.cachedTotalTime;
        }// end function

    }
}
