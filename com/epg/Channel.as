package com.epg
{

    public class Channel extends Object
    {
        private var channelName:String;
        private var channelID:uint;

        public function Channel(param1:uint, param2:String) : void
        {
            channelID = param1;
            channelName = param2;
            return;
        }// end function

        public function get name() : String
        {
            return channelName;
        }// end function

        public function get cid() : uint
        {
            return channelID;
        }// end function

    }
}
