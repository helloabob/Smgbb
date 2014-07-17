package com.anttikupila.revolt.presets
{

    public class LineNoFourier extends LineFourier
    {

        public function LineNoFourier()
        {
            fourier = false;
            return;
        }// end function

        override public function toString() : String
        {
            return "Line without fourier transformation";
        }// end function

    }
}
