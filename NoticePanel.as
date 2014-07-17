package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    dynamic public class NoticePanel extends MovieClip
    {
        public var closeNotice:SimpleButton;
        public var noticeContent:TextField;

        public function NoticePanel()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            stop();
            this.closeNotice.addEventListener(MouseEvent.CLICK, this.onClickHandler);
            return;
        }// end function

        public function onClickHandler(event:MouseEvent)
        {
            this.visible = false;
            return;
        }// end function

    }
}
