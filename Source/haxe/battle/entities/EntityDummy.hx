package battle.entities;

import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.display.Sprite;
import input.IInput.InputChangeEvent;
import openfl.Lib;
import input.IInput.InputState;
import openfl.display.MovieClip;
import openfl.Assets;
import openfl.geom.Point;
import input.InputKeyboard;

class EntityDummy extends Entity {
    public static var SWF_LIBRARY:String = "swf-DummySprites";
    public static var SWF_LIBRARY_DUMMYHEAD:String = "DummyHead";
    public static var SWF_LIBRARY_DUMMYHIT1:String = "DummyHit1";
    public static var SWF_LIBRARY_DUMMYHIT2:String = "DummyHit2";
    public static var SWF_LIBRARY_DUMMYHIT3:String = "DummyHit3";
    public static var SWF_LIBRARY_DUMMYIDLE:String = "DummyIdle";

    var sprite:Sprite = new Sprite();
    var hbMain:Hitbox = null;
    var lastHitSprite:String = null;

    public function new() {
        super();
 
        sprite.scaleX = sprite.scaleY = .175;
        addChild(sprite);
        
        if(!Assets.hasLibrary(SWF_LIBRARY)) trace(Lib.getTimer(), "WARNING", "The "+SWF_LIBRARY+" sprite library has not been loaded, the sprites may be blank until it loads!");
        Assets.loadLibrary(SWF_LIBRARY).onComplete(function (_) {
            var mc = updateSprite(SWF_LIBRARY + ":" + SWF_LIBRARY_DUMMYIDLE, sprite, {fps:-1}); 
        });

        hbMain = new Hitbox(-25, -25, 50, 50, this);
        hitboxes.push(hbMain);
    } 

    override public function update(deltaTime:Float, g:Vector3D):Void { 
        super.update(deltaTime, g); 

        //trace(stuned);

        if(stuned<=0) 
            updateSprite(SWF_LIBRARY + ":" + SWF_LIBRARY_DUMMYIDLE, sprite, {fps:-1});
    } 

    override public function damage(killbox:Hitbox):Void {
        super.damage(killbox);

        Assets.loadLibrary(SWF_LIBRARY).onComplete(function (_) {
            var spriteToLoad = "";

            if(lastHitSprite == SWF_LIBRARY_DUMMYHIT3 || lastHitSprite == null)
                spriteToLoad = SWF_LIBRARY_DUMMYHIT1;
            else if (lastHitSprite == SWF_LIBRARY_DUMMYHIT1)
                spriteToLoad = SWF_LIBRARY_DUMMYHIT2;
            else if (lastHitSprite == SWF_LIBRARY_DUMMYHIT2)
                spriteToLoad = SWF_LIBRARY_DUMMYHIT3;

            lastHitSprite = spriteToLoad;

            var mc = updateSprite(SWF_LIBRARY + ":" + spriteToLoad, sprite, {fps:-1}); 
        });
    }
}