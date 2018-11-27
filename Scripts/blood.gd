extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func set_flip(flip):
	$Sprite.flip_h = flip
	
func start():
	$AnimationPlayer.play("play")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
