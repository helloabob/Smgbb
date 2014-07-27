package com.tvie.uisdk
{
    import com.tvie.utils.Comm;

    public class Config extends Object
    {
        private var rect:Object;
        private var params:Object;

        public function Config(param:Object) : void
        {
            params = new Object();
            rect = {x:0, y:0, width:600, height:480, playerX:0, playerY:0, playerWidth:600, playerHeight:480, playX:0, playY:0, playWidth:600, playHeight:20};
            params["mode"] = "LIVE";
            params["site"] = "api.smgbb.tv";
            params["id"] = 210;
            params["datarate"] = 0;
            params["starttime"] = 1245305330;
//            params["endtime"] = tvie_time() + 5 * 60;
			params["endtime"] = 1245305330 + 5 * 60;
            params["autostart"] = false;
            params["days"] = 2;
            params["timeOffset"] = 0;
            extendObject(params, param);
            var _loc_2:* = /^http:\/\/""^http:\/\//;
            if (String(params["site"]).search(_loc_2) == -1)
            {
                params["site"] = "http://" + params["site"];
            }
            UISDK.JsMgr.addCallBack("exposeProperties", exposeProperties);
            return;
        }// end function

        public function cloneObject(param1:Object) : Object
        {
            var _loc_3:String = null;
            var _loc_2:* = new Object();
            for (_loc_3 in param1)
            {
                
                _loc_2[_loc_3] = param1[_loc_3];
            }
            return _loc_2;
        }// end function

        public function get Params() : Object
        {
            return params;
        }// end function

        public function copyRectInfo(playerWidth:Object, playerWidth, playerWidth) : void
        {
            playerWidth.x = playerWidth.x;
            playerWidth.y = playerWidth.y;
            playerWidth.width = playerWidth.width * playerWidth.scaleX;
            playerWidth.height = playerWidth.height * playerWidth.scaleY;
            return;
        }// end function

        public function traceParams(playerWidth:Object) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in playerWidth)
            {
                
                Comm.tvie_tracer(_loc_2 + ": " + playerWidth[_loc_2]);
            }
            return;
        }// end function

        public function equal(starttime:Object, starttime:Object) : Boolean
        {
            var _loc_3:Boolean = false;
            var _loc_4:String = null;
            if (starttime == null || starttime == null)
            {
                _loc_3 = false;
                return _loc_3;
            }
            for (_loc_4 in starttime)
            {
                
                if (starttime[_loc_4] == undefined)
                {
                    _loc_3 = false;
                    return _loc_3;
                }
                if (typeof(starttime[_loc_4]) == "object")
                {
                    if (typeof(starttime[_loc_4]) != "object")
                    {
                        _loc_3 = false;
                        return _loc_3;
                    }
                    _loc_3 = _loc_3 && equal(starttime[_loc_4], starttime[_loc_4]);
                    return _loc_3;
                    continue;
                }
                if (starttime[_loc_4] == starttime[_loc_4])
                {
                    _loc_3 = false;
                    return _loc_3;
                }
                _loc_3 = false;
                return _loc_3;
            }
            return _loc_3;
        }// end function

        public function exposeProperties() : void
        {
            var _loc_3:String = null;
            var _loc_4:Object = null;
            var _loc_1:* = new Array("ID", "DURATION", "PLAYPOSTIME", "LOADEDLENGTH", "BUFFERLENGTH", "BUFFERTIME", "PLAYSTATE", "DATARATE", "PROGSTART", "STARTPAUSE");
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                _loc_3 = _loc_1[_loc_2];
                _loc_4 = new Object();
                _loc_4.id = _loc_3.toLowerCase();
                _loc_4.content = (UISDK.getPanel(PlayerPanelEx) as PlayerPanelEx).player.getPlayerProperty(_loc_1[_loc_2]);
                UISDK.JsMgr.Call("tvie_fill_html", _loc_4);
                _loc_2++;
            }
            return;
        }// end function

        public function extendObject(param1:Object, param2:Object) : void
        {
			params = param1;
            var _loc_3:String = null;
            for (_loc_3 in param2)
            {
				params[_loc_3] = param2[_loc_3];
            }
            return;
        }// end function

        public function get Rect() : Object
        {
            return rect;
        }// end function

    }
}
