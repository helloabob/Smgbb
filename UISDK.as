package 
{
    import com.smgbb.SmgbbCommand;
    import com.smgbbv2.SmgbbLiveUICreator;
    import com.tvie.PlayerCommands;
    import com.tvie.PlayerProperties;
    import com.tvie.uisdk.Config;
    import com.tvie.uisdk.Creator;
    import com.tvie.uisdk.JSMgr;
    import com.tvie.uisdk.Panel;
    import com.tvie.uisdk.PlayerPanelEx;
    import com.tvie.uisdk.UIEvent;
    import com.tvie.uisdk.VODPlayerPanelEx;
    import com.tvie.utilities.TVieEvent;
    import com.tvie.utils.HideShowDelegate;
    import com.tvie.utils.externalCall;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.FullScreenEvent;
    import flash.system.Security;
	import com.tvie.utils.Comm;

    public class UISDK extends Sprite implements externalCall
    {
        private var uiCreator:Creator;
        private static var _config:Config;
        private static var _dispatcher:EventDispatcher;
        private static var _jsMgr:JSMgr;
        private static var _panelArr:Array = new Array();

        public function UISDK()
        {
            Security.allowDomain("*");
            start();
            return;
        }// end function

        public function removePanel(UI_NOTICE:Class) : void
        {
            var _loc_2:uint = 0;
            while (_loc_2 < _panelArr.length)
            {
                
                if (_panelArr[_loc_2] is UI_NOTICE)
                {
                    break;
                }
                _loc_2 = _loc_2 + 1;
            }
            removeChild(_panelArr[_loc_2]);
            _panelArr.splice(_loc_2, 1);
            return;
        }// end function

        public function start() : void
        {
            if (this.stage == null)
            {
                return;
            }
            _jsMgr = new JSMgr();
            _config = new Config(root.loaderInfo.parameters);
            _dispatcher = new EventDispatcher();
            addChild(HideShowDelegate.getInstance());
//            if (!checkH264Compatibility(9, 115))
//            {
//                addChild(new NoticePanelEx(new NoticePanel()));
//                tvie_tracer("falsh player version must be greate than or equal to 9.0.115.0");
//                eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_NOTICE, Lang.INVALID_VERSION));
//                eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
//                return;
//            }
            uiCreator = new SmgbbLiveUICreator();
            uiCreator.doStuff(_panelArr);
            mountPanels();
            config.Rect.x = 0;
            config.Rect.y = 0;
            config.Rect.width = stage.stageWidth;
            config.Rect.height = stage.stageHeight;
            setStageAlign();
            eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
            this.addEventListener(Event.REMOVED_FROM_STAGE, onRmFromStageHandler);
            if (String(config.Params["autostart"]) == "true")
            {
                run();
            }
            return;
        }// end function

        public function externalPlay(UI_NOTICE:uint, UI_NOTICE:Number, UI_NOTICE:Number, UI_NOTICE:Boolean) : void
        {
            if (config.Params["mode"] == "LIVE")
            {
                if (UI_NOTICE)
                {
                }
            }
            else if (config.Params["mode"] == "VOD")
            {
                (getPanel(VODPlayerPanelEx) as VODPlayerPanelEx).externalVODPlay(UI_NOTICE, 0);
            }
            return;
        }// end function

        private function mountPanels() : void
        {
			
            var _loc_1:uint = 0;
            while (_loc_1 < _panelArr.length)
            {
                
                addChild(_panelArr[_loc_1]);
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        private function setStageAlign() : void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(Event.RESIZE, stageResized);
            stage.addEventListener(Event.FULLSCREEN, onFullScreenHandler);
            return;
        }// end function

        public function externalLivePlay(UI_NOTICE:uint, UI_NOTICE:Number, UI_NOTICE:Number, UI_NOTICE:String = "TYPE_VOD") : void
        {
            trace("external function interface for live play");
            return;
        }// end function

        override public function set width(UI_NOTICE:Number) : void
        {
            config.Rect.width = UI_NOTICE;
            eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
            return;
        }// end function

        override public function set height(UI_NOTICE:Number) : void
        {
            config.Rect.height = UI_NOTICE;
            eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
            return;
        }// end function

        public function sendUICommand(dispatchEvent:String, func:* = null) : Number
        {
            var _loc_4:Function = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_3:Number = -1;
            switch(dispatchEvent)
            {
                case SmgbbCommand.UI_COMMAND_RESUME:
                {
                    eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PLAY, null));
                    break;
                }
                case SmgbbCommand.UI_COMMAND_PAUSE:
                {
                    eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_PAUSE, null));
                    break;
                }
                case SmgbbCommand.UI_COMMAND_SET_SOUND:
                {
                    _loc_5 = Number(func);
                    eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SET_VOLUME, _loc_5));
                    break;
                }
                case SmgbbCommand.UI_COMMAND_GET_SOUND:
                {
                    _loc_3 = Number((getPanel(PlayerPanelEx) as PlayerPanelEx).player.getPlayerProperty(PlayerProperties.VOLUME));
                    break;
                }
                case SmgbbCommand.UI_COMMAND_PLAY:
                {
                    _loc_6 = Number(func.cid);
                    _loc_7 = Number(func.timeStamp);
                    if (func.datarate == undefined)
                    {
                        _loc_8 = 0;
                    }
                    else
                    {
                        _loc_8 = Number(func.datarate);
                    }
                    (getPanel(PlayerPanelEx) as PlayerPanelEx).timeStampPlay(_loc_6, _loc_7, _loc_8);
                    break;
                }
                case SmgbbCommand.UI_COMMAND_GET_PLAYINGTIME:
                {
                    _loc_3 = Number((getPanel(PlayerPanelEx) as PlayerPanelEx).player.getPlayerProperty(PlayerProperties.PLAYPOSTIME));
                    break;
                }
                case SmgbbCommand.UI_COMMAND_REGISTER_PLAYER_STATE:
                {
                    _loc_4 = func;
                    eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, _loc_4);
                    break;
                }
                case SmgbbCommand.UI_COMMAND_UNREGISTER_PLAYER_STATE:
                {
                    _loc_4 = func;
                    eDispather.removeEventListener(UIEvent.UI_PLAYER_STATE, _loc_4);
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return _loc_3;
        }// end function

        private function onRmFromStageHandler(event:Event) : void
        {
            (getPanel(PlayerPanelEx) as PlayerPanelEx).player.sendPlayerCommand(PlayerCommands.COMMAND_STOP, null);
            return;
        }// end function

        private function stageResized(event:Event) : void
        {
            config.Rect.x = 0;
            config.Rect.y = 0;
            config.Rect.width = stage.stageWidth;
            config.Rect.height = stage.stageHeight;
            eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
            return;
        }// end function

        override public function set y(UI_NOTICE:Number) : void
        {
            config.Rect.y = UI_NOTICE;
            eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
            return;
        }// end function

        private function run() : void
        {
            var _loc_1:* = Number(config.Params["id"]);
            var _loc_2:* = Number(config.Params["starttime"]);
            var _loc_3:* = Number(config.Params["endtime"]);
            var _loc_4:* = Number(config.Params["datarate"]);
            if (config.Params["mode"] == "LIVE")
            {
                (getPanel(PlayerPanelEx) as PlayerPanelEx).timeStampPlay(_loc_1, _loc_2, _loc_4);
            }
            else if (config.Params["mode"] == "VOD")
            {
                (getPanel(VODPlayerPanelEx) as VODPlayerPanelEx).externalVODPlay(_loc_1, _loc_4);
            }
            return;
        }// end function

        override public function set x(UI_NOTICE:Number) : void
        {
            config.Rect.x = UI_NOTICE;
            eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_RESIZE, null));
            return;
        }// end function

        private function onFullScreenHandler(event:FullScreenEvent) : void
        {
            if (event.fullScreen)
            {
                eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_FULLSCREEN_STATE, true));
            }
            else
            {
                eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_FULLSCREEN_STATE, false));
            }
            return;
        }// end function

        public static function getPanel(EventDispatcher:Class) : Panel
        {
            var _loc_2:uint = 0;
            while (_loc_2 < _panelArr.length)
            {
                
                if (_panelArr[_loc_2] is EventDispatcher)
                {
                    return _panelArr[_loc_2];
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        public static function get JsMgr() : JSMgr
        {
            return _jsMgr;
        }// end function

        public static function get config() : Config
        {
            return _config;
        }// end function

        public static function get eDispather() : EventDispatcher
        {
            return _dispatcher;
        }// end function

    }
}
