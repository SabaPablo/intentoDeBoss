extends Node2D

var TYPE = null
const DAMAGE = 30
var velocity = Vector2(80,0)
var maxamount = 1
var play
var left



func _ready():
	TYPE = play.TYPE

	if play.has_method("state_swing"):
		#play.atack()
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
