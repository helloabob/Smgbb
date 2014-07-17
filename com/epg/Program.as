package com.epg
{

    dynamic public class Program extends Object
    {
        private var _encryptID:String;
        private var _endTime:Number;
        private var _startTime:Number;
        private var _index:Number;
        private var _tuneIn:Number = -1;
        private var _name:String;
        private var _cid:int;
        private static const DEFAULT:Number = -1;

        public function Program()
        {
            return;
        }// end function

        public function get encryptID() : String
        {
            return _encryptID;
        }// end function

        public function get endTime() : Number
        {
            return _endTime;
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public function get startTime() : Number
        {
            return _startTime;
        }// end function

        public function set endTime(_index:Number) : void
        {
            _endTime = _index;
            return;
        }// end function

        public function get index() : Number
        {
            return _index;
        }// end function

        public function get duration() : Number
        {
            if (_endTime - _startTime > 0)
            {
                return _endTime - _startTime;
            }
            return 0;
        }// end function

        public function set startTime(_index:Number) : void
        {
            _startTime = _index;
            return;
        }// end function

        public function set index(_index:Number) : void
        {
            _index = _index;
            return;
        }// end function

        public function set tuneIn(_index:Number) : void
        {
            if (_tuneIn == DEFAULT)
            {
                _tuneIn = _index;
            }
            return;
        }// end function

        public function get tuneIn() : Number
        {
            return _tuneIn;
        }// end function

        public function get cid() : int
        {
            return _cid;
        }// end function

        public static function pseudoProg(DEFAULT:Number, DEFAULT:Number, DEFAULT:int, DEFAULT:Number) : Program
        {
            var _loc_5:* = new Program;
            _loc_5._cid = DEFAULT;
            _loc_5._name = "精彩节目";
            _loc_5._index = DEFAULT;
            _loc_5._startTime = DEFAULT;
            _loc_5._endTime = DEFAULT;
            _loc_5._tuneIn = DEFAULT;
            _loc_5._encryptID = getEncryptId(DEFAULT, DEFAULT);
            return _loc_5;
        }// end function

        public static function normalProg(DEFAULT:String, DEFAULT:Number, DEFAULT:Number, DEFAULT:String, DEFAULT:int, DEFAULT:Number) : Program
        {
            var _loc_7:* = Program.pseudoProg(DEFAULT, DEFAULT, DEFAULT, DEFAULT);
            _loc_7._name = DEFAULT;
            _loc_7._encryptID = DEFAULT;
            return _loc_7;
        }// end function

        private static function getEncryptId(_name:Number, _name:Number) : String
        {
            return "";
        }// end function

    }
}
