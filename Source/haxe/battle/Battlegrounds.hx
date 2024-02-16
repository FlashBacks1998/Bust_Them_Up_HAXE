package battle;

import openfl.Lib;
import openfl.geom.Vector3D;
import math.Algorithm;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import battle.entities.Entity;

class Battlegrounds extends Sprite {
    public var entities:Array<Entity> = [];
    public var groundsWidth:UInt = 800;
    public var groundsHeight:UInt = 600;
    public var groundsScaleX:Float = 1;
    public var groundsScaleY:Float = 1;
    public var groundsSprite:Sprite = new Sprite();
    public var entityScale:Float = 1;
    public var viewHitboxes:Bool = false;

    public var gravity:Vector3D = new Vector3D(0,-8000,0);

    public function new() {
        super();

        addChild(groundsSprite); 
    }

    public function updateEntityOrder() {
        entities.sort(function(a:Entity, b:Entity):Int {
            if (a.position.z < b.position.z) return -1;
            if (a.position.z > b.position.z) return 1;
            return 0;
        });
    
        // Reorder entities on the sprite based on the sorted array
        for (i in 0...entities.length) {
            var entity = entities[i];
            setChildIndex(entity, i);
        }
        
        setChildIndex(groundsSprite, 0);
    }


    public function updateEntityPositions() { 
        final dt = (Lib.getTimer()-lastUpdated) / 1000; 
        
        groundsSprite.graphics.clear();
        groundsSprite.graphics.beginFill(0x00FF0000); // Red color
        groundsSprite.graphics.drawRect(0, 0, groundsWidth*groundsScaleX, groundsWidth*groundsScaleY);
        groundsSprite.graphics.endFill();

        for (entity in entities) {
            //trace(entity.velocity.y);
            entity.x = (entity.position.x + (entity.velocity.x*dt)) * groundsScaleX;
            entity.y = ((entity.position.z + (entity.velocity.z*dt))* groundsScaleY) - ((entity.position.y + (entity.velocity.y * dt)) * groundsScaleY);
        }
    }
 
    public function checkHitboxes():Void {
        if (entities == null) {
            trace("Error: Entities array is null");
            return;
        }

        for (i in 0...entities.length) {
            if (entities[i] == null || entities[i].killboxes == null) {
                continue; // Skip iteration if the entity or its killboxes are null
            }
    
            for (j in 0...entities[i].killboxes.length) {
                var killBox = entities[i].killboxes[j].clone();
                killBox.x += entities[i].position.x;
                killBox.y += entities[i].position.z;
    
                for (k in 0...entities.length) {
                    if (i == k || entities[k] == null || entities[k].hitboxes == null) {
                        continue; // Skip iteration if the entity or its hitboxes are null
                    }
    
                    for (l in 0...entities[k].hitboxes.length) {
                        var hitbox = entities[k].hitboxes[l].clone();
                        hitbox.x += entities[k].position.x;
                        hitbox.y += entities[k].position.z;
    
                        //trace(killBox.intersects(hitbox), killBox, hitbox);
                        if(killBox.intersects(hitbox) && entities[i].killboxes[j].affected.indexOf(entities[k]) == -1)
                        {
                            entities[k].damage(entities[i].killboxes[j]);       
                            entities[i].killboxes[j].affected.push(entities[k]);
                        }
                    }
                }
            }
        }
    }
    
    var lastUpdated = 0;
    public function update(dt:Float):Void { 
        lastUpdated = Lib.getTimer();
        //var start = Lib.getTimer();

        checkHitboxes();

        for (entity in entities) 
        {
            entity.update(dt, gravity);  
            if(viewHitboxes) entity.drawDebug(groundsScaleX, groundsScaleY);

            entity.position.x = Algorithm.clamp(entity.position.x, 0, groundsWidth); 
            entity.position.z = Algorithm.clamp(entity.position.z, 0, groundsHeight);  

            entity.scaleX = entity.scaleY = entityScale;
        }

        updateEntityOrder();
        updateEntityPositions();

        //trace("UPDATE", Lib.getTimer() - start );
    }

    public function addEntity(entity:Entity):Void {
        entities.push(entity);
        addChild(entity);
    }

    public function removeEntity(entity:Entity):Void {
        var index:Int = entities.indexOf(entity);
        if (index != -1) {
            entities.splice(index, 1);
            removeChild(entity);
        }
    }
}
