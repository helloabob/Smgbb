package com.anttikupila.revolt.drawers
{
    import flash.display.*;

    public class Drawer extends Object
    {
        private var _fourier:Boolean = true;

        public function Drawer()
        {
            return;
        }// end function

        public function get fourier() : Boolean
        {
            return _fourier;
        }// end function

        public function drawGFX(param1:BitmapData, param2:Array) : void
        {
            trace("drawGFX is not defined for " + this);
            return;
        }// end function

        public function set fourier(param1:Boolean) : void
        {
            _fourier = param1;
            return;
        }// end function

        public function init() : void
        {
            return;
        }// end function

    }
}
