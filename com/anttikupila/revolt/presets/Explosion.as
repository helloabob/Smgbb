package com.anttikupila.revolt.presets
{
    import com.anttikupila.revolt.drawers.*;
    import com.anttikupila.revolt.effects.*;
    import com.anttikupila.revolt.scalers.*;

    public class Explosion extends Preset
    {

        public function Explosion()
        {
            fourier = true;
            drawers = new Array(new Exploder());
            effects = new Array(new Blur(3, 3), new Perlin(5, 3), new Blur(10, 6), new Tint(16711680, 0.1));
            scalers = new Array(new ZoomIn());
            return;
        }// end function

        override public function toString() : String
        {
            return "Circular explosion";
        }// end function

    }
}
