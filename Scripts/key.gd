extends Node2D

export(NodePath) var door

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		var doornode = get_node(door)
		doornode.got_key()
		queue_free()
