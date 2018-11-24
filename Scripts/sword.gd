extends Node2D

var TYPE = null
const DAMAGE = 30

var maxamount = 1

func _ready():
	TYPE = get_parent().TYPE

	if get_parent().has_method("state_swing"):
		get_parent().atack()
		get_parent().state = "swing"
		$Timer.start()
	


func _on_Timer_timeout():
	if(get_parent().has_method("state_swing")):
		get_parent().state = "default"
	queue_free()
