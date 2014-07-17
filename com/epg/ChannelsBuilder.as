package com.epg
{
    import com.tvie.uisdk.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class ChannelsBuilder extends Object
    {
        private var _lastChannelItem:MovieClip;
        private var _textFormat:TextFormat;
        private var _channelCount:int = 0;
        private var _upButton:SimpleButton;
        private var _channelArea:MovieClip;
        private var _downButton:SimpleButton;
        private var _channelArray:Array;
        private var _channelAreaHeight:Number;

        public function ChannelsBuilder(param1:ChannelPanel)
        {
            _channelArray = new Array();
            _textFormat = new TextFormat();
            _upButton = param1.upBtn;
            _upButton.addEventListener(MouseEvent.CLICK, onClickUpBtnHandler);
            _downButton = param1.downBtn;
            _downButton.addEventListener(MouseEvent.CLICK, onClickDownBtnHandler);
            _channelArea = param1.channelArea;
            _channelAreaHeight = _channelArea.height;
            return;
        }// end function

        private function showHideChannel(ChannelBG:ChannelItem) : void
        {
            if (ChannelBG.y + ChannelBG.height > _channelAreaHeight || ChannelBG.y < 0)
            {
                ChannelBG.visible = false;
            }
            else
            {
                ChannelBG.visible = true;
            }
            return;
        }// end function

        private function onMouseOverChannelHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as ChannelItem;
            _loc_2.ChannelBG.gotoAndStop(1);
            return;
        }// end function

        private function onMouseOutChannelHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as ChannelItem;
            _loc_2.ChannelBG.gotoAndStop(2);
            return;
        }// end function

        private function onClickUpBtnHandler(event:MouseEvent) : void
        {
            if (_channelCount > 0)
            {
                (_channelCount - 1);
            }
            var _loc_2:int = 0;
            while (_loc_2 < _channelArray.length)
            {
                
                _channelArray[_loc_2].y = _channelArray[_loc_2].height * (_loc_2 - _channelCount);
                showHideChannel(_channelArray[_loc_2]);
                _loc_2++;
            }
            return;
        }// end function

        private function onClickChannelHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as MovieClip;
            var _loc_3:* = tvie_time();
            var _loc_4:* = new Object();
            _textFormat.color = 16750848;
            _loc_2.ChannelName.setTextFormat(_textFormat);
            _loc_2.ChannelBG.gotoAndStop(2);
            _loc_2.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverChannelHandler);
            _loc_2.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutChannelHandler);
            _loc_2.removeEventListener(MouseEvent.CLICK, onClickChannelHandler);
            _textFormat.color = 16777215;
            _lastChannelItem.ChannelName.setTextFormat(_textFormat);
            _lastChannelItem.ChannelBG.gotoAndStop(2);
            _lastChannelItem.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverChannelHandler);
            _lastChannelItem.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutChannelHandler);
            _lastChannelItem.addEventListener(MouseEvent.CLICK, onClickChannelHandler);
            _lastChannelItem = _loc_2;
            _loc_4.cid = _loc_2.id;
            _loc_4.time = _loc_3;
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_CHANNEL_CHANGE, _loc_4));
            return;
        }// end function

        private function onClickDownBtnHandler(event:MouseEvent) : void
        {
            if (_channelCount < _channelArray.length - _channelAreaHeight / _channelArray[0].height)
            {
                (_channelCount + 1);
            }
            var _loc_2:int = 0;
            while (_loc_2 < _channelArray.length)
            {
                
                _channelArray[_loc_2].y = _channelArray[_loc_2].height * (_loc_2 - _channelCount);
                showHideChannel(_channelArray[_loc_2]);
                _loc_2++;
            }
            return;
        }// end function

        public function buildChannels(ChannelBG:Object) : void
        {
            var _loc_2:Channel = null;
            var _loc_3:String = null;
            var _loc_4:ChannelItem = null;
            for (_loc_3 in ChannelBG)
            {
                
                _loc_4 = new ChannelItem();
                _loc_2 = (ChannelBG[_loc_3] as ChannelEPG).channel;
                _loc_4.buttonMode = true;
                _loc_4.id = _loc_2.cid;
                _textFormat.color = 16777215;
                _loc_4.ChannelName.text = _loc_2.name;
                _loc_4.ChannelName.setTextFormat(_textFormat);
                _loc_4.width = _channelArea.width;
                _loc_4.scaleY = _loc_4.scaleX;
                _loc_4.y = _channelArray.length * _loc_4.height;
                _loc_4.x = 0;
                _loc_4.ChannelBG.gotoAndStop(2);
                if (_loc_4.id != UISDK.config.Params["id"])
                {
                    _loc_4.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverChannelHandler);
                    _loc_4.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutChannelHandler);
                    _loc_4.addEventListener(MouseEvent.CLICK, onClickChannelHandler);
                }
                else
                {
                    _textFormat.color = 16750848;
                    _loc_4.ChannelName.setTextFormat(_textFormat);
                    _lastChannelItem = _loc_4;
                }
                _channelArea.addChild(_loc_4);
                showHideChannel(_loc_4);
                _channelArray.push(_loc_4);
            }
            return;
        }// end function

    }
}
