package com.anttikupila.revolt.effects
{
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;

    public class Blur extends Effect
    {
        private var blurX:Number;
        private var blurQuality:Number;
        private var blurY:Number;

        public function Blur(param1:Number = 2, param2:Number = 2, param3:Number = 1)
        {
            blurX = param1;
            blurY = param2;
            blurQuality = param3;
            return;
        }// end function

        override public function applyFX(Number:BitmapData) : void
        {
            var _loc_2:* = new BlurFilter(blurX, blurY, blurQuality);
            Number.applyFilter(Number, new Rectangle(0, 0, Number.width, Number.height), new Point(0, 0), _loc_2);
            return;
        }// end function

    }
}
