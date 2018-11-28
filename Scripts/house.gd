extends Node2D

export(String, FILE, "*.tscn") var next_lvl


func _physics_process(delta):
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(next_lvl)

