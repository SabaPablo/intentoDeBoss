extends KinematicBody2D

var hitstun = 0
var health = 100
var TYPE = "PLAYER"
var knockdir = Vector2(0,0)
var movedir = Vector2(0,0)
var hurting = false;
const SPEED = 150


func movement_loop():
	
	var motion
	if hitstun == 0:
		pass
	else:
		knockdir.y = -1
		knockdir = knockdir.normalized() * 50


func damage_loop():
	if hitstun > 0:
		hitstun -=1
		#$Sprite.texture = texture_hurt
	else:
		#$Sprite.texture = texture_default
		print(health)
		if TYPE == "ENEMY" && health <= 0:
			#get_parent().add_child(death_animation)
			#death_animation.global_transform = global_transform
			queue_free()
		if TYPE == "PLAYER" && health <= 0:
			print("me mori")
			pass
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			health -= body.get("DAMAGE")
			hitstun = 10
			knockdir = transform.origin - body.transform.origin
			recive_hurt()
			emit_signal("health_changed", health)
			
func recive_hurt():
	hurting = true;