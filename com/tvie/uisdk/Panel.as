package com.tvie.uisdk
{
    import com.tvie.utilities.*;
    import com.tvie.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class Panel extends Sprite
    {
        protected var component:Sprite;
        static var isMouseOn:Boolean;

        public function Panel(param1:Sprite = null)
        {
            component = param1;
            addChild(component);
            HideShowDelegate.getInstance().subscribe(component, hide, show);
            UISDK.eDispather.addEventListener(UIEvent.UI_RESIZE, resize);
            UISDK.eDispather.addEventListener(UIEvent.UI_HIDE, hide);
            UISDK.eDispather.addEventListener(UIEvent.UI_SHOW, show);
            component.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
            component.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
            component.blendMode = BlendMode.LAYER;
            return;
        }// end function

        protected function hide(event:TVieEvent) : void
        {
            component.visible = false;
            return;
        }// end function

        protected function onMouseRollOver(event:MouseEvent) : void
        {
            isMouseOn = true;
            return;
        }// end function

        protected function onMouseRollOut(event:MouseEvent) : void
        {
            isMouseOn = false;
            return;
        }// end function

        protected function resize(event:TVieEvent) : void
        {
            trace("nothing to do, resize@Panel");
            return;
        }// end function

        protected function show(event:TVieEvent) : void
        {
            component.visible = true;
            return;
        }// end function

    }
}
