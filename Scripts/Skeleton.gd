extends KinematicBody2D

const GRAVITY = 10
const SPEED = 20
const SPEED_ANGRY = 35 
const FLOOR = Vector2(0,-1)
var velocity = Vector2()
var modoDiablo = false
var direction = 1
var modeAttack = false

func _ready():
	pass
	
func _physics_process(delta):
	if modeAttack:
		attack()
	else:
		if(modoDiablo):
			evil_movement_loop();
		else:
			relax_movement_loop();
	
	velocity = move_and_slide(velocity,FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		
func attack():
	velocity.x = 0
	$Animation.play("Attack")

func relax_movement_loop():
	velocity.x = SPEED * direction
	if direction == 1:
		$Animation.flip_h = false
	else:
		$Animation.flip_h = true
	
	$Animation.play("Walk")
	velocity.y += GRAVITY
	
func evil_movement_loop():
	velocity.x = SPEED_ANGRY * direction
	if direction == 1:
		$Animation.flip_h = false
	else:
		$Animation.flip_h = true
	
	$Animation.play("Walk_Angry")
	velocity.y += GRAVITY
	

func _on_AreaDeVision_body_entered(body):
	if body.get("TYPE") == "PLAYER":
		print("muereee")
		$Animation.play("React")
		$Animation.connect("animation_finished",self,"destroy")
		modo_diablo()

func _on_AreaDeVision_body_exited(body):
	if body.get("TYPE") == "PLAYER":
		modo_lazy()
		print("Se fue?")

func modo_lazy():
	modoDiablo = false

func modo_diablo():
	modoDiablo = true

func _on_AttackeZone_body_entered(body):
	if body.get("TYPE") == "PLAYER":
		modeAttack = true


func _on_AttackeZone_body_exited(body):
	if body.get("TYPE") == "PLAYER":
		modeAttack = false
