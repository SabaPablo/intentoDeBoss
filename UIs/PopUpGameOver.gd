extends Node

func _ready():
	pass


func _on_Start_pressed():
	#get_tree().get_nodes_in_group("sfx")[0].get_node("clic").play()
	get_tree().change_scene("res://world.tscn")


func _on_Quit_pressed():
	#get_tree().get_nodes_in_group("sfx")[0].get_node("clic").play()
	get_tree().quit()


#func _on_Button_pressed():
#	$PopupDialog.popup_centered()
