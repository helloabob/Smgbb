package com.anttikupila.revolt.presets
{
    import com.anttikupila.revolt.drawers.*;
    import com.anttikupila.revolt.effects.*;
    import com.anttikupila.revolt.scalers.*;

    public class Tunnel extends Preset
    {

        public function Tunnel()
        {
            drawers = new Array(new TunnelDrawer());
            scalers = new Array(new ZoomIn());
            var _loc_1:* = new Perlin(10, 10);
            _loc_1.interval = 3748;
            effects = new Array(_loc_1);
            return;
        }// end function

        override public function toString() : String
        {
            return "Smooth line without fourier transformation";
        }// end function

    }
}
