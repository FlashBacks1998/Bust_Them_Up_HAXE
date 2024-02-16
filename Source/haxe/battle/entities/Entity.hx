package battle.entities;

import sprites.SpriteHealth;
import utils.MovieClipUtil;
import openfl.Assets;
import openfl.display.MovieClip;
import openfl.geom.Vector3D;
import openfl.geom.Rectangle;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.geom.Point;

import battle.Hitbox;
import input.IInput;

class Entity extends Sprite {
    public var position:Vector3D = new Vector3D();
    public var velocity:Vector3D = new Vector3D();
    public var acceleration:Vector3D = new Vector3D();
    public var input:IInput = null; 
    public var stuned:Float = 0;

    public var hitboxes:Array<Hitbox> = [];
    public var killboxes:Array<Hitbox> = [];

    var debugSprite = new Sprite();

    public function new() {
        super();

        addChild(debugSprite);
    }

    var vx:Float = 0;
    var vy:Float = 0;
    var vz:Float = 0;
    var px:Float = 0;
    var py:Float = 0;
    var pz:Float = 0;

    public function update(deltaTime:Float, gravity:Vector3D):Void {
        final damp = .000001;

        stuned = Math.max(0, stuned-deltaTime);

        /*BUG: In the updateEntityPositions we update inbetween ...
        // Update velocity based on acceleration
        velocity.x += acceleration.x * deltaTime;
        velocity.y += acceleration.x * deltaTime;
        velocity.z += acceleration.z * deltaTime;

        // THIS
        // Update position based on velocity
        position.x += velocity.x * deltaTime;
        position.y += velocity.y * deltaTime;
        position.z += velocity.z * deltaTime;

        velocity.x *= Math.pow(damp, deltaTime);
        velocity.y += gravity.y * deltaTime; 
        velocity.z *= Math.pow(damp, deltaTime);

        //AND THIS, causing the player to move down before the check is reached
        if(position.y < 0){
            position.y = 0;
            velocity.y = 0;
        }
        */

        //FIX: we set temp variables until the function is resolved
        vx = velocity.x + acceleration.x * deltaTime;
        vy = velocity.y + acceleration.x * deltaTime;
        vz = velocity.z + acceleration.z * deltaTime;
 
        // Update position based on velocity
        px = position.x + vx * deltaTime;
        py = position.y + vy * deltaTime;
        pz = position.z + vz * deltaTime;

        vx *= Math.pow(damp, deltaTime);
        vy += gravity.y * deltaTime; 
        vz *= Math.pow(damp, deltaTime);
 
        if(py < 0 || (py == 0 && vy < 0)){
            py = 0;
            vy = 0;
        }   

        position.setTo(px,py,pz);
        velocity.setTo(vx,vy,vz); 
    }
 
    //Apply the damage and knockback to the current entity
    public function damage(killbox:Hitbox):Void {
        this.stuned += killbox.stuned;
        
        var originpos = killbox.owner.position.clone();
        var targetpos = this.position.clone();
    
        // Calculate the direction vector from owner to target
        var directionVector = new Vector3D(targetpos.x - originpos.x, targetpos.y - originpos.y, targetpos.z - originpos.z);
        directionVector.normalize(); // Normalize the vector to get unit length
    
        // Scale the direction vector by the magnitude of the knockback
        var knockbackVector = new Vector3D(killbox.knockback.x * directionVector.x, killbox.knockback.y, killbox.knockback.z * directionVector.z);
    
        // Apply the knockback to the velocity
        velocity.x += knockbackVector.x;
        velocity.y += knockbackVector.y;
        velocity.z += knockbackVector.z;
    }
    

    public function updateSprite(name:String, spriteToModify:Sprite, /*repeat = true, fps=30, replace=false,*/ ?options:{?fps:Int, ?startingFrame:Int, ?repeat:Bool, ?replace:Bool}):MovieClip {
        final stm = spriteToModify;
        final replace:Bool = options?.replace != null ? options.replace : false;

        var lib = name.split(':')[0];

        //trace(name, stm, Assets.hasLibrary(lib));

        try{
            if((stm.getChildByName(name) == null || stm.getChildByName("mc-undefined") != null || replace) && Assets.hasLibrary(lib))
            {        
                stm.removeChildren();
                //trace(stm.numChildren);
                var raw = Assets.getMovieClip(name);
                //trace(raw);
                var mc = MovieClipUtil.refineMovieclip(raw, options);
                //trace(mc);
                mc.name = name;
                stm.addChild(mc); 
    
                return mc;
            }
        } catch (e:Dynamic) { 
            trace("An error occurred: " + e);
            trace("Adding DEBUG MC");

            //Add a purple movieclip with the dimensions 421.15, 694.15 competly purple
            var purpleMC = new MovieClip();
            purpleMC.graphics.beginFill(0xFF00FF);          // Purple color
            purpleMC.graphics.drawRect(694.15, 0, 421.15, -694.15); // Dimensions
            purpleMC.graphics.endFill();
            purpleMC.name = "mc-undefined";                   // Name for if
            stm.addChild(purpleMC);                           // Add to parent sprite
            return purpleMC;                                  // Return the debug
        }
            
        return cast(stm.getChildByName(name), MovieClip);
    }

    public function drawDebug(scalex=1.0, scaley=1.0) {
        var g:Graphics = debugSprite.graphics;
        g.clear();
        drawDebugCircle(scalex, scaley);
        drawDebugHitbox(scalex, scaley);
        drawDebugKillbox(scalex, scaley);
    }
    
    public function drawDebugCircle(scalex=1.0, scaley=1.0):Void {
        var g:Graphics = debugSprite.graphics;
        g.beginFill(0x00FF00); // Green color
        g.drawCircle(0, 0, 4 * scalex); // Draw a scaled circle
        g.endFill();
    }
    
    public function drawDebugHitbox(scalex=1.0, scaley=1.0):Void {
        var g:Graphics = debugSprite.graphics; 
        g.lineStyle(1, 0xFFFF00); // Yellow color
        for (hitbox in hitboxes) {
            g.drawRect(hitbox.x, hitbox.y, hitbox.width * scalex, hitbox.height * scaley); // Draw a scaled rectangle for each hitbox
        }
    }
    
    public function drawDebugKillbox(scalex=1.0, scaley=1.0):Void {
        var g:Graphics = debugSprite.graphics;
        g.lineStyle(1, 0x0000FF); // Blue color
        for (killbox in killboxes) {
            g.drawRect(killbox.x, killbox.y, killbox.width * scalex, killbox.height * scaley); // Draw a scaled rectangle for each killbox
        }
    }    
}
