package scenes;

import openfl.geom.Vector3D;
import sprites.SpriteHealth;
import haxe.ui.core.Screen;
import haxe.ui.Toolkit;
import uicomponents.UiDebugComponent;
import uicomponents.UiDebugDefaultComponent;
import haxe.ui.HaxeUIApp;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import battle.entities.EntityDummy;
import openfl.display.SimpleButton;
import openfl.display.MovieClip;
import battle.entities.EntityPlayer;
import battle.entities.Entity;
import battle.Battlegrounds;
import openfl.Lib;
import openfl.utils.AssetLibrary;
import openfl.utils.Future;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.display.Sprite;

typedef UiComponentCorrespondingEntity = {
    var component:UiDebugDefaultComponent;
    var entity:Entity;
};

class ScenePractice extends Sprite {
    var player:Entity = null;
    var dummy:Entity = null;
    var battlegrounds:Battlegrounds = null; 
    var battlegroundsTimer:Timer = new Timer(1000 / 24);

    var mcDojoWall:MovieClip = null;
    var mcDojoFloor:MovieClip = null;
    var btnLevelSelectBack:SimpleButton = null; 

    var spMenu = new Sprite();
    var uiDebug:UiDebugComponent = null;
    var uiEntities:Array<UiComponentCorrespondingEntity> = [];
    var mcPlayerHealth:SpriteHealth = null;
    
    public function new() {
        super();

        battlegrounds = new Battlegrounds(); 
        battlegrounds.groundsScaleY = .5;
        addChild(battlegrounds);
        battlegroundsTimer.addEventListener(TimerEvent.TIMER, onTimerBattlegroundsTick);

        startPreload([
            "swf-Dojo",
            "swf-LevelSelectBack",
            "swf-HeadsUpDisplay",
            "swf-PoliceSprites",
            "swf-DummySprites",
            "swf-BaldySprites",
        ]);
         
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        Lib.current.stage.addEventListener(Event.RESIZE, onStageResize);

        trace(Lib.getTimer(), "Setting up the ui...");
        Toolkit.init();

        uiDebug = new UiDebugComponent(); 
        uiDebug.addButtonToSpawnEntity("Spawn Dummy", spawnDummy); 
        spMenu.addChild(uiDebug);
        addChild(spMenu);
        
        mcPlayerHealth = new SpriteHealth();
        mcPlayerHealth.y = 8;
        mcPlayerHealth.x = 16; 
        mcPlayerHealth.addEventListener(Event.COMPLETE, function(_) {onStageResize();});
        addChild(mcPlayerHealth); 
        
        trace(Lib.getTimer(), "Setup the ui...");
    }

    public function spawnDummy(_=null) {
        var entity = new EntityDummy();
        entity.position.x = 100 + (Math.random()*(battlegrounds.groundsWidth-100));
        entity.position.y = 200;
        entity.position.z = 100 + (Math.random()*(battlegrounds.groundsHeight-100));

        var component = new UiDebugDefaultComponent();
        component.setTitle("Dummy " + battlegrounds.entities.length);
        Assets.loadLibrary("swf-DummySprites").onComplete(function (_) {
            //BUG: HOW DO I CONVERT A MOVIECLIP TO BE USED AS A FUCKING ICON
            //component.setIcon(Assets.getMovieClip("swf-DummySprites:DummyHead"));
        });

        return addEntity(entity, component);
    }

    public function startPreload(libraries:Array<String>): Void {
        trace(Lib.getTimer(), "preloading the assets...", libraries);

        // Store the future asset loading operations in variables
        /*
        futureDojoSprites = Assets.loadLibrary("swf-Dojo");
        futurePoliceSprites = Assets.loadLibrary("swf-PoliceSprites");
        futureLevelSelectBack = Assets.loadLibrary("swf-LevelSelectBack"); 

        futureDojoSprites.onComplete(onAssetLibraryComplete);                      // Add .onComplete callback to futureDojoSprites
        futurePoliceSprites.onComplete(onAssetLibraryComplete);                    // Add .onComplete callback to futurePoliceSprites 
        futureLevelSelectBack.onComplete(onAssetLibraryComplete);                  // Add .onComplete callback to futureLevelSelectBack 
        futureDojoSprites.onProgress(onAssetLoadProgress);
        futurePoliceSprites.onProgress(onAssetLoadProgress);
        futureLevelSelectBack.onProgress(onAssetLoadProgress);
        */

        var futures:Array<Future<AssetLibrary>> = [];
        var start = Lib.getTimer();

        for(i in 0...libraries.length){
            trace(Lib.getTimer(), "preloading...", libraries[i]);

            var future = Assets.loadLibrary(libraries[i]);
            futures.push(future);

            future.onComplete(function (asset:AssetLibrary) {
                var end = Lib.getTimer();
                trace(end, end - start, "loaded assets (library)", libraries[i], asset.list(""));

                for(lfuture in futures)
                    if(!lfuture.isComplete) return;

                dispatchEvent(new Event(Event.COMPLETE));
            });
        }
    } 

    public function onEnterFrame(event:Event):Void {
        battlegrounds.updateEntityPositions();
    }

    var lastTimerBattlegroundsTick = 0;
    public function onTimerBattlegroundsTick(event:Event):Void {
        var currentTime:Int = Lib.getTimer();
        var deltaTime:Float = (lastTimerBattlegroundsTick == 0) ? 0 : (currentTime - lastTimerBattlegroundsTick) / 1000;
    
        battlegrounds.update(deltaTime);
    
        //uiPlayer.inputPositionX.text = Std.string(player.position.x);
        //uiPlayer.inputPositionY.text = Std.string(player.position.y);
        //uiPlayer.inputVelocityX.text = Std.string(player.velocity.x);
        //uiPlayer.inputVelocityY.text = Std.string(player.velocity.y);
        //uiPlayer.updateField(uiPlayer.inputVelocityY, "gay");
        //uiPlayer.setInputPositionX("123");

        for (cor in uiEntities)
        {
            cor.component.setPosition(cor.entity.position);
            cor.component.setVelocity(cor.entity.velocity);
        }

        lastTimerBattlegroundsTick = currentTime;
    }

    public function addEntity(entity:Entity, component:UiDebugDefaultComponent = null) {
        battlegrounds.addEntity(entity);

        if(component != null) {
            var cor:UiComponentCorrespondingEntity = {component: component, entity: entity};
            uiDebug.addTab(component);
            uiEntities.push(cor);
        }

        var ret:UiComponentCorrespondingEntity = {entity:entity, component:component};
        return ret;
    }

    public function onStageResize( _:Event = null) {
        //trace("resize", mcDojoWall, mcDojoFloor);

        //Reposition the wall
        if(mcDojoWall != null)
        {
            mcDojoWall.x = mcDojoWall.y = 0;
            mcDojoWall.width = Lib.current.stage.stageWidth;
            mcDojoWall.height = Lib.current.stage.stageHeight/2;
        }

        //Reposition the floor
        if(mcDojoFloor != null)
        {    
            mcDojoFloor.x = 0;
            mcDojoFloor.y = Lib.current.stage.stageHeight/2;
            mcDojoFloor.width = Lib.current.stage.stageWidth;
            mcDojoFloor.height = Lib.current.stage.stageHeight/2;
        } 

        //Resize the battlegrounds
        battlegrounds.y = Lib.current.stage.stageHeight/2;
        battlegrounds.entityScale = Math.max((Lib.current.stage.stageWidth/800),(Lib.current.stage.stageHeight/600)); 
        
        //trace("mcwidth", mcPlayerHealth.width); 
        mcPlayerHealth.scaleX = mcPlayerHealth.scaleY = ((Math.max(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight))/600); 
        spMenu.x = 32 + mcPlayerHealth.width;
        spMenu.y = mcPlayerHealth.y;

        //trace(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
    }
 
    public function onAddedToStage(_) {
        Lib.current.stage.frameRate = 144;

        battlegroundsTimer.start();

        if(!Assets.loadLibrary("swf-Dojo").isComplete) trace(Lib.getTimer(), "WARNING: Not done loading yet, some assets may be blank!");
        Assets.loadLibrary("swf-Dojo").onComplete(function (_) {
            //Replace the existing sprite
            mcDojoWall = Assets.getMovieClip("swf-Dojo:DojoWall");
            mcDojoFloor = Assets.getMovieClip("swf-Dojo:DojoFloor");

            //Debug trace
            trace("dojo", mcDojoWall, mcDojoFloor);

            //Add the children
            addChild(mcDojoWall);
            addChild(mcDojoFloor);
            setChildIndex(mcDojoWall, 0); 
            setChildIndex(mcDojoFloor, 0); 

            onStageResize();
        });

        Assets.loadLibrary("swf-LevelSelectBack").onComplete(function (_) {
            //mcDojoFloor = Assets.getMovieClip("swf-LevelSelectBack:LevelSelectBack");

            //trace("btn", mcDojoFloor);
        }); 

        player = new EntityPlayer();
        player.position.setTo(198.7, player.position.y, 279.5);
        addEntity(player, new UiDebugDefaultComponent()).component.setTitle("Player");

        spawnDummy().entity.position.setTo(607.2, player.position.y, 279.5);

        onStageResize();
    }
}
