package com.anttikupila.revolt.effects
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Perlin extends Effect
    {
        private var noiseMap:BitmapData;
        private var yVal:Number;
        private var xVal:Number;
        private var _displaceMode:String;
        private var noiseInt:Timer;
        private var perlinCount:uint = 5;
        private static var noiseMaps:Array;

        public function Perlin(param1:Number = 20, param2:Number = 20, param3:String = "clamp")
        {
            xVal = param1;
            yVal = param2;
            _displaceMode = param3;
            return;
        }// end function

        override public function applyFX(clamp:BitmapData) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:BitmapData = null;
            if (!noiseMaps)
            {
                noiseMaps = new Array();
                _loc_3 = 0;
                while (_loc_3 < perlinCount)
                {
                    
                    _loc_4 = new BitmapData(clamp.width, clamp.height, false, 8421504);
                    _loc_4.perlinNoise(100, 40, 3, Math.random() * 100, false, true, 1, true);
                    noiseMaps.push(_loc_4);
                    _loc_3 = _loc_3 + 1;
                }
                interval = 937;
            }
            var _loc_2:* = new DisplacementMapFilter(noiseMap, new Point(0, 0), 1, 2, xVal, yVal);
            _loc_2.mode = _displaceMode;
            clamp.applyFilter(clamp, new Rectangle(0, 0, clamp.width, clamp.height), new Point(0, 0), _loc_2);
            return;
        }// end function

        public function set interval(clamp:Number) : void
        {
            if (noiseInt)
            {
                noiseInt.stop();
            }
            noiseInt = new Timer(clamp, 0);
            noiseInt.addEventListener(TimerEvent.TIMER, remapNoise);
            noiseInt.start();
            remapNoise(null);
            return;
        }// end function

        private function remapNoise(event:TimerEvent) : void
        {
            var _loc_2:uint = 0;
            if (noiseMaps)
            {
                _loc_2 = Math.floor(Math.random() * perlinCount);
                noiseMap = noiseMaps[_loc_2];
            }
            return;
        }// end function

    }
}
