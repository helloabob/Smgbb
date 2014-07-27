package com.epg
{
    import com.tvie.uisdk.UIEvent;
    import com.tvie.utilities.TVieEvent;

    public class EPGDataCenter extends Object
    {
        private const DEFAULT:Number = -1;
        private var _channelEPGPool:Object;
        private var _cid:Number;
        private static var _singleton:EPGDataCenter = null;

        public function EPGDataCenter(param1:PrivateClass)
        {
            _channelEPGPool = new Object();
            _cid = UISDK.config.Params["id"];
            UISDK.eDispather.addEventListener(UIEvent.UI_TUNE_IN, onSetTuneInHandler);
            return;
        }// end function

        public function queryProgramByTime(param1:Number = -1, param2:Number = -1) : Object
        {
            var _loc_3:Program = null;
            var _loc_4:Object = null;
//            if (param1 == DEFAULT)
//            {
//                param2 = _cid;
//            }
//            if (param1 == DEFAULT)
//            {
//				param2 = com.tvie.utils.Comm.tvie_time();
//            }
//            if (_channelEPGPool[PrivateClass] == undefined)
//            {
//				com.tvie.utils.Comm.tvie_tracer("channel:" + param2 + " epg is no available, queryProgramByTime@EPGDataCenter");
//                return null;
//            }
//            if (PrivateClass < _channelEPGPool[PrivateClass].totalStartTime || PrivateClass > _channelEPGPool[PrivateClass].totalEndTime)
//            {
//				com.tvie.utils.Comm.tvie_tracer("time: " + param1 + "is no invalid, queryProgramByTime@EPGDataCenter");
//                return null;
//            }
            _loc_3 = _channelEPGPool[param1].getProgByTime(param2);
            _loc_4 = new Object();
            _loc_4.ProgramID = _loc_3.index;
            _loc_4.Title = _loc_3.name;
            _loc_4.StartTime = _loc_3.startTime * 1000;
            _loc_4.EndTime = _loc_3.endTime * 1000;
            _loc_4.TuneIn = _loc_3.tuneIn * 1000;
            _loc_4.Description = "NA";
            _loc_4.EventID = "NA";
            return _loc_4;
        }// end function

        private function onSetTuneInHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Number(event.Info);
            return;
        }// end function

        public function channelList() : Array
        {
            var _loc_2:String = null;
            var _loc_1:* = new Array();
            for (_loc_2 in _channelEPGPool)
            {
                
                _loc_1.push(_channelEPGPool[_loc_2].channel);
            }
            return _loc_1;
        }// end function

        public function get channelEPGPool() : Object
        {
            return _channelEPGPool;
        }// end function

        public function get curChannelEPG() : ChannelEPG
        {
            return _channelEPGPool[_cid] as ChannelEPG;
        }// end function

        public function set cid(eDispather:Number) : void
        {
            _cid = eDispather;
            return;
        }// end function

        public function get cid() : Number
        {
            return _cid;
        }// end function

        public static function getInstance() : EPGDataCenter
        {
            if (_singleton == null)
            {
                _singleton = new EPGDataCenter(new PrivateClass());
            }
            return _singleton;
        }// end function

    }
}
final class PrivateClass{}
