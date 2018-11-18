extends KinematicBody2D

const GRAVITY = 10
const INITIAL_SPEED = 20
const SPEED_ANGRY = 35 
const FLOOR = Vector2(0,-1)
const SPEED = INITIAL_SPEED

var velocity = Vector2()
var direction = 1
var modeAttack = false
var wait = false


	
func _physics_process(delta):
	if modeAttack:
		attack()
	else:
		if(wait):
			velocity.x = 0
		else:
			relax_movement_loop()
			
	velocity = move_and_slide(velocity,FLOOR)
	
	if is_on_wall():
		direction = direction * -1
	
	
func relax_movement_loop():
	velocity.x = SPEED * direction
	if direction == 1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	$AnimatedSprite.play("Walk")
	velocity.y += GRAVITY
	

func attack():
	velocity.x = 0
	$AnimatedSprite.play("Atack")


	
func hurt():
	pass
	
	


func _on_Area2D_body_entered(body):
	if body.name == "Player" :
		SPEED *= 2


func _on_Area2D_body_exited(body):
	if body.name == "Player" :
		SPEED *= INITIAL_SPEED
