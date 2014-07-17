package com.anttikupila.revolt.presets
{
    import com.anttikupila.revolt.drawers.*;
    import com.anttikupila.revolt.effects.*;
    import com.anttikupila.revolt.scalers.*;

    public class LineSmooth extends LineNoFourier
    {

        public function LineSmooth()
        {
            drawers = new Array(new SmoothLine());
            scalers = new Array(new ZoomIn());
            effects = new Array(new Perlin(10, 2), new Blur(3, 3), new Tint(0, 0.05));
            return;
        }// end function

        override public function toString() : String
        {
            return "Smooth line without fourier transformation";
        }// end function

    }
}
