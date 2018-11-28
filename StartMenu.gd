extends Control

func _ready():
	pass


func _on_Start_pressed():
	get_tree().get_nodes_in_group("sfx")[0].get_node("AudioClicButton").play()
	get_tree().change_scene("res://Level/scene/Scene_0.tscn")


func _on_Quit_pressed():
	get_tree().get_nodes_in_group("sfx")[0].get_node("AudioClicButton").play()
	get_tree().quit()
