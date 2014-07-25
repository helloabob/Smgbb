package com.tvie.uisdk
{
    import com.tvie.utils.Comm;

    public class Creator extends Object
    {

        public function Creator()
        {
            return;
        }// end function

        public function doStuff(panelArray:Array) : void
        {
            var _loc_2:IUIProduct = this.factoryMethod();
            _loc_2.manipulate(panelArray);
            return;
        }// end function

        public function factoryMethod() : IUIProduct
        {
            Comm.tvie_tracer("nothing to do here factoryMethod@Creator");
            return null;
        }// end function

    }
}
