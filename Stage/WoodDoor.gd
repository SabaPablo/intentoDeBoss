extends Node2D

export(String, FILE, "*.tscn") var next_lvl
var has_key = false
var box = preload("res://Items/signbox.tscn")
var instance_box

func _physics_process(delta):
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and has_key:
			$AnimationPlayer.play("Open")
		if body.name == "Player" and !has_key and instance_box == null:
			instance_box = box.instance()
			instance_box.position += Vector2(0,-70)
			instance_box.set_text("El ingreso a la mina esta cerrado, dejo la llave en la copa del arbol mas grande'")
			add_child(instance_box)
		if body.name != 'Player':
			instance_box = null;


func got_key():
	has_key = true


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(get_parent().next_lvl)
