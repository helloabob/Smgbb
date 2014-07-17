package com.smgbbv2
{
    import com.tvie.uisdk.*;

    public class SmgbbLiveUICreator extends Creator
    {

        public function SmgbbLiveUICreator()
        {
            return;
        }// end function

        override public function factoryMethod() : IUIProduct
        {
            return new SmgbbLiveUI();
        }// end function

    }
}
