package 
{
    import flash.display.*;

    dynamic public class Loading extends MovieClip
    {
        public var closeLoading:SimpleButton;
        public var bg:MovieClip;
        public var cycle2_stage:MovieClip;

        public function Loading()
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
