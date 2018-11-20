extends Control

func _ready():
	pass


func _on_Start_pressed():
	get_tree().change_scene("res://world.tscn")


func _on_Quit_pressed():
	get_tree().quit()
