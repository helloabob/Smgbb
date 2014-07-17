package com.tvie.uisdk
{
    import com.tvie.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class NoticePanelEx extends Panel
    {
        private const INFO:String = "INFO";
        private const NOTICE:String = "NOTICE";
        private var _type:String = "INFO";

        public function NoticePanelEx(param1:Sprite = null)
        {
            super(param1);
            sole.visible = false;
            HideShowDelegate.getInstance().unSubscribe(sole);
            UISDK.eDispather.addEventListener(UIEvent.UI_SHOW_NOTICE, show);
            UISDK.eDispather.addEventListener(UIEvent.UI_HIDE_NOTICE, hide);
            UISDK.eDispather.addEventListener(UIEvent.UI_INFO, onInfoHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_NOTICE, onNoticeHandler);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, onChangePlayerStateHandler);
            sole.closeNotice.addEventListener(MouseEvent.CLICK, onClickCloseBtnHandler);
            return;
        }// end function

        override protected function hide(event:TVieEvent) : void
        {
            sole.visible = false;
            return;
        }// end function

        private function onInfoHandler(event:TVieEvent) : void
        {
            var _loc_2:* = String(event.Info);
            _type = INFO;
            sole.closeNotice.visible = false;
            sole.noticeContent.height = sole.height - 20;
            sole.noticeContent.htmlText = _loc_2;
            return;
        }// end function

        private function onChangePlayerStateHandler(event:TVieEvent) : void
        {
            var _loc_2:* = String(event.Info);
            if (_loc_2 == PlayerStates.MODEL_STATE_PLAYING)
            {
                if (_type == INFO)
                {
                    hide(null);
                }
            }
            return;
        }// end function

        override protected function onMouseRollOut(event:MouseEvent) : void
        {
            isMouseOn = false;
            return;
        }// end function

        private function onClickCloseBtnHandler(event:MouseEvent) : void
        {
            sole.visible = false;
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            var _loc_2:* = UISDK.config.Rect;
            sole.x = _loc_2.playerX + _loc_2.playerWidth / 2;
            sole.y = _loc_2.playerY + _loc_2.playerHeight / 2;
            return;
        }// end function

        private function get sole() : NoticePanel
        {
            return component as NoticePanel;
        }// end function

        override protected function onMouseRollOver(event:MouseEvent) : void
        {
            isMouseOn = false;
            return;
        }// end function

        private function onNoticeHandler(event:TVieEvent) : void
        {
            var _loc_2:* = String(event.Info);
            _type = NOTICE;
            sole.closeNotice.visible = true;
            sole.noticeContent.height = sole.height - 30;
            sole.noticeContent.htmlText = _loc_2;
            return;
        }// end function

        override protected function show(event:TVieEvent) : void
        {
            sole.visible = true;
            return;
        }// end function

    }
}
