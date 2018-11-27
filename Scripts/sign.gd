extends Node2D

export(String) var textSing
export(Vector2) var positionRelative
var box = preload("res://Items/signbox.tscn")
var instance_box

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Area2D_body_entered(body):
	if(body.get("TYPE") == "PLAYER"):
		instance_box = box.instance()
		instance_box.position += positionRelative
		instance_box.set_text(textSing)
		add_child(instance_box)


func _on_Area2D_body_exited(body):
	if(body.get("TYPE") == "PLAYER" && instance_box!= null):
		remove_child(instance_box)
