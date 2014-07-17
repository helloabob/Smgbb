package com.tvie.uisdk
{
    import com.tvie.*;
    import com.tvie.utilities.*;
    import flash.display.*;

    public class BufferPanelEX extends Panel
    {

        public function BufferPanelEX(param1:Sprite = null)
        {
            super(param1);
            UISDK.eDispather.addEventListener(UIEvent.UI_PLAYER_STATE, onChangePlayerStateHander);
            sole.visible = false;
            return;
        }// end function

        override protected function hide(event:TVieEvent) : void
        {
            return;
        }// end function

        private function onChangePlayerStateHander(event:TVieEvent) : void
        {
            var _loc_2:* = String(event.Info);
            if (_loc_2 == PlayerStates.MODEL_STATE_BUFFERING || _loc_2 == PlayerStates.MODEL_STATE_WAIT_STREAM)
            {
                UISDK.eDispather.addEventListener(UIEvent.UI_BUFFER_PERCENT, onBuffPercentHandler);
                sole.bufferPer.text = "0" + " " + "%";
                sole.visible = true;
            }
            else
            {
                UISDK.eDispather.removeEventListener(UIEvent.UI_BUFFER_PERCENT, onBuffPercentHandler);
                sole.visible = false;
            }
            return;
        }// end function

        private function get sole() : BufferPanel
        {
            return component as BufferPanel;
        }// end function

        private function onBuffPercentHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Number(event.Info);
            if (_loc_2 < 100)
            {
                sole.bufferPer.text = _loc_2 + " " + "%";
            }
            else
            {
                sole.bufferPer.text = "Ready";
            }
            return;
        }// end function

        override protected function resize(event:TVieEvent) : void
        {
            var _loc_2:* = UISDK.config.Rect;
            sole.x = _loc_2.playerX + _loc_2.playerWidth / 2;
            sole.y = _loc_2.playerY + _loc_2.playerHeight / 2;
            return;
        }// end function

        override protected function show(event:TVieEvent) : void
        {
            return;
        }// end function

    }
}
