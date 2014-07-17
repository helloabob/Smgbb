package com.anttikupila.revolt.drawers
{
    import flash.display.*;

    public class Line extends Drawer
    {
        private var lineSprite:Sprite;

        public function Line()
        {
            fourier = true;
            lineSprite = new Sprite();
            return;
        }// end function

        override public function drawGFX(moveTo:BitmapData, moveTo:Array) : void
        {
            var _loc_4:uint = 0;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            lineSprite.graphics.clear();
            lineSprite.graphics.moveTo(0, moveTo.height / 2);
            var _loc_3:uint = 0;
            while (_loc_3 < moveTo.length)
            {
                
                _loc_4 = _loc_3;
                if (_loc_3 >= moveTo.length / 2)
                {
                    _loc_4 = _loc_4 - moveTo.length / 2;
                }
                if (_loc_3 == moveTo.length / 2)
                {
                    lineSprite.graphics.moveTo(0, moveTo.height / 2);
                }
                lineSprite.graphics.lineStyle(1, 65535 * _loc_4);
                _loc_5 = _loc_4 / moveTo.length * (moveTo.width * 4 + 2);
                _loc_6 = (-moveTo[_loc_3]) * moveTo.height / 4;
                _loc_5 = _loc_5 - 2;
                if (_loc_3 >= moveTo.length / 2)
                {
                    _loc_6 = _loc_6 * -1;
                }
                lineSprite.graphics.lineTo(_loc_5, _loc_6 + moveTo.height / 2);
                _loc_3 = _loc_3 + 2;
            }
            lineSprite.graphics.endFill();
            moveTo.draw(lineSprite);
            return;
        }// end function

    }
}
