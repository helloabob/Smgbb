package com.tvie.utilities
{
    import com.serialization.json.*;
    import com.tvie.model.*;
    import flash.events.*;

    public class CDNList extends Object
    {
        private var _drm:Boolean = false;
        private var _id:int;
        private var _CDNModel:CDNModel;
        private var _drlist:Array;
        private var _cdnlist:Array;
        private var _cursor:int = 0;
        private var _isready:Boolean = false;

        public function CDNList(param1:String, param2:int, param3:CDNModel)
        {
            _cdnlist = new Array();
            _drlist = new Array();
            _CDNModel = param3;
            _id = param2;
            Comm.sendreq(param1, completeHandler, errorHandler);
            return;
        }// end function

        public function set Cursor(errorHandler:int) : void
        {
            if (errorHandler > -1 && errorHandler < _cdnlist.length)
            {
                _cursor = errorHandler;
            }
            return;
        }// end function

        public function get Cursor() : int
        {
            return _cursor;
        }// end function

        public function get id() : int
        {
            return _id;
        }// end function

        private function errorHandler(event:Event) : void
        {
            Logger.print("Meeting an error while get CDN info");
            _isready = true;
            _CDNModel.onCDNReady(this);
            return;
        }// end function

        public function get cdnNodeList() : Array
        {
            return _cdnlist;
        }// end function

        public function get dataRateList() : Array
        {
            return _drlist;
        }// end function

        public function getCDNInfoByIdx(String:int) : CDNInfo
        {
            if (_cdnlist.length > 0 && String < _cdnlist.length && String > -1)
            {
                return _cdnlist[String];
            }
            return null;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var obj:Object;
            var datarates:Object;
            var servertime:Number;
            var client:Date;
            var tempres:Array;
            var DR:String;
            var dridx:int;
            var datarate:String;
            var dr:int;
            var tempsite:Array;
            var siteidx:int;
            var acdn:CDNInfo;
            var event:* = event;
            if (event.target.data != null)
            {
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
                    datarates;
                    if (obj.result != null)
                    {
                        if (obj.result.timestamp != undefined)
                        {
                            servertime = Number(obj.result.timestamp);
                            Logger.print("Server Time is " + servertime.toString());
                            client = new Date();
                            _CDNModel.serverClientTimeOffset = (servertime - client.getTime()) / 1000;
                        }
                        if (obj.result.DRM != undefined)
                        {
                            Logger.print("DRM is " + obj.result.DRM.toString());
                            if (obj.result.DRM.toString() == "true")
                            {
                                _drm = true;
                            }
                            else if (obj.result.DRM.toString() == "false")
                            {
                                _drm = false;
                            }
                        }
                        datarates = obj.result.datarates;
                    }
                    if (datarates != null)
                    {
                        tempres = new Array();
                        var _loc_3:int = 0;
                        var _loc_4:* = datarates;
                        while (_loc_4 in _loc_3)
                        {
                            
                            DR = _loc_4[_loc_3];
                            tempres.push(DR);
                        }
                        tempres.sort(Array.NUMERIC);
                        dridx;
                        while (dridx < tempres.length)
                        {
                            
                            datarate = tempres[dridx];
                            dr = parseInt(datarate);
                            tempsite = datarates[datarate];
                            _drlist.push(dr);
                            siteidx = (tempsite.length - 1);
                            while (siteidx >= 0)
                            {
                                
                                acdn = CDNInfo.createCDNInfo(dr, tempsite[siteidx], _drm);
                                _cdnlist.push(acdn);
                                siteidx = (siteidx - 1);
                            }
                            dridx = (dridx + 1);
                        }
                        _cursor = _cdnlist.length - 1;
                    }
                    Logger.print("Create Normal CDN Info");
                }
            }
            _isready = true;
            _CDNModel.onCDNReady(this);
            return;
        }// end function

        public function get isReady() : Boolean
        {
            return _isready;
        }// end function

        public function setCursorByDR(NUMERIC:Number) : Boolean
        {
            var _loc_2:int = 0;
            var _loc_3:CDNInfo = null;
            if (_cdnlist.length > 0)
            {
                _loc_2 = _cdnlist.length - 1;
                while (_loc_2 >= 0)
                {
                    
                    _loc_3 = _cdnlist[_loc_2];
                    if (_loc_3.dataRate == NUMERIC)
                    {
                        _cursor = _loc_2;
                        return true;
                    }
                    _loc_2 = _loc_2 - 1;
                }
            }
            _cursor = 0;
            return false;
        }// end function

    }
}
