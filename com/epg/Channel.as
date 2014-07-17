package com.epg
{

    public class Channel extends Object
    {
        private var channelName:String;
        private var channelID:uint;

        public function Channel(D:\ASS\uisdk_refactor1;com\epg;Channel.as:uint, D:\ASS\uisdk_refactor1;com\epg;Channel.as:String) : void
        {
            channelID = D:\ASS\uisdk_refactor1;com\epg;Channel.as;
            channelName = D:\ASS\uisdk_refactor1;com\epg;Channel.as;
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
