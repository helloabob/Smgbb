package com.anttikupila.revolt.presets
{
    import com.anttikupila.revolt.drawers.*;
    import com.anttikupila.revolt.effects.*;
    import com.anttikupila.revolt.scalers.*;

    public class LineWorm extends Preset
    {

        public function LineWorm()
        {
            fourier = true;
            drawers = new Array(new CenterLine());
            effects = new Array(new Perlin(8, 6), new Blur(2, 2), new Tint(0, 0.05));
            scalers = new Array(new ZoomIn(150));
            return;
        }// end function

        override public function toString() : String
        {
            return "Line worm";
        }// end function

    }
}
