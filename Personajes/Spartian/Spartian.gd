extends KinematicBody2D

const GRAVITY = 10
const INITIAL_SPEED = 20
const SPEED_ANGRY = 35 
const FLOOR = Vector2(0,-1)
const SPEED = INITIAL_SPEED
const JUMP = 300


var velocity = Vector2()
var direction = 1
var modeAttack = false
var modeAlert = false

	
func _physics_process(delta):
	if modeAttack:
		attack()
	else:
		relax_movement_loop()
			
	velocity = move_and_slide(velocity,FLOOR)
	
	if is_on_wall():
		if !modeAlert:
			direction = direction * -1
			$RunArea/CollisionShape2D.position.x *= -1
			$AttackArea/CollisionShape2D.position.x *= -1
		else:
			jump()
	
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
	$AnimatedSprite.play("Hurt")

func _on_Area2D_body_entered(body):
	if body.name == "Player" && !modeAlert:
		SPEED *= 7.5
		modeAlert = true
		
		

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		SPEED = INITIAL_SPEED
		modeAlert = false
		
		
func jump():
	velocity.y = -JUMP
	
func _on_AttackArea_body_entered(body):
	if body.name == "Player":
		modeAttack = true
		

func _on_AttackArea_body_exited(body):
	modeAttack = false
	

func _on_AnimatedSprite_animation_finished():
	if modeAttack == true:
		get_parent().get_node("Player").hurt()
		