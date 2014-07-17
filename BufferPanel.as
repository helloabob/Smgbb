package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class BufferPanel extends MovieClip
    {
        public var bufferPer:TextField;

        public function BufferPanel()
        {
            addFrameScript(24, this.frame25);
            return;
        }// end function

        function frame25()
        {
            gotoAndPlay("loop");
            return;
        }// end function

    }
}
