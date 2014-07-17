package gs.core.tween
{
    import gs.*;

    public class Tweenable extends Object
    {
        public var timeline:SimpleTimeline;
        public var initted:Boolean;
        protected var _hasUpdate:Boolean;
        public var active:Boolean;
        protected var _delay:Number;
        public var startTime:Number;
        public var cachedReversed:Boolean;
        public var nextNode:Tweenable;
        public var cachedTime:Number;
        public var gc:Boolean;
        public var cachedDuration:Number;
        public var prevNode:Tweenable;
        public var cacheIsDirty:Boolean;
        public var vars:Object;
        public var cachedTotalTime:Number;
        public var cachedPaused:Boolean;
        public var cachedTotalDuration:Number;
        public var data:Object;
        public var cachedTimeScale:Number;
        public static const version:Number = 0.61;
        static var _classInitted:Boolean;

        public function Tweenable(param1:Number = 0, param2:Object = null)
        {
            this.vars = param2 || {};
            var _loc_4:* = param1 || 0;
            this.cachedTotalDuration = param1 || 0;
            this.cachedDuration = _loc_4;
            _delay = this.vars.delay || 0;
            this.cachedTimeScale = this.vars.timeScale || 1;
            this.active = Boolean(param1 == 0 && _delay == 0 && this.vars.immediateRender != false);
            var _loc_4:int = 0;
            this.cachedTime = 0;
            this.cachedTotalTime = _loc_4;
            this.data = this.vars.data;
            if (!_classInitted)
            {
                if (isNaN(TweenLite.rootFrame))
                {
                    TweenLite.initClass();
                    _classInitted = true;
                }
                else
                {
                    return;
                }
            }
            var _loc_3:* = this.vars.timeline is SimpleTimeline ? (this.vars.timeline) : (this.vars.useFrames ? (TweenLite.rootFramesTimeline) : (TweenLite.rootTimeline));
            this.startTime = _loc_3.cachedTotalTime + _delay;
            _loc_3.addChild(this);
            return;
        }// end function

        public function complete(initClass:Boolean = false) : void
        {
            return;
        }// end function

        public function get totalDuration() : Number
        {
            return this.cachedTotalDuration;
        }// end function

        public function renderTime(initClass:Number, initClass:Boolean = false) : void
        {
            return;
        }// end function

        public function get delay() : Number
        {
            return _delay;
        }// end function

        public function get duration() : Number
        {
            return this.cachedDuration;
        }// end function

        public function set delay(initClass:Number) : void
        {
            this.startTime = this.startTime + (initClass - _delay);
            _delay = initClass;
            return;
        }// end function

        public function set totalDuration(initClass:Number) : void
        {
            this.duration = initClass;
            return;
        }// end function

        public function set duration(initClass:Number) : void
        {
            var _loc_2:* = initClass;
            this.cachedTotalDuration = initClass;
            this.cachedDuration = _loc_2;
            return;
        }// end function

        public function setEnabled(initClass:Boolean, initClass:Boolean = false) : void
        {
            if (initClass == this.gc)
            {
                this.gc = !initClass;
                if (initClass)
                {
                    this.active = Boolean(!this.cachedPaused && this.cachedTotalTime > 0 && this.cachedTotalTime < this.cachedTotalDuration);
                    if (!initClass)
                    {
                        this.timeline.addChild(this);
                    }
                }
                else
                {
                    this.active = false;
                    if (!initClass)
                    {
                        this.timeline.remove(this);
                    }
                }
            }
            return;
        }// end function

    }
}
