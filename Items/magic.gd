extends Node2D

var TYPE = "magic"
const DAMAGE = 30
var velocity = Vector2(150,0)
var maxamount = 1
var play
var left
var explosion = preload("res://Items/explosion.tscn")


func _ready():
	TYPE = play.TYPE

	if play.has_method("state_swing"):
		$Timer.start()
		$Timer2.start()
		if left:
			velocity.x = velocity.x * -1

func set_player(player):
	play = player

func set_flip(flip):
	left = flip

func _physics_process(delta):
	velocity = move_and_slide(velocity)


func _on_Timer_timeout():
	queue_free()


func _on_Timer2_timeout():
	if(play.has_method("state_swing")):
		play.state = "default"

func desapear():
	var newitem = explosion.instance()
	newitem.position = position + Vector2(10,40)
	newitem.play()
	get_parent().add_child(newitem)
	add_child(newitem)
	_on_Timer2_timeout()
	queue_free()
	
