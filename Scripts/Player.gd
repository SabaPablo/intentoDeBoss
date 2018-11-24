extends "res://Scripts/Entity.gd"

signal health_changed
signal died

const SPEED = 150
const GRAVITY = 15
const JUMP_POWER = 350
const FLOOR = Vector2(0,-1)
const ACCELERATION = 10
const VELOCITY_CAMERA_H = 2
const FRICTION_IDLE = 8
const FRICTION_DOWN_SLASH = 2
const TYPE = "PLAYER"
var in_attack = false;
var power
var friction = 6
var lives = 3
var hurtMode = false
var dead = false
var velocity = Vector2()
var switch_anim = ""
#var start_anim = false
var state = "default"

func _physics_process(delta):
	if(dead):
		return
	match state:
		"default":
			state_default(delta)
		"swing":
			state_swing(delta)

func atack():
	anim_switch("Atack1")

func state_swing(delta):
	animation_loop()

func state_default(delta):
		#damage_loop()
	animation_loop()
	if live == "live":
		movement_loop(delta)
	else:
		dead()
		dead = true
	gravity_loop(delta)
	if hurting:
		set_global_position(global_position + knockdir)
		velocity = move_and_slide(knockdir, FLOOR)
		hurting=false
	else:
		velocity = move_and_slide(velocity, FLOOR)

func anim_switch(newanim):
	switch_anim = newanim


func animation_loop():
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
	var MAGIC_PUNCH = Input.is_action_pressed("b")
	MAGIC_PUNCH

	if RIGHT:
		moveRigth()
	elif LEFT:
		moveLeft()
	#elif in_attack:
	#	pass
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
	if PUNCH and is_on_floor():
		get_tree().get_nodes_in_group("sfx")[0].get_node("attack_player").play()
		use_item(preload("res://Items/sword.tscn"))
		#in_attack = true
		anim_switch("Atack1")
		#$Anim.connect("animation_finished",self,"end_attack")
	if MAGIC_PUNCH and is_on_floor():
		#get_tree().get_nodes_in_group("sfx")[0].get_node("attack_player").play()
		$Timer.start()
		#in_attack = true
		anim_switch("Power")
		power = preload("res://Efects/nebula.tscn")
		var newitem = power.instance()
		add_child(newitem)
		
		state = "swing"
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
		
#func end_attack(anim):
#	print("end")
	
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
		get_tree().get_nodes_in_group("sfx")[0].get_node("jump_player").play()
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

##NO ENTRA A ESTA SIGNAL 
#func _on_Anim_animation_finished():
	#print("LCDLLAB")
#	start_anim = false
#	if $Anim.current_animation == "Tired":
#		hurtMode = true
	#	print(hurtMode, "me tocaste el culo")
#	elif $Anim.current_animation == "Atack1": 
#		$Attack_Area/CollisionShape2D.set_disabled(false) 
		
		
func _on_Attack_Area_body_entered(body):
	if body.is_in_group("Enemies"):
		body.hurt()
		
		
func use_magic():
	var item = preload("res://Items/magic.tscn")
	var newitem = item.instance()
	newitem.set_player(self)
	newitem.set_flip($Sprite.flip_h)
	newitem.add_to_group(str(newitem.get_name(),self))
	var new_position
	if($Sprite.flip_h):
		newitem.position = position + Vector2(-10,-40)
	else:
		 newitem.position = position + Vector2(10,-40)
	get_parent().add_child(newitem)
	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
		newitem.queue_free()
	
	
	
func use_item(item):
	var newitem = item.instance()
	newitem.add_to_group(str(newitem.get_name(),self))
	var new_position
	if($Sprite.flip_h):
		new_position = newitem.position + Vector2(-20,0)
	else:
		new_position = newitem.position + Vector2(20,0)
	newitem.position = new_position
	add_child(newitem)
	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
		newitem.queue_free()

func _on_Timer_timeout():
	use_magic()
	$Timer.stop()
