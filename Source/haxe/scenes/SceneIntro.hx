package scenes;

import openfl.events.TimerEvent;
import openfl.events.TimerEvent;
import openfl.display.Loader;
import openfl.display.DisplayObjectContainer;
import openfl.net.URLRequest;
import openfl.display.Sprite;
import openfl.display.SimpleButton;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.Assets;
import openfl.Lib;

import utils.MovieClipUtil;

class SceneIntro extends Sprite {
    var btnStart: SimpleButton = null;
    var btnNewgrounds: SimpleButton = null;
    var btnFlashForward: SimpleButton = null;
    var clip: MovieClip = null;
    var music: Sound = null;
    var musicChannel: SoundChannel = null;

    public function new() {
        super();
        
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        
        music = Assets.getSound("musicIntro");   
        trace("gett intro...");
        clip = Assets.getMovieClip("swf-Intro:");

        clip.addFrameScript(478, hookButtons); 
    }

    private function hookButtons(): Void {
        trace("HOOKING BUTTONS");
        if (btnStart == null) {
            btnStart = MovieClipUtil.findButton(this, "btnStart");
            if (btnStart != null) btnStart.addEventListener(MouseEvent.CLICK, onStartButtonClick);
        }
        
        if (btnNewgrounds == null) {
            btnNewgrounds = MovieClipUtil.findButton(this, "btnNewgrounds");
            if (btnNewgrounds != null) btnNewgrounds.addEventListener(MouseEvent.CLICK, onNewgroundsButtonClick);
        }
        
        if (btnFlashForward == null) {
            btnFlashForward = MovieClipUtil.findButton(this, "btnFlashForward");
            if (btnFlashForward != null) btnFlashForward.addEventListener(MouseEvent.CLICK, onFlashForwardButtonClick);
        }
    }

    private function onAddedToStage(_: Event): Void {
        Lib.current.stage.frameRate = 30;
        
        // Play the music and store the SoundChannel object
        musicChannel = music.play();

        // Create an OpenFL Timer object with a 20ms delay
        var timer = new openfl.utils.Timer(18, 1); // 20 milliseconds, run once
        timer.addEventListener(TimerEvent.TIMER, function(e: TimerEvent): Void {
            addChild(clip);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        });
        timer.start();
    }
    

    private function onStartButtonClick(_: MouseEvent): Void {
        // Dispatch the SceneEvent.CONTINUE event to the parent
        var event = new SceneEvent(SceneEvent.CONTINUE, new SceneTransition(this,  new SceneMainMenueSelect()));
        parent.dispatchEvent(event);

        trace("Start button clicked!");
    }

    private function onNewgroundsButtonClick(_: MouseEvent): Void {
        Lib.navigateToURL(new URLRequest("https://www.newgrounds.com/"));
        
        trace("Newgrounds button clicked!");
    }

    private function onFlashForwardButtonClick(_: MouseEvent): Void {
        //Idk what to do here!

        trace("FlashForward button clicked!");
    }

    private function onEnterFrame(_: Event) {
        //trace(clip.numChildren, cast(clip.getChildAt(0), DisplayObjectContainer), Std.is(clip.getChildAt(0), MovieClip), Std.is(clip.getChildAt(0), Sprite));

        //trace(clip.numChildren, clip.getChildAt(0));
    }

    private function onRemovedFromStage(_: Event): Void {
        if (btnStart != null) {
            btnStart.removeEventListener(MouseEvent.CLICK, onStartButtonClick);
            btnStart = null;
        }
        
        if (btnNewgrounds != null) {
            btnNewgrounds.removeEventListener(MouseEvent.CLICK, onNewgroundsButtonClick);
            btnNewgrounds = null;
        }
        
        if (btnFlashForward != null) {
            btnFlashForward.removeEventListener(MouseEvent.CLICK, onFlashForwardButtonClick);
            btnFlashForward = null;
        }
        
        // Stop the music
        if (musicChannel != null) {
            musicChannel.stop();
            musicChannel = null;
        }

        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
}
