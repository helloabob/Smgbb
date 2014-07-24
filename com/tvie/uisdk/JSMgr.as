package com.tvie.uisdk
{
    import flash.external.*;

    public class JSMgr extends Object
    {

        public function JSMgr()
        {
            return;
        }// end function

        public function Call(addCallback:String, addCallback) : void
        {
            var fnName:* = addCallback;
            var data:* = addCallback;
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call(fnName, data);
                }
            }
            catch (e:Error)
            {
                trace("call JS function failed, Call@JSMgr");
            }
            return;
        }// end function

        public function addCallBack(addCallback:String, func:Function) : void
        {
            var fnName:* = addCallback;
            var fn:* = func;
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.addCallback(fnName, fn);
                }
            }
            catch (e:Error)
            {
                trace("add callback function failed, addCallBack@JSMgr");
            }
            return;
        }// end function

    }
}
