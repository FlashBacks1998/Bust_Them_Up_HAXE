package scenes;

import openfl.geom.Point;
import openfl.display.Sprite;
import openfl.display.SimpleButton;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;
import openfl.Lib;

import math.Algorithm;
import utils.MovieClipUtil;

class SceneMissionSelect extends Sprite {

    var btnNext: SimpleButton = null;
    var btnPrev: SimpleButton = null;
    var btnGo: SimpleButton = null;
    var btnBack: SimpleButton = null;

    var mcCase1: MovieClip = null;
    var mcCase2: MovieClip = null;
    var mcCase3: MovieClip = null;
    var mcCase4: MovieClip = null;
    var mcCaseReference: MovieClip = null;
    var mcOptions: Array<{option: MovieClip, startingPoint: Point}> = [];

    var selected = 0;

    public function new() {
        super();

        Lib.current.stage.frameRate = 1000;

        // Add the main clip
        var clip = Assets.getMovieClip("swf-MissionSelect:");
        addChild(clip);

        btnNext = MovieClipUtil.findButton(clip, "btnNext");
        btnPrev = MovieClipUtil.findButton(clip, "btnPrev");
        btnGo   = MovieClipUtil.findButton(clip, "btnGo");
        btnBack = MovieClipUtil.findButton(clip, "btnBack");

        mcCase1 = MovieClipUtil.findMovieClip(clip, "mcCase1");
        mcCase2 = MovieClipUtil.findMovieClip(clip, "mcCase2");
        mcCase3 = MovieClipUtil.findMovieClip(clip, "mcCase3");
        mcCase4 = MovieClipUtil.findMovieClip(clip, "mcCase4");
        mcCaseReference = MovieClipUtil.findMovieClip(clip, "mcCaseReference");
        
        trace("objects", btnNext, btnPrev, mcCase1, mcCase2, mcCase3, mcCase4, mcCaseReference, btnGo, btnBack);

        mcOptions = [
            {option: mcCase1, startingPoint: new Point(mcCase1.x, mcCase1.y)}, 
            {option: mcCase2, startingPoint: new Point(mcCase2.x, mcCase2.y)}, 
            {option: mcCase3, startingPoint: new Point(mcCase3.x, mcCase3.y)}, 
            {option: mcCase4, startingPoint: new Point(mcCase4.x, mcCase4.y)}];

        trace("objects", btnNext, btnPrev, mcCase1, mcCase2, mcCase3, mcCase4, mcCaseReference, btnGo, btnBack);
        trace(mcOptions);

        mcCaseReference.visible = false;

        btnNext.addEventListener(MouseEvent.CLICK, onNextClicked);
        btnPrev.addEventListener(MouseEvent.CLICK, onPrevClicked);
        btnGo.addEventListener(MouseEvent.CLICK, onGoClicked);
        btnBack.addEventListener(MouseEvent.CLICK, onBackClicked);  

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }


    private function onNextClicked(event: MouseEvent): Void {
        selected = Algorithm.clamp(selected + 1, 0, mcOptions.length - 1);
    }

    private function onPrevClicked(event: MouseEvent): Void {
        selected = Algorithm.clamp(selected - 1, 0, mcOptions.length - 1);
    }

    private function onGoClicked(event: MouseEvent): Void {
        // Handle the go button click event
    }
    
    private function onBackClicked(event: MouseEvent): Void {     
        trace("-------------------");   
        var scene = new SceneMainMenueSelect();
        trace("scene", scene);
        var event = new SceneEvent(SceneEvent.CONTINUE, scene);
        trace("event", event);
        trace("swap", parent, scene, event);
        parent.dispatchEvent(event);
    }

    var previousTime = 0;
    public function onEnterFrame(_: Dynamic) {
        var springConst = 15;
        var currentTime = Lib.getTimer();
        var deltaTime = (currentTime - previousTime) / 1000; // Convert milliseconds to seconds
        previousTime = currentTime;
    
        for (i in 0...mcOptions.length) {
            if (i == selected) continue;

            mcOptions[i].option.x += Algorithm.calculateSpringConstant(mcOptions[i].option.x, mcOptions[i].startingPoint.x, springConst * deltaTime);
            mcOptions[i].option.y += Algorithm.calculateSpringConstant(mcOptions[i].option.y, mcOptions[i].startingPoint.y, springConst * deltaTime);
        }
    
        //trace(mcOptions[selected], mcCaseReference.x, mcCaseReference.y);

        mcOptions[selected].option.x += Algorithm.calculateSpringConstant(mcOptions[selected].option.x, mcCaseReference.x, springConst * deltaTime);
        mcOptions[selected].option.y += Algorithm.calculateSpringConstant(mcOptions[selected].option.y, mcCaseReference.y, springConst * deltaTime);
    }
}
