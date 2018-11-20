extends "res://Scripts/Entity.gd"

const SPEED = 150
const GRAVITY = 15
const JUMP_POWER = 350
const FLOOR = Vector2(0,-1)
const ACCELERATION = 10
const VELOCITY_CAMERA_H = 2
const FRICTION_IDLE = 8
const FRICTION_DOWN_SLASH = 2
const TYPE = "PLAYER"

var friction = 6
var lives = 3
var live = "live" 
var hurtMode = false
var velocity = Vector2()
var switch_anim = ""
var start_anim = false

func _physics_process(delta):
	damage_loop()
	if hurtMode:
		animation_loop("Tired")
	else:
		if live == "live":
			movement_loop(delta)
			animation_loop(delta)

		else:
			dead()
	gravity_loop(delta)
	if hurting:
		velocity = move_and_slide(knockdir, FLOOR)
		#hurting=false
	else:
		velocity = move_and_slide(velocity, FLOOR)
		
func anim_switch(newanim):
	switch_anim = newanim

func animation_loop(newAnim):
	if $Anim.current_animation != switch_anim:
		$Anim.play(switch_anim)
	
func gravity_loop(delta):
	velocity.y += GRAVITY
	
func movement_loop(delta):
	var LEFT 	= Input.is_action_pressed("ui_left")
	var RIGHT 	= Input.is_action_pressed("ui_right")
	var UP	 	= Input.is_action_pressed("ui_up")
	var DOWN 	= Input.is_action_pressed("ui_down")
	var PUNCH 	= Input.is_action_pressed("a")

	if RIGHT:
		moveRigth()
	elif LEFT:
		moveLeft()
	else:
		#rozamiento
		if velocity.x < 0:
			velocity.x += friction
			velocity.x = min(velocity.x,0)
			anim_switch("Idle_slash")
		elif velocity.x > 0:
			velocity.x -= friction
			velocity.x = max(velocity.x,0)
			anim_switch("Idle_slash")
		else:
			velocity.x = 0
			if is_on_floor():
				anim_switch("Idle")
				$Stand.disabled = false

				#ataque
				if PUNCH:
					$Attack_Area/CollisionShape2D.set_disabled(true) 
					anim_switch("Atack1")
	friction = FRICTION_IDLE
	if UP:
		jump()
	if velocity.y > 0:
		fallingDown()
	
	if DOWN && !(RIGHT || LEFT):
		if is_on_floor() && velocity.x != 0:
			friction = FRICTION_DOWN_SLASH
			anim_switch("Slash")
			$Stand.disabled = true
		elif is_on_floor() && velocity.x == 0:
			anim_switch("Idle_down")
		
	
	
func moveRigth():
	velocity.x += ACCELERATION
	$Sprite.flip_h = false
	velocity.x = min(velocity.x,SPEED)
	var res = $Camera2D.get_offset().x + VELOCITY_CAMERA_H
	$Camera2D.set_offset(Vector2(min(100,res),$Camera2D.get_offset().y))
	if is_on_floor():
		anim_switch("Run")

func moveLeft():
	velocity.x -= ACCELERATION
	$Sprite.flip_h = true
	velocity.x = max(velocity.x,-SPEED)
	var res = $Camera2D.get_offset().x - VELOCITY_CAMERA_H
	$Camera2D.set_offset(Vector2(max(-100,res),$Camera2D.get_offset().y))
	if is_on_floor():
		anim_switch("Run")

func jump():
	if is_on_floor():
		velocity.y = -JUMP_POWER
		anim_switch("Jump")

func fallingDown():
	anim_switch("Down")

#func hurt():
#	if lives != 0:
#		lives -= 1
#	else:
#		live = "dead"

func dead():
	anim_switch("Tired")
	$Anim.play("Tired")

##NO ENTRA A ESTA SIGNAL 
func _on_Anim_animation_finished():
	print("LCDLLAB")
	start_anim = false
	#if $Anim.current_animation == "Tired":
	#	hurtMode = true
	#	print(hurtMode, "me tocaste el culo")
	#elif $Anim.current_animation == "Atack": 
	#	$Attack_Area/CollisionShape2D.set_disabled(false) 
		
		
func _on_Attack_Area_body_entered(body):
	if body.is_in_group("Enemies"):
		body.hurt()