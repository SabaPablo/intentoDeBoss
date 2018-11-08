extends KinematicBody2D

const SPEED = 100
const GRAVITY = 20
const JUMP_POWER = 450
const FLOOR = Vector2(0,-1)
const ACCELERATION = 10
var friction = 6
var velocity = Vector2()
var switch_anim = ""

func _ready():
	pass

func _physics_process(delta):
	movement_loop(delta)
	animation_loop(delta)

func anim_switch(newanim):
	switch_anim = newanim

func animation_loop(delta):
	if $Anim.current_animation != switch_anim:
		$Anim.play(switch_anim)



func movement_loop(delta):
	var LEFT 	= Input.is_action_pressed("ui_left")
	var RIGHT 	= Input.is_action_pressed("ui_right")
	var UP	 	= Input.is_action_pressed("ui_up")
	var DOWN 	= Input.is_action_pressed("ui_down")
	
	if RIGHT:
		velocity.x += ACCELERATION
		$Sprite.flip_h = false
		velocity.x = min(velocity.x,SPEED)
		if is_on_floor():
			anim_switch("Run")
	elif LEFT:
		velocity.x -= ACCELERATION
		velocity.x = max(velocity.x,-SPEED)
		$Sprite.flip_h = true
		if is_on_floor():
			anim_switch("Run")
	else:
		if velocity.x < 0:
			velocity.x += friction
			velocity.x = min(velocity.x,0)
		elif velocity.x > 0:
			velocity.x -= friction
			velocity.x = max(velocity.x,0)
		else:
			velocity.x = 0
		if is_on_floor():
			anim_switch("Idle")
	friction = 5
	if UP:
		if is_on_floor():
			velocity.y = -JUMP_POWER
			anim_switch("Jump")
	elif DOWN && !LEFT && !RIGHT:
		if is_on_floor() && velocity.x!=0:
			friction = 2
			anim_switch("Slash")
		elif is_on_floor() && velocity.x ==0:
			anim_switch("Idle_down")
			

	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)