package com.tvie.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;

    public class ContextMenuDelegate extends Object
    {
        private var _cMenu:ContextMenu;

        public function ContextMenuDelegate(param1:InteractiveObject, param2:Function)
        {
            _cMenu = new ContextMenu();
            _cMenu.hideBuiltInItems();
            _cMenu.addEventListener(ContextMenuEvent.MENU_SELECT, param2);
            param1.contextMenu = _cMenu;
            return;
        }// end function

        public function removeMenuItem(addEventListener:RegExp, addEventListener:Function = null) : void
        {
            var _loc_5:ContextMenuItem = null;
            var _loc_3:* = _cMenu.customItems;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                _loc_5 = _loc_3[_loc_4] as ContextMenuItem;
                if (_loc_5.caption.search(addEventListener) != -1)
                {
                    if (addEventListener != null)
                    {
                        (_loc_3[_loc_4] as ContextMenuItem).removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addEventListener);
                    }
                    _loc_3.splice(_loc_4, 1);
                    _loc_4 = 0;
                    continue;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function addDataRateList(addEventListener:Object, addEventListener:Function = null) : void
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:ContextMenuItem = null;
            var _loc_6:String = null;
            if (addEventListener is Array)
            {
                _loc_3 = 0;
                while (_loc_3 < addEventListener.length)
                {
                    
                    _loc_4 = String(addEventListener[_loc_3]) + "kbps";
                    _loc_5 = new ContextMenuItem(_loc_4);
                    _cMenu.customItems.push(_loc_5);
                    if (addEventListener != null)
                    {
                        _loc_5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addEventListener);
                    }
                    _loc_3++;
                }
            }
            else
            {
                for (_loc_6 in addEventListener)
                {
                    
                    _loc_4 = String(addEventListener[_loc_6]) + " kbps";
                    _loc_5 = new ContextMenuItem(_loc_4);
                    _cMenu.customItems.push(_loc_5);
                    if (addEventListener != null)
                    {
                        _loc_5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addEventListener);
                    }
                }
            }
            return;
        }// end function

        public function addMenuItem(addEventListener:ContextMenuItem, addEventListener:Function = null) : void
        {
            if (addEventListener != null)
            {
                addEventListener.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addEventListener);
            }
            _cMenu.customItems.push(addEventListener);
            return;
        }// end function

    }
}
