package 
{
    import Player.*;
    import com.tvie.*;
    import com.tvie.model.*;
    import com.tvie.utilities.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.system.*;

    public class Player extends Sprite
    {
        private var _dispatcher:EventDispatcher;
        private var _model:Model;
        private var _api_site:String;
        private var _video:Video;

        public function Player(param1:Object = null)
        {
            Security.allowDomain("*");
            _dispatcher = new EventDispatcher();
            _model = null;
            _video = new Video(640, 480);
            _video.smoothing = true;
            addChild(_video);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            parseInitInfo(param1);
            return;
        }// end function

        public function get apisite() : String
        {
            return _api_site;
        }// end function

        public function sendPlayerCommand(parseInitInfo:String, parseInitInfo:Object = ) : void
        {
            switch(parseInitInfo)
            {
                case PlayerCommands.COMMAND_CHANGE_MODE:
                {
                    changeMode(parseInitInfo);
                    break;
                }
                case PlayerCommands.COMMAND_CHANGE_APISITE:
                {
                    _api_site = String(parseInitInfo);
                    break;
                }
                default:
                {
                    _model.handleCommand(parseInitInfo, parseInitInfo);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function onEnterFrame(event:Event) : void
        {
            _dispatcher.dispatchEvent(new TVieEvent(PlayerEvents.CORE_BEAT, null));
            return;
        }// end function

        public function addPlayerEventListener(parseInitInfo:String, parseInitInfo:Function) : void
        {
            _dispatcher.addEventListener(parseInitInfo, parseInitInfo);
            return;
        }// end function

        public function get dispatcher() : EventDispatcher
        {
            return _dispatcher;
        }// end function

        public function removePlayerEventListener(parseInitInfo:String, parseInitInfo:Function) : void
        {
            _dispatcher.removeEventListener(parseInitInfo, parseInitInfo);
            return;
        }// end function

        public function getPlayerProperty(flash.media:String) : Object
        {
            return _model.getProperty(flash.media);
        }// end function

        private function parseInitInfo(parseInitInfo:Object) : void
        {
            var _loc_2:String = null;
            if (parseInitInfo != null)
            {
                if (parseInitInfo.mode != undefined)
                {
                    _loc_2 = String(parseInitInfo.mode);
                }
                if (parseInitInfo.site != undefined)
                {
                    _api_site = String(parseInitInfo.site);
                }
            }
            changeMode(_loc_2);
            return;
        }// end function

        private function changeMode(parseInitInfo:Object) : void
        {
            var _loc_3:Class = null;
            var _loc_2:* = String(parseInitInfo);
            switch(_loc_2)
            {
                case "BASE":
                {
                    _loc_3 = Model;
                    break;
                }
                case "LIVE":
                {
                    _loc_3 = LiveModel;
                    break;
                }
                case "LIVEP":
                {
                    _loc_3 = LivePlusModel;
                    break;
                }
                case "VOD":
                {
                    _loc_3 = VODModel;
                    break;
                }
                case "P2P":
                {
                    _loc_3 = P2PModel;
                    break;
                }
                default:
                {
                    _loc_3 = Model;
                    break;
                    break;
                }
            }
            if (_model == null)
            {
                _model = new _loc_3(this);
            }
            else if (!(_model is _loc_3))
            {
                _model.release();
                _model = new _loc_3(this);
            }
            return;
        }// end function

        public function get video() : Video
        {
            return _video;
        }// end function

    }
}
