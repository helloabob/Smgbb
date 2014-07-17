package com.anttikupila.revolt.presets
{
    import flash.display.*;

    public class Preset extends Object
    {
        private var _effects:Array;
        private var _drawers:Array;
        private var _scalers:Array;
        private var _fourier:Boolean = true;

        public function Preset()
        {
            _scalers = new Array();
            _effects = new Array();
            _drawers = new Array();
            return;
        }// end function

        public function set fourier(_effects:Boolean) : void
        {
            _fourier = _effects;
            return;
        }// end function

        public function set drawers(_effects:Array) : void
        {
            _drawers = _effects;
            return;
        }// end function

        public function applyGfx(_effects:BitmapData, _effects:Array) : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            for (_loc_3 in _scalers)
            {
                
                _scalers[_loc_3].applyScale(_effects);
            }
            for (_loc_4 in _effects)
            {
                
                _effects[_loc_4].applyFX(_effects);
            }
            for (_loc_5 in _drawers)
            {
                
                _drawers[_loc_5].drawGFX(_effects, _effects);
            }
            return;
        }// end function

        public function get fourier() : Boolean
        {
            return _fourier;
        }// end function

        public function set scalers(_effects:Array) : void
        {
            _scalers = _effects;
            return;
        }// end function

        public function init() : void
        {
            return;
        }// end function

        public function toString() : String
        {
            return "Abstract preset";
        }// end function

        public function set effects(_effects:Array) : void
        {
            _effects = _effects;
            return;
        }// end function

    }
}
