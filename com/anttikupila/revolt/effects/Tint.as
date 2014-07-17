package com.anttikupila.revolt.effects
{
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;

    public class Tint extends Effect
    {
        private var colorMatrix:Array;
        private static var r_lum:Number = 0.212671;
        private static var b_lum:Number = 0.072169;
        private static var g_lum:Number = 0.71516;

        public function Tint(param1:Number, param2:Number)
        {
            var _loc_3:* = (param1 >> 16 & 255) / 255;
            var _loc_4:* = (param1 >> 8 & 255) / 255;
            var _loc_5:* = (param1 & 255) / 255;
            if (isNaN(param2))
            {
                param2 = 1;
            }
            var _loc_6:* = 1 - param2;
            colorMatrix = new Array(_loc_6 + param2 * _loc_3 * r_lum, param2 * _loc_3 * g_lum, param2 * _loc_3 * b_lum, 0, 0, param2 * _loc_4 * r_lum, _loc_6 + param2 * _loc_4 * g_lum, param2 * _loc_4 * b_lum, 0, 0, param2 * _loc_5 * r_lum, param2 * _loc_5 * g_lum, _loc_6 + param2 * _loc_5 * b_lum, 0, 0, 0, 0, 0, 1, 0);
            return;
        }// end function

        override public function applyFX(colorMatrix:BitmapData) : void
        {
            var _loc_2:* = new ColorMatrixFilter(colorMatrix);
            colorMatrix.applyFilter(colorMatrix, new Rectangle(0, 0, colorMatrix.width, colorMatrix.height), new Point(0, 0), _loc_2);
            return;
        }// end function

    }
}
