package scenes;

import openfl.net.URLRequest;
import openfl.display.Sprite;
import openfl.display.SimpleButton;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;
import openfl.Lib;

import math.Algorithm;
import utils.MovieClipUtil;

class SceneMainMenueSelect extends Sprite {

    var btnNext: SimpleButton = null;
    var btnPrev: SimpleButton = null;

    var btnStorymode: SimpleButton = null;
    var btnPracticemode: SimpleButton = null;
    var btnEndlessmode: SimpleButton = null;
    var btnNewgrounds: SimpleButton = null;

    var btnOptions: Array<SimpleButton> = [];

    var btnDescription: SimpleButton = null;

    var mcSelectedBackdrop: MovieClip = null;

    var selected = 0;

    public function new() {
        super();

        trace("NEW");

        Lib.current.stage.frameRate = 1000;

        // Add the main clip
        var clip = Assets.getMovieClip("swf-MainMenuReal:");

        trace(clip);

        btnNext = MovieClipUtil.findButton(clip, "btnNext");
        btnPrev = MovieClipUtil.findButton(clip, "btnPrev");

        trace(btnNext, btnPrev);

        btnStorymode = MovieClipUtil.findButton(clip, "btnStorymode");
        btnPracticemode = MovieClipUtil.findButton(clip, "btnPracticemode");
        btnEndlessmode = MovieClipUtil.findButton(clip, "btnEndlessmode");
        btnNewgrounds = MovieClipUtil.findButton(clip, "btnNewgrounds");
        btnOptions = [btnStorymode, btnPracticemode, btnEndlessmode, btnNewgrounds];

        trace(btnOptions);

        btnDescription = MovieClipUtil.findButton(clip, "btnDescription");

        mcSelectedBackdrop = MovieClipUtil.findMovieClip(clip, "mcSelectedBackdrop");

        btnNext.addEventListener(MouseEvent.CLICK, onNextClicked);
        btnPrev.addEventListener(MouseEvent.CLICK, onPrevClicked);

        btnStorymode.addEventListener(MouseEvent.CLICK, onStorymodeOptionClick);
        btnPracticemode.addEventListener(MouseEvent.CLICK, onPracticemodeOptionClick);
        btnEndlessmode.addEventListener(MouseEvent.CLICK, onEndlessmodeOptionClick);
        btnNewgrounds.addEventListener(MouseEvent.CLICK, onNewgroundsOptionClick);

        trace("buttons", btnNext, btnPrev, btnStorymode, btnPracticemode, btnEndlessmode, btnNewgrounds, btnDescription, mcSelectedBackdrop);

        addEventListener(Event.ADDED_TO_STAGE, function(_) { addChild(clip); });
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onNextClicked(event: MouseEvent): Void {
        selected = Algorithm.clamp(selected + 1, 0, btnOptions.length - 1);
    }

    private function onPrevClicked(event: MouseEvent): Void {
        selected = Algorithm.clamp(selected - 1, 0, btnOptions.length - 1);
    }

    private function onStorymodeOptionClick(event: MouseEvent): Void {
        // Handle Storymode option button click event
        trace("Storymode option button clicked:", event.currentTarget);
         
        var event = new SceneEvent(SceneEvent.CONTINUE, new SceneMissionSelect());
        parent.dispatchEvent(event);
    }
    
    private function onPracticemodeOptionClick(event: MouseEvent): Void {
        // Handle Practicemode option button click event
        trace("Practicemode option button clicked:", event.currentTarget);

        var event = new SceneEvent(SceneEvent.CONTINUE, new SceneTransition(this, new ScenePractice()));
        parent.dispatchEvent(event);
    }
    
    private function onEndlessmodeOptionClick(event: MouseEvent): Void {
        // Handle Endlessmode option button click event
        trace("Endlessmode option button clicked:", event.currentTarget);
    }
    
    private function onNewgroundsOptionClick(event: MouseEvent): Void {
        // Handle Newgrounds option button click event
        trace("Newgrounds option button clicked:", event.currentTarget);

        Lib.navigateToURL(new URLRequest("https://www.newgrounds.com/"));
        
    }

    var previousTime = 0;
    public function onEnterFrame(_: Dynamic) {
        var springConst = 10;
        var currentTime = Lib.getTimer();
        var deltaTime = (currentTime - previousTime) / 1000; // Convert milliseconds to seconds
        previousTime = currentTime;
    
        for (i in 0...btnOptions.length) {
            if (i == selected) continue;

            final xoffset = (i-selected > 0) ? 308.4 + (((i - 1) - selected) * 125)
                                             : (((i - 1) - selected) * (125));

            btnOptions[i].x += Algorithm.calculateSpringConstant(btnOptions[i].x, xoffset, springConst * deltaTime);
            btnOptions[i].y += Algorithm.calculateSpringConstant(btnOptions[i].y, 195.3, springConst * deltaTime);
            btnOptions[i].width += Algorithm.calculateSpringConstant(btnOptions[i].width, 104.6, springConst * deltaTime);
            btnOptions[i].height += Algorithm.calculateSpringConstant(btnOptions[i].height, 121.85, springConst * deltaTime);
        }
    
        btnOptions[selected].x += Algorithm.calculateSpringConstant(btnOptions[selected].x, mcSelectedBackdrop.x - 0.5, springConst * deltaTime);
        btnOptions[selected].y += Algorithm.calculateSpringConstant(btnOptions[selected].y, mcSelectedBackdrop.y - 4.1, springConst * deltaTime);
        btnOptions[selected].width += Algorithm.calculateSpringConstant(btnOptions[selected].width, mcSelectedBackdrop.width - 7.9, springConst * deltaTime);
        btnOptions[selected].height += Algorithm.calculateSpringConstant(btnOptions[selected].height, mcSelectedBackdrop.height - 7.6, springConst * deltaTime);
    }
    
}
