package com.tvie.utilities
{
    import flash.events.*;

    public class TVieEvent extends Event
    {
        private var _info:Object;

        public function TVieEvent(param1:String, param2:Object = null)
        {
            super(param1);
            _info = param2;
            return;
        }// end function

        public function get Info() : Object
        {
            return _info;
        }// end function

    }
}
