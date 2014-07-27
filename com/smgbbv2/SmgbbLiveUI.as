package com.smgbbv2
{
    import com.tvie.uisdk.BigButtonEx;
    import com.tvie.uisdk.BufferPanelEX;
    import com.tvie.uisdk.IUIProduct;

    public class SmgbbLiveUI extends Object implements IUIProduct
    {

        public function SmgbbLiveUI()
        {
            return;
        }// end function

        public function manipulate(EPGPanel:Array) : void
        {
            EPGPanel.push(new SmgbbPlayPanelEx(new SmgbbPlayPanel()));
            EPGPanel.push(new SmgbbPlayerPanelEx(new Player(UISDK.config.Params)));
//            EPGPanel.push(new SmgbbEPGPanelEx(new EPGPanel()));
            EPGPanel.push(new BigButtonEx(new BigButton()));
//            EPGPanel.push(new NoticePanelEx(new NoticePanel()));
            EPGPanel.push(new BufferPanelEX(new BufferPanel()));
            return;
        }// end function

    }
}
