package battle;

import openfl.geom.Vector3D;
import openfl.geom.Rectangle;

import battle.entities.Entity;

class Hitbox extends Rectangle {
    public var owner:Entity = null;
    public var affected:Array<Entity> = [];
    public var knockback:Vector3D;
    public var damage:Float;
    public var stuned:Float;

    public function new(x, y, width, height, owner, knockback = null, damage = 25, stuned=.15) {
        super(x,y,width,height);
        this.owner=owner;
        this.knockback = (knockback!=null) ? knockback : new Vector3D();
        this.damage = damage;
        this.stuned = stuned;
    }
}