package com.anttikupila.soundSpectrum
{
    import flash.media.*;
    import flash.utils.*;

    public class SoundProcessor extends Object
    {
        public const BOTH:String = "both";
        public const LEFT:String = "left";
        private var _sound:Sound;
        public const RIGHT:String = "right";
        private var ba:ByteArray;

        public function SoundProcessor()
        {
            ba = new ByteArray();
            _sound = new Sound(null, new SoundLoaderContext());
            return;
        }// end function

        public function getLeftChannel(param:Boolean) : Array
        {
            SoundMixer.computeSpectrum(ba, param, 0);
            return getSection(ba, 256);
        }// end function

        public function getSoundSpectrum(param:Boolean) : Array
        {
            SoundMixer.computeSpectrum(ba, param, 0);
            return getSection(ba, 512);
        }// end function

        private function getSection(param1:ByteArray, param2:uint = 512) : Array
        {
            var _loc_3:* = new Array();
            var _loc_4:uint = 0;
            while (_loc_4 < param2)
            {
                
                _loc_3.push(param1.readFloat());
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        public function getVolume(fourier:String = "both") : Number
        {
            var _loc_4:String = null;
            SoundMixer.computeSpectrum(ba, false, 0);
            var _loc_2:* = new Array();
            switch(fourier)
            {
                case LEFT:
                {
                    _loc_2 = getLeftChannel(true);
                    break;
                }
                case RIGHT:
                {
                    _loc_2 = getRightChannel(true);
                    break;
                }
                case BOTH:
                {
                }
                default:
                {
                    _loc_2 = getSoundSpectrum(true);
                    break;
                    break;
                }
            }
            var _loc_3:Number = 0;
            for (_loc_4 in _loc_2)
            {
                
                _loc_3 = _loc_3 + _loc_2[_loc_4];
            }
            _loc_3 = _loc_3 / Number(_loc_4);
            return _loc_3 * 100;
        }// end function

        public function getRightChannel(param:Boolean) : Array
        {
            SoundMixer.computeSpectrum(ba, param, 0);
            ba.position = 1024;
            return getSection(ba, 256);
        }// end function

    }
}
