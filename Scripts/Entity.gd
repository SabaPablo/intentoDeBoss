extends KinematicBody2D

var hitstun = 0
var health = 100
var TYPE = "PLAYER"
var knockdir = Vector2(0,0)
var movedir = Vector2(0,0)
var hurting = false;
var blood = preload("res://Efects/blood.tscn")
const SPEED = 150
var live = "live"
 
func movement_loop():	
	var motion
	if hitstun == 0:
		pass
	else:
		knockdir.y = -1
		knockdir = knockdir.normalized() * 10


func damage_loop():
	if hitstun > 0:
		hitstun -=1
	else:
		if TYPE == "ENEMY" && health <= 0:
			queue_free()
		if TYPE == "PLAYER" && health <= 0:
			live = "dead"

func recive_hurt():
	
	var newitem = blood.instance()
	newitem.add_to_group(str(newitem.get_name(),self))
	if(!$Sprite.flip_h):
		newitem.position += Vector2(-5,0)
	else:
		newitem.position += Vector2(5,0)
	add_child(newitem)
	newitem.set_flip($Sprite.flip_h)
	newitem.start()
	
	hurting = true;
	health -=30
	emit_signal("health_changed", health)