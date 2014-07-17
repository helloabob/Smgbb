package com.epg
{
    import com.tvie.uisdk.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class ProgramBuilder extends Object
    {
        private var _scrollBar:MovieClip;
        private var _programArea:MovieClip;
        private var _itemArray:Array;
        private var _lastProgItem:ProgItem;
        private var _textFormat:TextFormat;
        private var _epgDate:MovieClip;
        private var _dayCount:int;
        private var _channelEPG:ChannelEPG;
        private var _programAreaHeight:Number;
        private var _days:Number;
        private var _programPanel:ProgramPanel;

        public function ProgramBuilder(_scrollBar:ProgramPanel) : void
        {
            _itemArray = new Array();
            _textFormat = new TextFormat();
            _days = UISDK.config.Params["days"];
            _dayCount = _days - 1;
            _programPanel = _scrollBar;
            _epgDate = _programPanel.epgDate;
            _epgDate.Right.addEventListener(MouseEvent.CLICK, onClickRightBtnHandler);
            _epgDate.Left.addEventListener(MouseEvent.CLICK, onClickLeftBtnHandler);
            showEPGDate(tvie_time() + UISDK.config.Params["timeOffset"]);
            _scrollBar = _programPanel.scrollBar;
            _scrollBar._scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragScrollBarHandler);
            _scrollBar._scrollButton.buttonMode = true;
            _programArea = _programPanel.programArea;
            _programArea.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverProgramAreaHandler);
            _programArea.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutProgramAreaHandler);
            _programAreaHeight = _programArea.height;
            return;
        }// end function

        private function onMouseOverProgramAreaHandler(event:MouseEvent) : void
        {
            _programArea.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
            return;
        }// end function

        private function getDayEPG(_scrollBar:Number) : void
        {
            buildDayEPG(_scrollBar);
            var _loc_2:* = tvie_time() - ((_days - 1) - _scrollBar) * 86400 + UISDK.config.Params["timeOffset"];
            showEPGDate(_loc_2);
            return;
        }// end function

        private function onClickLeftBtnHandler(event:MouseEvent) : void
        {
            if (_dayCount > 0)
            {
                (_dayCount - 1);
                getDayEPG(_dayCount);
                _scrollBar._scrollButton.y = 0;
            }
            return;
        }// end function

        private function onClickProgItemHandler(event:MouseEvent) : void
        {
            if (_lastProgItem != null)
            {
                _lastProgItem.tvlogo.visible = false;
            }
            var _loc_2:* = event.currentTarget as ProgItem;
            _loc_2.tvlogo.visible = true;
            _channelEPG.cursor = _loc_2.id;
            UISDK.eDispather.dispatchEvent(new TVieEvent(UIEvent.UI_SELECT_PLAY, null));
            _lastProgItem = _loc_2;
            return;
        }// end function

        private function onStopDragScrollBarHandler(event:MouseEvent) : void
        {
            _scrollBar._scrollButton.stopDrag();
            _programPanel.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragScrollBarHandler);
            _programPanel.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateProgListHandler);
            return;
        }// end function

        private function onStartDragScrollBarHandler(event:MouseEvent) : void
        {
            _scrollBar._scrollButton.startDrag(false, new Rectangle(0, 0, 0, _scrollBar.height - _scrollBar._scrollButton.height));
            _programPanel.stage.addEventListener(MouseEvent.MOUSE_UP, onStopDragScrollBarHandler);
            _programPanel.stage.addEventListener(MouseEvent.MOUSE_MOVE, onUpdateProgListHandler);
            return;
        }// end function

        private function onMouseOutProgitemHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as ProgItem;
            _loc_2.ProgBG.gotoAndStop(2);
            _textFormat.color = 16777215;
            _loc_2.ProgTime.setTextFormat(_textFormat);
            _loc_2.ProgName.setTextFormat(_textFormat);
            return;
        }// end function

        private function formatProgTime(livelogo:Number) : String
        {
            var _loc_2:* = new Date();
            _loc_2.setTime(livelogo * 1000);
            var _loc_3:* = _loc_2.getHours();
            var _loc_4:* = _loc_2.getMinutes();
            var _loc_5:String = "";
            _loc_5 = _loc_5 + (_loc_3 < 10 ? ("0" + _loc_3) : (_loc_3));
            _loc_5 = _loc_5 + ":";
            _loc_5 = _loc_5 + (_loc_4 < 10 ? ("0" + _loc_4) : (_loc_4));
            return _loc_5;
        }// end function

        private function onMouseOutProgramAreaHandler(event:MouseEvent) : void
        {
            _programArea.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
            return;
        }// end function

        private function showHideProgram(_scrollBar:ProgItem, _scrollBar:Number, _scrollBar:Number) : void
        {
            if (tvie_time() + UISDK.config.Params["timeOffset"] >= _scrollBar)
            {
                _textFormat.color = 16777215;
                _textFormat.font = "微软雅黑";
                _scrollBar.ProgTime.setTextFormat(_textFormat);
                _scrollBar.ProgName.setTextFormat(_textFormat);
                _scrollBar.addEventListener(MouseEvent.CLICK, onClickProgItemHandler);
                _scrollBar.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverProgItemHandler);
                _scrollBar.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutProgitemHandler);
                if (tvie_time() + UISDK.config.Params["timeOffset"] <= _scrollBar)
                {
                    _scrollBar.livelogo.visible = true;
                }
                if (_scrollBar.id == _channelEPG.cursor)
                {
                    _scrollBar.tvlogo.visible = true;
                    _lastProgItem = _scrollBar;
                }
            }
            else
            {
                _textFormat.color = 10066329;
                _scrollBar.ProgTime.setTextFormat(_textFormat);
                _scrollBar.ProgName.setTextFormat(_textFormat);
            }
            if (_scrollBar.y + _scrollBar.height > _programAreaHeight || _scrollBar.y < 0)
            {
                _scrollBar.visible = false;
            }
            return;
        }// end function

        private function onClickRightBtnHandler(event:MouseEvent) : void
        {
            if (_dayCount < _days)
            {
                (_dayCount + 1);
                getDayEPG(_dayCount);
                _scrollBar._scrollButton.y = 0;
            }
            return;
        }// end function

        private function onMouseOverProgItemHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as ProgItem;
            _loc_2.ProgBG.gotoAndStop(1);
            _textFormat.color = 0;
            _loc_2.ProgTime.setTextFormat(_textFormat);
            _loc_2.ProgName.setTextFormat(_textFormat);
            return;
        }// end function

        private function onMouseWheelHandler(event:MouseEvent) : void
        {
            if (event.delta > 0 && _scrollBar._scrollButton.y > 0)
            {
                _scrollBar._scrollButton.y = _scrollBar._scrollButton.y - 5;
            }
            else if (event.delta < 0 && _scrollBar._scrollButton.y < _scrollBar.height - _scrollBar._scrollButton.height)
            {
                _scrollBar._scrollButton.y = _scrollBar._scrollButton.y + 5;
            }
            onUpdateProgListHandler(null);
            return;
        }// end function

        private function buildDayEPG(_scrollBar:int) : void
        {
            var _loc_6:String = null;
            var _loc_7:Program = null;
            var _loc_8:ProgItem = null;
            var _loc_9:Number = NaN;
            var _loc_2:int = 0;
            while (_loc_2 < _itemArray.length)
            {
                
                _programArea.removeChild(_itemArray[_loc_2]);
                _loc_2++;
            }
            _itemArray.splice(0);
            var _loc_3:* = tvie_dayEndTime(tvie_time() + 24 * 60 * 60);
            var _loc_4:* = _loc_3 - ((_days + 1) - _scrollBar) * 24 * 60 * 60;
            var _loc_5:* = _loc_4 + 24 * 60 * 60;
            for (_loc_6 in _channelEPG.progArray)
            {
                
                _loc_7 = _channelEPG.progArray[_loc_6] as Program;
                if (_loc_7.startTime >= _loc_4 && _loc_7.startTime <= _loc_5)
                {
                    _loc_8 = new ProgItem();
                    _loc_9 = _itemArray.length;
                    _loc_8.ProgBG.gotoAndStop(2);
                    _loc_8.livelogo.visible = false;
                    _loc_8.tvlogo.visible = false;
                    _loc_8.buttonMode = true;
                    _loc_8.width = _programArea.width;
                    _loc_8.scaleY = _loc_8.scaleX;
                    _loc_8.x = 0;
                    _loc_8.y = _loc_8.height * _loc_9;
                    _loc_8.ProgTime.text = formatProgTime(_loc_7.startTime) + "-" + formatProgTime(_loc_7.endTime);
                    _loc_8.ProgName.text = _loc_7.name;
                    _loc_8.id = _loc_7.index;
                    _programArea.addChildAt(_loc_8, 0);
                    showHideProgram(_loc_8, _loc_7.startTime, _loc_7.endTime);
                    _itemArray.push(_loc_8);
                }
            }
            return;
        }// end function

        private function onUpdateProgListHandler(event:MouseEvent) : void
        {
            var _loc_2:* = _itemArray.length * (_itemArray[0] as ProgItem).height;
            var _loc_3:* = _programAreaHeight;
            var _loc_4:* = _scrollBar.height - _scrollBar._scrollButton.height;
            var _loc_5:int = 0;
            while (_loc_5 < _itemArray.length)
            {
                
                _itemArray[_loc_5].y = (_loc_3 - _loc_2) / _loc_4 * _scrollBar._scrollButton.y + _loc_5 * (_itemArray[0] as ProgItem).height;
                if (_itemArray[_loc_5].y < 0 || _itemArray[_loc_5].y + _itemArray[_loc_5].height - 10 >= _programAreaHeight)
                {
                    _itemArray[_loc_5].visible = false;
                }
                else
                {
                    _itemArray[_loc_5].visible = true;
                }
                _loc_5++;
            }
            return;
        }// end function

        private function showEPGDate(_scrollBar:Number) : void
        {
            var _loc_2:* = new Date();
            _loc_2.setTime(_scrollBar * 1000);
            var _loc_3:* = _loc_2.getDate();
            var _loc_4:* = _loc_2.getMonth() + 1;
            var _loc_5:* = _loc_2.getDay().toString();
            var _loc_6:* = _loc_2.getFullYear();
            switch(_loc_5)
            {
                case "0":
                {
                    _loc_5 = "星期日";
                    break;
                }
                case "1":
                {
                    _loc_5 = "星期一";
                    break;
                }
                case "2":
                {
                    _loc_5 = "星期二";
                    break;
                }
                case "3":
                {
                    _loc_5 = "星期三";
                    break;
                }
                case "4":
                {
                    _loc_5 = "星期四";
                    break;
                }
                case "5":
                {
                    _loc_5 = "星期五";
                    break;
                }
                case "6":
                {
                    _loc_5 = "星期六";
                    break;
                }
                default:
                {
                    break;
                }
            }
            _epgDate.progDate.text = _loc_6 + "年" + _loc_4 + "月" + _loc_3 + "日" + "  " + _loc_5;
            return;
        }// end function

        public function buildProgram(_scrollBar:ChannelEPG) : void
        {
            _channelEPG = _scrollBar;
            buildDayEPG(_dayCount);
            return;
        }// end function

    }
}
