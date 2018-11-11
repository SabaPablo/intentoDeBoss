extends KinematicBody2D

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

var velocity = Vector2()
var switch_anim = ""

func _ready():
	pass

func _physics_process(delta):
	movement_loop(delta)
	animation_loop(delta)
	deslice_wall_loop()
	print("wall: " + str(is_on_wall()) + " floor: " + str(is_on_floor()))
	velocity = move_and_slide(velocity, FLOOR)

func anim_switch(newanim):
	switch_anim = newanim

func animation_loop(newAnim):
	if $Anim.current_animation != switch_anim:
		$Anim.play(switch_anim)



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
		
	velocity.y += GRAVITY
	
	
	
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

func deslice_wall_loop():
	if is_on_wall() && !is_on_floor():
		anim_switch("SlashWall")
		velocity.y = max(velocity.y, 3)
	

#func _on_Anim_animation_finished(anim_name):
#	$Stand.disabled = true
	
