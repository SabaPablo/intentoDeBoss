extends KinematicBody2D

const GRAVITY = 10
const SPEED = 20
const SPEED_ANGRY = 35 
const DAMAGE = 10
const FLOOR = Vector2(0,-1)
var velocity = Vector2()
var modoDiablo = false
var hitstun = 0
var knockdir = Vector2(0,0)
const TYPE = "ENEMY"
var direction = 1
var wait = false
var modeAttack = false
var exclamations = preload("res://Efects/expresions/buble_expresion.tscn")
var fireDead = preload("res://Efects/fire.tscn")
var health = 30
var status = "live"

func _ready():
	pass
	
func _physics_process(delta):
	if status == "live":
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
	else:
		pass
	velocity = move_and_slide(velocity,FLOOR)
	dont_fall()
	damage_loop()
	if is_on_wall():
		turn()
		

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
	if body.get("TYPE") == "PLAYER" and status=="live":
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
	if body.get("TYPE") == "PLAYER" and status == "live":
		modo_lazy()
		wait = true
		$timer.start()
		get_exclamation(self.position.x,self.position.y,"quest")
		$timer.start()
		$Animation.play("React")

func modo_lazy():
	modoDiablo = false

func modo_diablo():
	modoDiablo = true

func _on_AttackeZone_body_entered(body):
	if body.get("TYPE") == "PLAYER" and status == "live":
		modeAttack = true
		body.recive_hurt()

func _on_AttackeZone_body_exited(body):
	if body.get("TYPE") == "PLAYER" and status == "live":
		modeAttack = false

func _on_Timer_timeout():
	wait = false

func dead():
	$CollisionShape2D.set_disabled(true) 
	$Animation.play("Dead")
	status = "dead"

func hurt():
	$Animation.play("Hit")
	
func dont_fall():
	if !$RayCast2D.is_colliding():
		turn()
		
func turn():
	direction = direction * -1
	$Animation/AreaDeVision/CollisionShape2D.position.x *= -1
	$Animation/AttackeZone/CollisionShape2D.position.x *= -1
	$RayCast2D.position.x *= -1
	$halberd.position.x *= -1
	
	
func damage_loop():
	if hitstun > 0:
		hitstun -=1
	else:
		if TYPE == "ENEMY" && health <= 0:
			dead()
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			health -= body.get("DAMAGE")
			hitstun = 10
			knockdir = transform.origin - body.transform.origin
			emit_signal("health_changed", health)

func _on_Animation_animation_finished():
	if status == "dead":
		queue_free()
