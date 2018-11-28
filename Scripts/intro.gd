extends Node

export(String, FILE, "*.tscn") var next

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if $Control.visible:
				$Control.visible = false
				$Control2.visible = true
				return
			elif $Control2.visible:
				$Control2.visible = false
				$Control3.visible = true
				return
			elif $Control3.visible:
				$Control3.visible = false
				$Control4.visible = true
				return
			elif $Control4.visible:
				$Control4.visible = false
				get_tree().change_scene(next)

