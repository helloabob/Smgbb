package com.tvie.model
{
    import com.serialization.json.*;
    import com.tvie.*;
    import com.tvie.utilities.*;
    import flash.events.*;
    import flash.net.*;

    public class CDNModel extends Model
    {
        protected var _src_drm:String;
        protected var _cdnpool:Array;
        protected var _server_client_time_offset:Number = 0;
        protected var _dataRatePool:Array;
        protected var _cdnformat:String;
        protected var _nominalDataRate:Number = 1;
        protected var _starttime:Number = 0;
        protected var _id:int = 0;

        public function CDNModel(param1:Player)
        {
            _cdnpool = new Array();
            _dataRatePool = new Array();
            super(param1);
            return;
        }// end function

        override public function handleCommand(para:String, para:Object = ) : void
        {
            switch(para)
            {
                case PlayerCommands.COMMAND_GETCDNINFO:
                {
                    getCDNInfo(para);
                    break;
                }
                case PlayerCommands.COMMAND_DATARATE:
                {
                    setDataRate(para);
                }
                default:
                {
                    super.handleCommand(para, para);
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function getProperty(setDataRate:String) : Object
        {
            var _loc_2:Object = null;
            switch(setDataRate)
            {
                case PlayerProperties.TIMEOFFSET:
                {
                    _loc_2 = _server_client_time_offset;
                    break;
                }
                case PlayerProperties.ID:
                {
                    _loc_2 = _id;
                    break;
                }
                case PlayerProperties.DATARATEPOOL:
                {
                    _loc_2 = _dataRatePool;
                    break;
                }
                default:
                {
                    _loc_2 = super.getProperty(setDataRate);
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

        protected function getCDNInfo(para:Object) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = int(para);
            if (_cdnpool[_loc_2] == undefined || _cdnpool[_loc_2] == null)
            {
                _loc_3 = _player.apisite + _cdnformat + _loc_2.toString();
                _cdnpool[_loc_2] = new CDNList(_loc_3, _loc_2, this);
            }
            return;
        }// end function

        override protected function renew() : void
        {
            super.renew();
            _ns.checkPolicyFile = true;
            return;
        }// end function

        protected function playwithCDN() : void
        {
            var _loc_1:* = _cdnpool[_id];
            switch(_nominalDataRate)
            {
                case 0:
                {
                    _nominalDataRate = _loc_1.dataRateList[(_loc_1.dataRateList.length - 1)];
                    break;
                }
                case 1:
                {
                    _nominalDataRate = _loc_1.dataRateList[0];
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            if (_loc_1.getCDNInfoByIdx(_loc_1.Cursor).dataRate != _nominalDataRate)
            {
                if (!_loc_1.setCursorByDR(_nominalDataRate))
                {
                    _nominalDataRate = _loc_1.getCDNInfoByIdx(_loc_1.Cursor).dataRate;
                }
            }
            var _loc_2:* = _loc_1.getCDNInfoByIdx(_loc_1.Cursor);
            if (_loc_2 != null)
            {
                if (_loc_2.DRM)
                {
                    playwithDRM(formatURL(_loc_2));
                }
                else
                {
                    super.play(formatURL(_loc_2));
                }
            }
            else
            {
                lastError = PlayerErrors.CDN_UNAVAILABLE;
            }
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var obj:Object;
            var errstr:String;
            var re:RegExp;
            var reg_field_ecode:int;
            var result:Object;
            var ecode:String;
            var event:* = event;
            if (event.target.data != null)
            {
                obj;
                try
                {
                    obj = JSON.deserialize(event.target.data);
                }
                catch (e:Error)
                {
                    Logger.print("Parse JSON String meeting an error");
                    obj;
                }
                if (obj != null)
                {
                    if (obj.result != undefined && obj.result == "ok")
                    {
                        super.play(_src_drm);
                    }
                    else if (obj.error != undefined)
                    {
                        errstr = obj.error;
                        re = /TVie_Exception: \[(\d+)\]: .*""TVie_Exception: \[(\d+)\]: .*/;
                        reg_field_ecode;
                        result = re.exec(errstr);
                        ecode = result[reg_field_ecode];
                        if (ecode == "403")
                        {
                            lastError = PlayerErrors.OUT_OF_REGION;
                        }
                        else
                        {
                            lastError = PlayerErrors.GET_OTP_FAIL;
                        }
                    }
                    else
                    {
                        lastError = PlayerErrors.GET_OTP_FAIL;
                    }
                }
                else
                {
                    lastError = PlayerErrors.GET_OTP_FAIL;
                }
            }
            else
            {
                lastError = PlayerErrors.GET_OTP_FAIL;
            }
            return;
        }// end function

        override public function netStatusHandler(para:Object) : void
        {
            var _loc_2:CDNList = null;
            var _loc_3:CDNInfo = null;
            var _loc_4:Number = NaN;
            var _loc_5:CDNList = null;
            if (para.info.code == "NetStream.Play.StreamNotFound")
            {
                _loc_2 = _cdnpool[_id];
                _loc_3 = _loc_2.getCDNInfoByIdx((_loc_2.Cursor - 1));
                if (_loc_3 != null)
                {
                    if (_nominalDataRate == 0 || _loc_3.dataRate == _nominalDataRate)
                    {
                        (_loc_2.Cursor - 1);
                        playwithCDN();
                    }
                    else
                    {
                        state = PlayerStates.MODEL_STATE_IDLE;
                        lastError = PlayerErrors.STREAM_NOT_FOUND;
                    }
                }
                else
                {
                    state = PlayerStates.MODEL_STATE_IDLE;
                    lastError = PlayerErrors.STREAM_NOT_FOUND;
                }
            }
            else
            {
                super.netStatusHandler(para);
                if (para.info.code == "NetStream.Buffer.Full")
                {
                    _loc_4 = _respond_time - _request_time;
                    _loc_5 = _cdnpool[_id];
                    _loc_5.getCDNInfoByIdx(_loc_5.Cursor).Delay = _loc_4;
                }
            }
            return;
        }// end function

        public function set serverClientTimeOffset(para:Number) : void
        {
            _server_client_time_offset = para;
            return;
        }// end function

        private function errorHandler(event:Event) : void
        {
            lastError = PlayerErrors.GET_OTP_FAIL;
            return;
        }// end function

        protected function CDNProbe() : void
        {
            var _loc_1:CDNList = null;
            var _loc_2:String = null;
            if (_cdnpool[_id] != undefined && _cdnpool[_id] != null)
            {
                _loc_1 = _cdnpool[_id];
                if (_loc_1.isReady)
                {
                    playwithCDN();
                }
            }
            else
            {
                _loc_2 = _player.apisite + _cdnformat + _id.toString();
                _cdnpool[_id] = new CDNList(_loc_2, _id, this);
            }
            return;
        }// end function

        public function setDataRate(para:Object) : void
        {
            var _loc_2:CDNList = null;
            if (_nominalDataRate != Number(para))
            {
                _nominalDataRate = Number(para);
                if (state != PlayerStates.MODEL_STATE_IDLE && state != PlayerStates.MODEL_STATE_COMPLETED)
                {
                    _loc_2 = _cdnpool[_id];
                    if (_loc_2.isReady)
                    {
                        if (state != PlayerStates.MODEL_STATE_WAIT_STREAM)
                        {
                            _starttime = Math.round(playPos);
                        }
                        playwithCDN();
                    }
                }
            }
            return;
        }// end function

        protected function playwithDRM(para:String) : void
        {
            _src_drm = para;
            var _loc_2:* = _player.apisite + "/api/createOTP";
            var _loc_3:* = new URLVariables();
            _loc_3.tvie = "tvie";
            Comm.sendreq(_loc_2, completeHandler, errorHandler, "POST", _loc_3);
            Logger.print("Getting OTP :" + _loc_2);
            return;
        }// end function

        public function onCDNReady(para:CDNList) : void
        {
            _dataRatePool[para.id] = para.dataRateList;
            if (para.cdnNodeList.length > 0)
            {
                _player.dispatcher.dispatchEvent(new TVieEvent(PlayerEvents.RECV_CDN_INFO, para.id));
                if (para.id == _id)
                {
                    playwithCDN();
                }
            }
            else
            {
                lastError = PlayerErrors.CDN_UNAVAILABLE;
            }
            return;
        }// end function

        protected function formatURL(getCDNInfo:CDNInfo) : String
        {
            return null;
        }// end function

    }
}
