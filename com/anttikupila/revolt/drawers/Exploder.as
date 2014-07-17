package com.anttikupila.revolt.drawers
{
    import flash.display.*;

    public class Exploder extends Drawer
    {
        private var pos:Number = 0;
        private var lineSprite:Sprite;

        public function Exploder()
        {
            lineSprite = new Sprite();
            fourier = true;
            return;
        }// end function

        override public function drawGFX(moveTo:BitmapData, moveTo:Array) : void
        {
            var _loc_4:String = null;
            var _loc_5:Number = NaN;
            var _loc_6:uint = 0;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_3:* = moveTo.height * 0.75;
            lineSprite.graphics.clear();
            lineSprite.graphics.beginFill(15765504);
            lineSprite.graphics.moveTo((-Math.sin(0)) * 2 + moveTo.width / 2 + moveTo.width / 8 * Math.sin(pos), Math.cos(0) + moveTo.height * 0.65 + moveTo.height / 8 * Math.cos(pos / 2));
            for (_loc_4 in moveTo)
            {
                
                _loc_5 = moveTo[_loc_4];
                _loc_6 = uint(_loc_4);
                if (uint(_loc_4) < moveTo.length / 2)
                {
                    _loc_6 = _loc_6 + moveTo.length / 2;
                }
                _loc_7 = Math.ceil(_loc_3 / 2 * (_loc_5 + 0.5));
                _loc_8 = (-Math.sin(uint(_loc_4) / (moveTo.length / 2) * Math.PI)) * _loc_7 * _loc_5 * 3 + moveTo.width / 2 + moveTo.width / 8 * Math.sin(pos);
                _loc_9 = Math.cos(_loc_6 / (moveTo.length / 2) * Math.PI) * _loc_7 * _loc_5 / 2 + moveTo.height * 0.65 + moveTo.height / 8 * Math.cos(pos / 2);
                lineSprite.graphics.lineTo(_loc_8, _loc_9);
            }
            lineSprite.graphics.endFill();
            moveTo.draw(lineSprite, null, null, "screen", null, true);
            pos = pos + 0.01;
            return;
        }// end function

    }
}
