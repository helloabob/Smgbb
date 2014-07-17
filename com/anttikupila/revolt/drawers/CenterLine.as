package com.anttikupila.revolt.drawers
{
    import flash.display.*;
    import flash.geom.*;

    public class CenterLine extends Drawer
    {
        private var lineSprite:Sprite;
        private var z:Number = 0;
        private var yOffset:Number = 50;

        public function CenterLine()
        {
            fourier = true;
            lineSprite = new Sprite();
            return;
        }// end function

        override public function drawGFX(lineTo:BitmapData, lineTo:Array) : void
        {
            lineSprite.graphics.clear();
            lineSprite.graphics.moveTo(lineTo.width / 2, lineTo.height / 2 + yOffset);
            lineSprite.graphics.lineStyle(2, 10027008);
            lineSprite.graphics.lineTo(lineTo.width / 2 - lineTo[0] * lineTo.width / 4, lineTo.height / 2 + yOffset);
            lineSprite.graphics.moveTo(lineTo.width / 2, lineTo.height / 2 + yOffset);
            lineSprite.graphics.lineStyle(2, 39168);
            lineSprite.graphics.lineTo(lineTo.width / 2 + lineTo[lineTo.length / 2] * lineTo.width / 4, lineTo.height / 2 + yOffset);
            var _loc_3:* = Math.sin(z) * 20 / 180 * Math.PI;
            var _loc_4:* = new Matrix();
            _loc_4.rotate(_loc_3);
            _loc_4.translate(0, (-Math.sin(_loc_3 * 2)) * lineTo.height / 2 - Math.pow(Math.sin(z * 5), 2) * 10);
            lineTo.draw(lineSprite, _loc_4, null, "screen");
            z = z + 0.02;
            return;
        }// end function

    }
}
