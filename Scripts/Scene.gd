extends Control

export(String, FILE, "*.tscn") var next

func _input(event):
    if event is InputEventKey:
        if event.pressed:
            get_tree().change_scene(next)

func _ready():
	pass

