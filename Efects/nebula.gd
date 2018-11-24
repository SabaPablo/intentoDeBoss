extends Node2D


func _ready():
	$AnimationPlayer.play("fire")
	$Timer.start()


func _on_Timer_timeout():
	queue_free()
