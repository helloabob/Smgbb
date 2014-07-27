package gs
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import gs.core.tween.*;

    public class TweenLite extends Tweenable
    {
        protected var _hasPlugins:Boolean;
        public var propTweenLookup:Object;
        protected var _overwrittenProps:Object;
        public var target:Object;
        protected var _notifyPluginsOfEnabled:Boolean;
        public var ease:Function;
        protected var _firstPropTween:PropTween;
        public static var rootTimeline:SimpleTimeline;
        public static var onPluginEvent:Function;
        public static var rootFramesTimeline:SimpleTimeline;
        public static var defaultEase:Function = TweenLite.easeOut;
        public static const version:Number = 11.0984;
        public static var plugins:Object = {};
        public static var masterList:Dictionary = new Dictionary(false);
        public static var overwriteManager:Object;
        public static var rootFrame:Number;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
        public static var timingSprite:Sprite = new Sprite();
        static var _reservedProps:Object = {ease:1, delay:1, overwrite:1, onComplete:1, onCompleteParams:1, useFrames:1, runBackwards:1, startAt:1, onUpdate:1, onUpdateParams:1, roundProps:1, onStart:1, onStartParams:1, onReverseComplete:1, onReverseCompleteParams:1, onRepeat:1, onRepeatParams:1, proxiedEase:1, easeParams:1, yoyo:1, onCompleteListener:1, onUpdateListener:1, onStartListener:1, orientToBezier:1, timeScale:1, immediateRender:1, repeat:1, repeatDelay:1, timeline:1, data:1};

        public function TweenLite(param1:Object, param2:Number, param3:Object)
        {
            var _loc_4:int = 0;
            var _loc_5:Array = null;
            var _loc_6:TweenLite = null;
            super(param2, param3);
            this.ease = typeof(this.vars.ease) != "function" ? (defaultEase) : (this.vars.ease);
            this.target = param1;
            if (this.vars.easeParams != null)
            {
                this.vars.proxiedEase = this.ease;
                this.ease = easeProxy;
            }
            propTweenLookup = {};
            if (!(param1 in masterList))
            {
                masterList[param1] = [this];
            }
            else
            {
                _loc_4 = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1 ? (overwriteManager.mode) : (int(param3.overwrite));
                if (_loc_4 == 1)
                {
                    _loc_5 = masterList[param1];
                    for each (_loc_6 in _loc_5)
                    {
                        
                        if (!_loc_6.gc)
                        {
                            _loc_6.setEnabled(false, false);
                        }
                    }
                    masterList[param1] = [this];
                }
                else
                {
                    masterList[param1].push(this);
                }
            }
            if (this.active || this.vars.immediateRender)
            {
                renderTime(0);
            }
            return;
        }// end function

        protected function easeProxy(runBackwards:Number, runBackwards:Number, runBackwards:Number, runBackwards:Number) : Number
        {
            return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
        }// end function

        override public function renderTime(onComplete:Number, onComplete:Boolean = false) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Boolean = false;
            var _loc_5:* = this.cachedTime;
            this.active = true;
            if (onComplete >= this.cachedDuration)
            {
                var _loc_7:* = this.cachedDuration;
                this.cachedTime = this.cachedDuration;
                this.cachedTotalTime = _loc_7;
                _loc_3 = 1;
                _loc_4 = true;
            }
            else if (onComplete <= 0)
            {
                var _loc_7:int = 0;
                _loc_3 = 0;
                var _loc_7:* = _loc_7;
                this.cachedTime = _loc_7;
                this.cachedTotalTime = _loc_7;
                if (onComplete < 0)
                {
                    this.active = false;
                }
            }
            else
            {
                var _loc_7:* = onComplete;
                this.cachedTime = onComplete;
                this.cachedTotalTime = _loc_7;
                _loc_3 = this.ease(onComplete, 0, 1, this.cachedDuration);
            }
            if (!this.initted)
            {
                init();
                if (this.vars.onStart != null)
                {
                    this.vars.onStart.apply(null, this.vars.onStartParams);
                }
            }
            else if (this.cachedTime == _loc_5 && !onComplete)
            {
                return;
            }
            var _loc_6:* = _firstPropTween;
            while (_loc_6 != null)
            {
                
                _loc_6.target[_loc_6.property] = _loc_6.start + _loc_3 * _loc_6.change;
                _loc_6 = _loc_6.nextNode;
            }
            if (_hasUpdate)
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            }
            if (_loc_4)
            {
                complete(true);
            }
            return;
        }// end function

        protected function removePropTween(onComplete:PropTween) : void
        {
            if (onComplete.isPlugin && onComplete.target.onDisable != null)
            {
                onComplete.target.onDisable();
            }
            if (onComplete.nextNode != null)
            {
                onComplete.nextNode.prevNode = onComplete.prevNode;
            }
            if (onComplete.prevNode != null)
            {
                onComplete.prevNode.nextNode = onComplete.nextNode;
            }
            else if (_firstPropTween == onComplete)
            {
                _firstPropTween = onComplete.nextNode;
            }
            return;
        }// end function

        protected function insertPropTween(flash.events:Object, flash.events:String, flash.events:Number, flash.events, flash.events:String, flash.events:Boolean, flash.events:PropTween) : PropTween
        {
            var _loc_9:Array = null;
            var _loc_10:int = 0;
            var _loc_8:* = new PropTween(flash.events, flash.events, flash.events, typeof(flash.events) == "number" ? (flash.events - flash.events) : (Number(flash.events)), flash.events, flash.events, flash.events);
            if (flash.events != null)
            {
                flash.events.prevNode = _loc_8;
            }
            if (flash.events && flash.events == "_MULTIPLE_")
            {
                _loc_9 = flash.events.overwriteProps;
                _loc_10 = _loc_9.length - 1;
                while (_loc_10 > -1)
                {
                    
                    propTweenLookup[_loc_9[_loc_10]] = _loc_8;
                    _loc_10 = _loc_10 - 1;
                }
            }
            else
            {
                propTweenLookup[flash.events] = _loc_8;
            }
            return _loc_8;
        }// end function

        protected function init() : void
        {
            var _loc_1:String = null;
            var _loc_2:int = 0;
            var _loc_3:* = undefined;
            var _loc_4:Boolean = false;
            var _loc_6:PropTween = null;
            var _loc_5:* = this.vars.isTV == true ? (this.vars.exposedVars) : (this.vars);
            propTweenLookup = {};
            if (_loc_5.timeScale != undefined && this.target is Tweenable)
            {
                _firstPropTween = insertPropTween(this.target, "timeScale", this.target.timeScale, _loc_5.timeScale, "timeScale", false, _firstPropTween);
            }
            for (_loc_1 in _loc_5)
            {
                
                if (_loc_1 in _reservedProps)
                {
                    continue;
                }
                if (_loc_1 in plugins)
                {
                    _loc_3 = new plugins[_loc_1];
                    if (_loc_3.onInitTween(this.target, _loc_5[_loc_1], this) == false)
                    {
                        _firstPropTween = insertPropTween(this.target, _loc_1, this.target[_loc_1], _loc_5[_loc_1], _loc_1, false, _firstPropTween);
                    }
                    else
                    {
                        _firstPropTween = insertPropTween(_loc_3, "changeFactor", 0, 1, _loc_3.overwriteProps.length == 1 ? (_loc_3.overwriteProps[0]) : ("_MULTIPLE_"), true, _firstPropTween);
                        _hasPlugins = true;
                        if (_loc_3.priority != 0)
                        {
                            _firstPropTween.priority = _loc_3.priority;
                            _loc_4 = true;
                        }
                        if (_loc_3.onDisable != null || _loc_3.onEnable != null)
                        {
                            _notifyPluginsOfEnabled = true;
                        }
                    }
                    continue;
                }
                _firstPropTween = insertPropTween(this.target, _loc_1, this.target[_loc_1], _loc_5[_loc_1], _loc_1, false, _firstPropTween);
            }
            if (_loc_4)
            {
                _firstPropTween = onPluginEvent("onInit", _firstPropTween);
            }
            if (this.vars.runBackwards == true)
            {
                _loc_6 = _firstPropTween;
                while (_loc_6 != null)
                {
                    
                    _loc_6.start = _loc_6.start + _loc_6.change;
                    _loc_6.change = -_loc_6.change;
                    _loc_6 = _loc_6.nextNode;
                }
            }
            _hasUpdate = Boolean(this.vars.onUpdate != null);
            if (_overwrittenProps != null)
            {
                killVars(_overwrittenProps);
            }
            if (TweenLite.overwriteManager.enabled && _firstPropTween != null && TweenLite.overwriteManager.mode > 1 && this.target in masterList)
            {
                overwriteManager.manageOverwrites(this, propTweenLookup, masterList[this.target]);
            }
            this.initted = true;
            return;
        }// end function

        override public function complete(onComplete:Boolean = false) : void
        {
            if (!onComplete)
            {
                renderTime(this.cachedTotalDuration);
                return;
            }
            if (_hasPlugins)
            {
                onPluginEvent("onComplete", _firstPropTween);
            }
            if (this.timeline.autoRemoveChildren)
            {
                this.setEnabled(false, false);
            }
            else
            {
                this.active = false;
            }
            if (this.vars.onComplete != null && (this.cachedTotalTime != 0 || this.cachedDuration == 0))
            {
                this.vars.onComplete.apply(null, this.vars.onCompleteParams);
            }
            return;
        }// end function

        public function killVars(onComplete:Object, onComplete:Boolean = true) : void
        {
            var _loc_3:String = null;
            var _loc_4:PropTween = null;
            if (_overwrittenProps == null)
            {
                _overwrittenProps = {};
            }
            for (_loc_3 in onComplete)
            {
                
                if (_loc_3 in propTweenLookup)
                {
                    _loc_4 = propTweenLookup[_loc_3];
                    if (_loc_4.isPlugin && _loc_4.name == "_MULTIPLE_")
                    {
                        _loc_4.target.killProps(onComplete);
                        if (_loc_4.target.overwriteProps.length == 0)
                        {
                            removePropTween(_loc_4);
                            delete propTweenLookup[_loc_3];
                        }
                    }
                    else
                    {
                        removePropTween(_loc_4);
                        delete propTweenLookup[_loc_3];
                    }
                }
                if (onComplete)
                {
                    _overwrittenProps[_loc_3] = 1;
                }
            }
            return;
        }// end function

        override public function setEnabled(onComplete:Boolean, onComplete:Boolean = false) : void
        {
            if (onComplete == this.gc)
            {
                if (onComplete)
                {
                    if (!(this.target in TweenLite.masterList))
                    {
                        TweenLite.masterList[this.target] = [this];
                    }
                    else
                    {
                        TweenLite.masterList[this.target].push(this);
                    }
                }
                super.setEnabled(onComplete, onComplete);
                if (_notifyPluginsOfEnabled)
                {
                    onPluginEvent(onComplete ? ("onEnable") : ("onDisable"), _firstPropTween);
                }
            }
            return;
        }// end function

        public static function delayedCall(onCompleteParams:Number, onCompleteParams:Function, onCompleteParams:Array = null, onCompleteParams:Boolean = false) : TweenLite
        {
            return new TweenLite(onCompleteParams, 0, {delay:onCompleteParams, onComplete:onCompleteParams, onCompleteParams:onCompleteParams, immediateRender:false, useFrames:onCompleteParams, overwrite:0});
        }// end function

        public static function removeTween(onComplete:TweenLite) : void
        {
            if (onComplete != null)
            {
                onComplete.setEnabled(false, false);
            }
            return;
        }// end function

        public static function initClass() : void
        {
            rootFrame = 0;
            rootTimeline = new SimpleTimeline(null);
            rootFramesTimeline = new SimpleTimeline(null);
            rootTimeline.startTime = getTimer() * 0.001;
            rootFramesTimeline.startTime = rootFrame;
            var _loc_1:Boolean = true;
            rootFramesTimeline.autoRemoveChildren = true;
            rootTimeline.autoRemoveChildren = _loc_1;
            timingSprite.addEventListener(Event.ENTER_FRAME, updateAll, false, 0, true);
            if (overwriteManager == null)
            {
                overwriteManager = {mode:1, enabled:false};
            }
            return;
        }// end function

        public static function killTweensOf(onComplete:Object, onComplete:Boolean = false) : void
        {
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            if (onComplete != null && onComplete in masterList)
            {
                _loc_3 = masterList[onComplete];
                _loc_4 = _loc_3.length;
                while (_loc_4-- > 0)
                {
                    
                    if (!_loc_3[_loc_4].gc)
                    {
                        if (onComplete)
                        {
                            _loc_3[_loc_4].complete(false);
                            continue;
                        }
                        _loc_3[_loc_4].setEnabled(false, false);
                    }
                }
                delete masterList[onComplete];
            }
            return;
        }// end function

        public static function from(onCompleteParams:Object, onCompleteParams:Number, onCompleteParams:Object) : TweenLite
        {
            onCompleteParams.runBackwards = true;
            if (onCompleteParams.immediateRender != false)
            {
                onCompleteParams.immediateRender = true;
            }
            return new TweenLite(onCompleteParams, onCompleteParams, onCompleteParams);
        }// end function

        static function easeOut(runBackwards:Number, runBackwards:Number, runBackwards:Number, runBackwards:Number) : Number
        {
            var _loc_5:* = runBackwards / runBackwards;
            runBackwards = runBackwards / runBackwards;
            return (-runBackwards) * _loc_5 * (runBackwards - 2) + runBackwards;
        }// end function

        static function updateAll(event:Event = null) : void
        {
            var _loc_2:Dictionary = null;
            var _loc_3:Object = null;
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            rootTimeline.renderTime((getTimer() * 0.001 - rootTimeline.startTime) * rootTimeline.cachedTimeScale);
            var _loc_7:* = rootFrame + 1;
            rootFrame = _loc_7;
            rootFramesTimeline.renderTime((rootFrame - rootFramesTimeline.startTime) * rootFramesTimeline.cachedTimeScale);
            if (!(rootFrame % 60))
            {
                _loc_2 = masterList;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_4 = _loc_2[_loc_3];
                    _loc_5 = _loc_4.length;
                    while (_loc_5-- > 0)
                    {
                        
                        if (_loc_4[_loc_5].gc)
                        {
                            _loc_4.splice(_loc_5, 1);
                        }
                    }
                    if (_loc_4.length == 0)
                    {
                        delete _loc_2[_loc_3];
                    }
                }
            }
            return;
        }// end function

        public static function to(onCompleteParams:Object, onCompleteParams:Number, onCompleteParams:Object) : TweenLite
        {
            return new TweenLite(onCompleteParams, onCompleteParams, onCompleteParams);
        }// end function

    }
}
