package battle.entities;

import openfl.geom.Rectangle;
import openfl.events.Event;
import haxe.macro.Expr.Catch;
import openfl.geom.Vector3D;
import utils.MovieClipUtil;
import openfl.display.Sprite;
import input.IInput.InputChangeEvent;
import openfl.Lib;
import input.IInput.InputState;
import openfl.display.MovieClip;
import openfl.Assets;
import openfl.geom.Point;
import input.InputKeyboard;

class EntityPlayer extends Entity {
    var wantsToJump = false;
    var sprite:Sprite = new Sprite();
    var hbMain:Hitbox = null;
    var kbPunch:Hitbox = null;

    public function new() {
        super();

        sprite.scaleX = sprite.scaleY = .2;
        addChild(sprite);
        
        if(!Assets.hasLibrary("swf-PoliceSprites")) trace(Lib.getTimer(), "WARNING", "The police sprite library has not been loaded, the sprites may be blank until it loads!");
        Assets.loadLibrary("swf-PoliceSprites").onComplete(function (_) {
            //sprite.addChild(Assets.getMovieClip("swf-PoliceSprites:PoliceIdle"));
            //sprite.scaleX = sprite.scaleY = .1;
            //addChild(sprite); 
            var mc = updateSprite("swf-PoliceSprites:PoliceIdle", sprite, {repeat: true}); 
            trace('size', mc.width, mc.height);
        });

        hbMain = new Hitbox(-25, -25, 50, 50, this);
        kbPunch = new Hitbox(-20, 30, 40, 30, this); 
        kbPunch.knockback.setTo(100, 0, 0);
        hitboxes.push(hbMain);

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(_) {
        input = new InputKeyboard(this.parent);
        input.getDispatcher().addEventListener(InputChangeEvent.UPDATE, onInputUpdate); 
    }

    public function removedFromStage(_) {
        input.getDispatcher().removeEventListener(InputChangeEvent.UPDATE, onInputUpdate); 
    }

    var dir:Point = new Point();
    override public function update(deltaTime:Float, g:Vector3D):Void {
        //trace(stuned);

        super.update(deltaTime, g);
        
        if(stuned<=0){
            //TODO: better killbox removal
            killboxes.remove(kbPunch);
            kbPunch.affected = [];

            input.getMoveDirection(dir);
            velocity.x = (dir.x==0) ? velocity.x : dir.x*(400*1.2);
            velocity.z = (dir.y==0) ? velocity.z : dir.y*(400*1.2);   

            if(wantsToJump && position.y <= 0)
            {
                velocity.y += 1700;
            } 

            onInputUpdate(new InputChangeEvent("", cast(input, InputKeyboard).state));
        }

        //trace("dir", dir);
        //trace("velocity", velocity);
        //trace("position", position);
    }

    public function onInputUpdate(event:InputChangeEvent) {
        final state = event.state;

        wantsToJump = state.jumpKeyPressed; 

        //trace(state.attackKeyPressed);

        if(stuned>0) return;

        if (state.attackKeyPressed) {
            final fps: Int = 45;
            var mc:MovieClip = cast(updateSprite("swf-PoliceSprites:PolicePunch1", sprite, {repeat:false, fps:fps, replace:true}), MovieClip); 
            final totalFrames: Int = 8;

            final side = Math.abs(sprite.scaleX) / sprite.scaleX;
            final xoff = 30;
            final xfin = (side>0) ? xoff : -xoff - kbPunch.width;
            kbPunch.setTo(xfin, -25, 40, 30);

            stuned = (totalFrames * (1/fps));
            killboxes.push(kbPunch);
        }
        
        else if(position.y > 0 || (wantsToJump && position.y == 0)) {
            var mc = updateSprite("swf-PoliceSprites:PoliceJump", sprite, {repeat: false, fps:45});

        } else if(state.moveDirection.y != 0 || state.moveDirection.x != 0) { 
            var mc = updateSprite("swf-PoliceSprites:PoliceRun", sprite, {repeat:true}); 
        }
        else { 
            var mc = updateSprite("swf-PoliceSprites:PoliceIdle", sprite, {repeat:true}); 
        } 

        if(state.moveDirection.x != 0 && stuned<=0)
            sprite.scaleX = Math.abs(sprite.scaleX) * ((state.moveDirection.x > 0) ? 1 : -1);
    }
}