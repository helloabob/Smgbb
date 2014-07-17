package com.anttikupila.revolt
{
    import com.anttikupila.revolt.presets.*;
    import com.anttikupila.soundSpectrum.*;
    import com.tvie.*;
    import com.tvie.utilities.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class Revolt extends Sprite
    {
        private var _player:Player;
        private var _presetList:Array;
        private var _presetInt:Timer;
        private var _delayTimer:Timer;
        private var lastChange:Number;
        private var _computeTimer:Timer;
        private var _gfx:BitmapData;
        private var _sp:SoundProcessor;
        private var _preset:Preset;

        public function Revolt(param1:Player)
        {
            _player = param1;
            param1.addPlayerEventListener(PlayerEvents.RECV_METADATA, onMetaDataHandler);
            _sp = new SoundProcessor();
            _gfx = new BitmapData(_player.width, _player.height, false, 0);
            var _loc_2:* = new Bitmap(_gfx);
            addChild(_loc_2);
            _presetList = new Array(new LineFourier(), new LineNoFourier(), new Explosion(), new LineSmooth(), new LineWorm(), new Tunnel());
            _presetInt = new Timer(12950);
            _presetInt.addEventListener(TimerEvent.TIMER, nextTimedPreset);
            _computeTimer = new Timer(100);
            _computeTimer.addEventListener(TimerEvent.TIMER, onComputeHandler);
            nextPreset(null);
            return;
        }// end function

        private function setupTimer(event:Event) : void
        {
            _presetInt.start();
            nextPreset(null);
            return;
        }// end function

        public function stop() : void
        {
            return;
        }// end function

        private function nextTimedPreset(event:Event) : void
        {
            if (getTimer() - lastChange > 5000)
            {
                nextPreset(event);
            }
            return;
        }// end function

        private function onComputeHandler(event:Event) : void
        {
            var _loc_3:Array = null;
            var _loc_2:* = String(_player.getPlayerProperty(PlayerProperties.PLAYSTATE));
            if (this.visible && _loc_2 == PlayerStates.MODEL_STATE_PLAYING)
            {
                _loc_3 = _sp.getSoundSpectrum(_preset.fourier);
                _preset.applyGfx(_gfx, _loc_3);
            }
            return;
        }// end function

        private function onMetaDataHandler(event:TVieEvent) : void
        {
            var _loc_2:* = Boolean(_player.getPlayerProperty(PlayerProperties.HASVIDEO));
            if (!_loc_2)
            {
                this.visible = true;
                _computeTimer.start();
                _presetInt.start();
            }
            else
            {
                this.visible = false;
                _computeTimer.reset();
                _presetInt.reset();
            }
            return;
        }// end function

        public function start() : void
        {
            return;
        }// end function

        private function nextPreset(event:Event) : void
        {
            var _loc_2:* = Math.floor(Math.random() * _presetList.length);
            var _loc_3:* = _presetList[_loc_2];
            if (_loc_3 != _preset)
            {
                _preset = _loc_3;
                _preset.init();
            }
            else
            {
                nextPreset(null);
            }
            lastChange = getTimer();
            return;
        }// end function

    }
}
