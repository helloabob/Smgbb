package com.anttikupila.revolt.drawers
{
    import com.anttikupila.revolt.effects.*;
    import flash.display.*;

    public class TunnelDrawer extends Drawer
    {
        private var blur:Blur;
        private var z:Number = 0;

        public function TunnelDrawer()
        {
            blur = new Blur(3, 3);
            return;
        }// end function

        override public function drawGFX(Math:BitmapData, Math:Array) : void
        {
            var _loc_4:Number = NaN;
            var _loc_3:uint = 0;
            while (_loc_3 < Math.length)
            {
                
                _loc_4 = Math[_loc_3];
                Math.setPixel(Math.sin(_loc_3 / (Math.length / 2) * Math.PI) * 40 * _loc_4 + Math.sin(z) * 40 + Math.width / 2, Math.cos(_loc_3 / (Math.length / 2) * Math.PI) * 40 * _loc_4 + Math.cos(z) * 40 + Math.height / 2, 39423 | _loc_4 * 360 << 8);
                if (_loc_4 > 0.5)
                {
                    Math.setPixel(Math.sin(_loc_3 / 256 * Math.PI) * 40 * _loc_4 + Math.sin(z) * 40 + Math.width / 2 + Math.random() * 10 - 5, Math.cos(_loc_3 / (Math.length / 2) * Math.PI) * 40 * _loc_4 + Math.cos(z) * 40 + Math.height / 2 + Math.random() * 10 - 5, 16777215);
                }
                _loc_3 = _loc_3 + 1;
            }
            z = z + 0.015;
            blur.applyFX(Math);
            return;
        }// end function

    }
}
