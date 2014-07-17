package com.smgbbv2
{
    import com.tvie.uisdk.*;
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.geom.*;

    public class SmgbbPlayPanelEx extends PlayPanelEx
    {
        private var _blogButton:SimpleButton;
        private var _fullscreen:SimpleButton;

        public function SmgbbPlayPanelEx(param1:Sprite = null)
        {
            super(param1);
            return;
        }// end function

        override protected function initUI() : void
        {
            _timeBarDelegate = new SmgbbTimeBarCtrlDelegate(sole.timeBar, sole.posTime, sole.duration);
            return;
        }// end function

        override protected function get sole() : Object
        {
            return component as SmgbbPlayPanel;
        }// end function

        override protected function hide(event:TVieEvent) : void
        {
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            UISDK.config.Rect.playerX = UISDK.config.Rect.x;
            UISDK.config.Rect.playerY = UISDK.config.Rect.y;
            UISDK.config.Rect.playerWidth = UISDK.config.Rect.width;
            UISDK.config.Rect.playerHeight = UISDK.config.Rect.height;
            var _loc_2:* = new Rectangle(UISDK.config.Rect.playerX, UISDK.config.Rect.playerY, UISDK.config.Rect.playerWidth, UISDK.config.Rect.playerHeight);
            HideShowDelegate.getInstance().setRectangle(_loc_2);
            sole.width = UISDK.config.Rect.playerWidth;
            sole.scaleY = sole.scaleX;
            sole.x = UISDK.config.Rect.playerX;
            sole.y = UISDK.config.Rect.playerHeight + UISDK.config.Rect.playerY - sole.height;
            UISDK.config.Rect.playX = sole.x;
            UISDK.config.Rect.playY = sole.y;
            UISDK.config.Rect.playWidth = sole.width;
            UISDK.config.Rect.playHeight = sole.height;
            return;
        }// end function

        override protected function show(event:TVieEvent) : void
        {
            return;
        }// end function

        override protected function initListeners() : void
        {
            return;
        }// end function

    }
}
