package com.anttikupila.revolt.scalers
{
    import flash.display.*;
    import flash.geom.*;

    public class ZoomIn extends Scale
    {
        private var _speed:Number;
        private var gfx2:BitmapData;

        public function ZoomIn(param1:Number = 100)
        {
            _speed = param1;
            return;
        }// end function

        override public function applyScale(offset:BitmapData) : void
        {
            if (!gfx2)
            {
                gfx2 = offset.clone();
            }
            var _loc_2:* = new Matrix();
            var _loc_3:* = 1 + 0.05 * _speed / 100;
            _loc_2.scale(_loc_3, _loc_3);
            var _loc_4:* = (-(_loc_3 - 1)) / 2;
            _loc_2.translate(_loc_4 * offset.width, _loc_4 * offset.height);
            gfx2.draw(offset, _loc_2);
            offset.draw(gfx2);
            return;
        }// end function

    }
}
