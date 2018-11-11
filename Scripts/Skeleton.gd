extends KinematicBody2D

const GRAVITY = 10
const SPEED = 20
const SPEED_ANGRY = 35 
const FLOOR = Vector2(0,-1)
var velocity = Vector2()
var modoDiablo = false
var direction = 1
var wait = false
var modeAttack = false
var exclamations = preload("res://Efects/expresions/buble_expresion.tscn")
var fireDead = preload("res://Efects/fire.tscn")

func _ready():
	pass
	
func _physics_process(delta):
	if modeAttack:
		attack()
	else:
		if(wait):
			velocity.x = 0
		else:
			if(modoDiablo):
				evil_movement_loop();
			else:
				relax_movement_loop();
	
	velocity = move_and_slide(velocity,FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$Animation/AreaDeVision/CollisionShape2D.position.x *= -1
		$Animation/AttackeZone/CollisionShape2D.position.x *= -1
		

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
		wait = true
		$timer.start()
		get_exclamation(self.position.x,self.position.y,"exclamation")
		modo_diablo()

func get_exclamation(x,y,expres):
	var exclamation = exclamations.instance()
	exclamation.set_position(Vector2(x ,y-15))
	get_parent().add_child(exclamation)
	exclamation.get_node("anim").play(expres)

func _on_AreaDeVision_body_exited(body):
	if body.get("TYPE") == "PLAYER":
		modo_lazy()
		wait = true
		$timer.start()
		get_exclamation(self.position.x,self.position.y,"quest")
		$timer.start()
		print("Se fue?")
		$Animation.play("React")

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


func _on_Timer_timeout():
	wait = false


func dead():
	var dead = fireDead.instance()
	dead.position = $Animation.global_position
	queue_free()
	get_parent().add_child(dead)

func hurt():
	print("iuuuuuuu")
	$Animation.play("Hit")
	
func _on_Area2D_body_entered(body):
	body.hurt()
