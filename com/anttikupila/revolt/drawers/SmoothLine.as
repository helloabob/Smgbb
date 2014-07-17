package com.anttikupila.revolt.drawers
{
    import flash.display.*;

    public class SmoothLine extends Line
    {
        private var lineSprite:Sprite;
        private var z:Number = 0;

        public function SmoothLine()
        {
            lineSprite = new Sprite();
            return;
        }// end function

        override public function init() : void
        {
            fourier = Math.round(Math.random() * 2) == 1 ? (true) : (false);
            return;
        }// end function

        override public function drawGFX(moveTo:BitmapData, moveTo:Array) : void
        {
            var _loc_5:uint = 0;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_3:* = moveTo.length;
            lineSprite.graphics.clear();
            lineSprite.graphics.moveTo(-2, moveTo.height / 2);
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = _loc_4;
                _loc_6 = 12292137;
                if (_loc_4 >= _loc_3 / 2)
                {
                    _loc_5 = _loc_5 - _loc_3 / 2;
                    _loc_6 = 16777215;
                }
                lineSprite.graphics.lineStyle(1, _loc_6);
                _loc_7 = _loc_5 / (_loc_3 / 2) * (moveTo.width + 10);
                _loc_8 = (-moveTo[_loc_4]) * moveTo.height / 4 + Math.cos(z) * (moveTo.height / 8);
                if (_loc_4 >= _loc_3 / 2)
                {
                    _loc_8 = _loc_8 * -1;
                }
                if (_loc_4 == _loc_3 / 2)
                {
                    lineSprite.graphics.moveTo(0, _loc_8 + moveTo.height / 2);
                }
                lineSprite.graphics.lineTo(_loc_7, _loc_8 + moveTo.height / 2);
                _loc_4 = _loc_4 + 4;
            }
            moveTo.draw(lineSprite, null, null, "add");
            z = z + 0.01;
            return;
        }// end function

    }
}
