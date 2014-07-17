package com.tvie.model
{
    import com.tvie.*;
    import com.tvie.utilities.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class Model extends Object
    {
        protected var _player:Player;
        protected var _videodatarate:Number = 0;
        private var _state:String = "MODEL_STATE_IDLE";
        protected var _respond_time:Number = 0;
        private var _stateb4seek:String = null;
        protected var _src:String = null;
        protected var _sndctl:SoundTransform = null;
        protected var _lasterror:String = null;
        protected var _hasAudio:Boolean = true;
        protected var _height:int = 0;
        protected var _width:int = 0;
        protected var _framerate:Number = 0;
        protected var _nc:NetConnection;
        protected var _request_time:Number = 0;
        protected var _hasVideo:Boolean = true;
        protected var _audiodatarate:Number = 0;
        protected var _ns:NetStream = null;
        protected var _ismute:Boolean = false;
        protected var _client:Object;
        protected var _startpause:Boolean = false;
        protected var _duration:Number = 0;

        public function Model(param1:Player)
        {
            _player = param1;
            renew();
            return;
        }// end function

        protected function stop(COMMAND_PAUSE:Object) : void
        {
            if (_ns != null)
            {
                release();
            }
            state = PlayerStates.MODEL_STATE_IDLE;
            return;
        }// end function

        public function handleCommand(COMMAND_PAUSE:String, COMMAND_PAUSE:Object = ) : void
        {
            switch(COMMAND_PAUSE)
            {
                case PlayerCommands.COMMAND_PLAY:
                {
                    play(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_PAUSE:
                {
                    pause(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_RESUME:
                {
                    resume(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_SEEK:
                {
                    seek(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_SOUND_ON:
                {
                    soundOn(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_SOUND_OFF:
                {
                    soundOff(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_VOLUME:
                {
                    setVolume(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_STARTPAUSE:
                {
                    startPause = Boolean(COMMAND_PAUSE);
                    break;
                }
                case PlayerCommands.COMMAND_STOP:
                {
                    stop(COMMAND_PAUSE);
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function netStatusHandler(COMMAND_PAUSE:Object) : void
        {
            var _loc_2:Date = null;
            var _loc_3:Number = NaN;
            Logger.print("Receive Status:" + COMMAND_PAUSE.info.code);
            if (COMMAND_PAUSE.info.code == "NetStream.Play.Stop")
            {
                state = PlayerStates.MODEL_STATE_COMPLETED;
            }
            else if (COMMAND_PAUSE.info.code == "NetStream.Play.Start")
            {
                state = PlayerStates.MODEL_STATE_BUFFERING;
                if (_startpause)
                {
                    pause(null);
                }
            }
            else if (COMMAND_PAUSE.info.code == "NetStream.Buffer.Flush")
            {
            }
            else if (COMMAND_PAUSE.info.code == "NetStream.Buffer.Full")
            {
                if (_respond_time == 0)
                {
                    _loc_2 = new Date();
                    _respond_time = _loc_2.getTime() / 1000;
                }
                state = PlayerStates.MODEL_STATE_PLAYING;
            }
            else if (COMMAND_PAUSE.info.code == "NetStream.Play.StreamNotFound")
            {
                state = PlayerStates.MODEL_STATE_IDLE;
                lastError = PlayerErrors.STREAM_NOT_FOUND;
            }
            else if (COMMAND_PAUSE.info.code == "NetStream.Buffer.Empty")
            {
                state = PlayerStates.MODEL_STATE_BUFFERING;
            }
            else if (COMMAND_PAUSE.info.code == "NetStream.Seek.InvalidTime")
            {
                _loc_3 = COMMAND_PAUSE.info.details;
                _ns.seek(_loc_3);
            }
            else if (COMMAND_PAUSE.info.code == "NetStream.Seek.Notify")
            {
                state = _stateb4seek;
            }
            return;
        }// end function

        protected function renew() : void
        {
            if (_ns != null)
            {
                release();
            }
            _nc = new NetConnection();
            _nc.connect(null);
            _ns = new NetStream(_nc);
            _ns.checkPolicyFile = false;
            _ns.bufferTime = 3;
            _client = new Object();
            _client.onMetaData = onMetaData;
            _ns.client = _client;
            _ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _player.video.attachNetStream(_ns);
            if (_ismute)
            {
                soundOff(null);
            }
            else
            {
                soundOn(null);
            }
            return;
        }// end function

        public function get playPos() : Number
        {
            return _ns.time;
        }// end function

        public function get state() : String
        {
            return _state;
        }// end function

        public function get duration() : Number
        {
            return _duration;
        }// end function

        public function get lastError() : String
        {
            return _lasterror;
        }// end function

        public function get volume() : Number
        {
            return _ns.soundTransform.volume;
        }// end function

        public function release() : void
        {
            _ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _ns.close();
            _ns = null;
            return;
        }// end function

        public function set state(COMMAND_PAUSE:String) : void
        {
            if (_state != COMMAND_PAUSE)
            {
                _state = COMMAND_PAUSE;
                _player.dispatcher.dispatchEvent(new TVieEvent(PlayerEvents.STATE_CHANGE, _state));
            }
            return;
        }// end function

        public function get height() : int
        {
            return _height;
        }// end function

        public function get dataRate() : Number
        {
            return _videodatarate + _audiodatarate;
        }// end function

        public function set lastError(COMMAND_PAUSE:String) : void
        {
            _lasterror = COMMAND_PAUSE;
            _player.dispatcher.dispatchEvent(new TVieEvent(PlayerEvents.TVIE_ERROR, _lasterror));
            return;
        }// end function

        public function get bufferTime() : Number
        {
            return _ns.bufferTime;
        }// end function

        public function get startPause() : Boolean
        {
            return _startpause;
        }// end function

        protected function resume(COMMAND_PAUSE:Object) : void
        {
            if (state != PlayerStates.MODEL_STATE_IDLE && state != PlayerStates.MODEL_STATE_WAIT_STREAM && state != PlayerStates.MODEL_STATE_COMPLETED)
            {
                _ns.resume();
                state = PlayerStates.MODEL_STATE_PLAYING;
            }
            return;
        }// end function

        protected function setVolume(COMMAND_PAUSE:Object) : void
        {
            var _loc_2:* = Number(COMMAND_PAUSE);
            _sndctl = new SoundTransform();
            _sndctl.volume = _loc_2;
            _ns.soundTransform = _sndctl;
            return;
        }// end function

        protected function play(COMMAND_PAUSE:Object) : void
        {
            var _loc_2:Date = null;
            if (COMMAND_PAUSE != null)
            {
                _src = String(COMMAND_PAUSE);
                renew();
                Logger.print("Play URL " + _src);
                _loc_2 = new Date();
                _request_time = _loc_2.getTime() / 1000;
                _respond_time = 0;
                _ns.play(_src);
                state = PlayerStates.MODEL_STATE_WAIT_STREAM;
            }
            else
            {
                lastError = PlayerErrors.SRC_IS_VOID;
            }
            return;
        }// end function

        public function getProperty(COMMAND_SEEK:String) : Object
        {
            var _loc_2:Object = null;
            switch(COMMAND_SEEK)
            {
                case PlayerProperties.DURATION:
                {
                    _loc_2 = duration;
                    break;
                }
                case PlayerProperties.PLAYPOSTIME:
                {
                    _loc_2 = playPos;
                    break;
                }
                case PlayerProperties.LOADEDLENGTH:
                {
                    _loc_2 = loadedLength;
                    break;
                }
                case PlayerProperties.BUFFERLENGTH:
                {
                    _loc_2 = bufferLength;
                    break;
                }
                case PlayerProperties.BUFFERTIME:
                {
                    _loc_2 = bufferTime;
                    break;
                }
                case PlayerProperties.PLAYSTATE:
                {
                    _loc_2 = state;
                    break;
                }
                case PlayerProperties.DATARATE:
                {
                    _loc_2 = dataRate;
                    break;
                }
                case PlayerProperties.AUDIODATARATE:
                {
                    _loc_2 = _audiodatarate;
                    break;
                }
                case PlayerProperties.VIDEODATARATE:
                {
                    _loc_2 = _videodatarate;
                    break;
                }
                case PlayerProperties.HASVIDEO:
                {
                    _loc_2 = _hasVideo;
                    break;
                }
                case PlayerProperties.VOLUME:
                {
                    _loc_2 = volume;
                    break;
                }
                case PlayerProperties.LASTERROR:
                {
                    _loc_2 = lastError;
                    break;
                }
                case PlayerProperties.STARTPAUSE:
                {
                    _loc_2 = startPause;
                    break;
                }
                default:
                {
                    _loc_2 = null;
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function get width() : int
        {
            return _width;
        }// end function

        public function get loadedLength() : Number
        {
            return _ns.bytesLoaded / _ns.bytesTotal * _duration;
        }// end function

        public function get bufferLength() : Number
        {
            return _ns.bufferLength;
        }// end function

        protected function soundOn(COMMAND_PAUSE:Object) : void
        {
            if (_sndctl == null)
            {
                _sndctl = new SoundTransform();
            }
            _ns.soundTransform = _sndctl;
            _ismute = false;
            return;
        }// end function

        public function get framerate() : Number
        {
            return _framerate;
        }// end function

        protected function soundOff(COMMAND_PAUSE:Object) : void
        {
            var _loc_2:* = new SoundTransform();
            _loc_2.volume = 0;
            _ns.soundTransform = _loc_2;
            _ismute = true;
            return;
        }// end function

        public function set startPause(COMMAND_PAUSE:Boolean) : void
        {
            _startpause = COMMAND_PAUSE;
            return;
        }// end function

        public function get src() : Object
        {
            return _src;
        }// end function

        public function onMetaData(COMMAND_PAUSE:Object) : void
        {
            var _loc_2:String = null;
            if (COMMAND_PAUSE.duration != undefined)
            {
                _duration = Number(COMMAND_PAUSE.duration);
            }
            if (COMMAND_PAUSE.height != undefined)
            {
                _height = int(COMMAND_PAUSE.height);
            }
            if (COMMAND_PAUSE.width != undefined)
            {
                _width = int(COMMAND_PAUSE.width);
            }
            if (COMMAND_PAUSE.framerate != undefined)
            {
                _framerate = Number(COMMAND_PAUSE.framerate);
            }
            if (COMMAND_PAUSE.videodatarate != undefined)
            {
                _videodatarate = Number(COMMAND_PAUSE.videodatarate);
            }
            if (COMMAND_PAUSE.audiodatarate != undefined)
            {
                _audiodatarate = Number(COMMAND_PAUSE.audiodatarate);
            }
            if (COMMAND_PAUSE.hasVideo != undefined)
            {
                _hasVideo = Boolean(COMMAND_PAUSE.hasVideo);
            }
            if (COMMAND_PAUSE.hasAudio != undefined)
            {
                _hasAudio = Boolean(COMMAND_PAUSE.hasAudio);
            }
            Logger.print("Receive MetaData:");
            for (_loc_2 in COMMAND_PAUSE)
            {
                
                Logger.print(_loc_2 + " = " + COMMAND_PAUSE[_loc_2]);
            }
            _player.dispatcher.dispatchEvent(new TVieEvent(PlayerEvents.RECV_METADATA, COMMAND_PAUSE));
            return;
        }// end function

        protected function seek(COMMAND_PAUSE:Object) : void
        {
            var _loc_2:Number = NaN;
            if (state != PlayerStates.MODEL_STATE_IDLE && state != PlayerStates.MODEL_STATE_WAIT_STREAM && state != PlayerStates.MODEL_STATE_SEEKING)
            {
                _loc_2 = Number(COMMAND_PAUSE);
                _ns.seek(_loc_2);
                if (state == PlayerStates.MODEL_STATE_PAUSED)
                {
                    _stateb4seek = state;
                }
                else
                {
                    _stateb4seek = PlayerStates.MODEL_STATE_BUFFERING;
                }
                state = PlayerStates.MODEL_STATE_SEEKING;
            }
            return;
        }// end function

        protected function pause(COMMAND_PAUSE:Object) : void
        {
            if (state != PlayerStates.MODEL_STATE_IDLE && state != PlayerStates.MODEL_STATE_WAIT_STREAM && state != PlayerStates.MODEL_STATE_COMPLETED)
            {
                _ns.pause();
                state = PlayerStates.MODEL_STATE_PAUSED;
            }
            return;
        }// end function

    }
}
