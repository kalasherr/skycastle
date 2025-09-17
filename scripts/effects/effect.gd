extends Node2D

class_name TileEffect

@onready var bound_tile = get_parent().get_parent()

func on_enter():
	pass
	
func get_effect_name():
	return "none"

func get_sprite():
	return load("res://sprites/effects/" + get_effect_name() + "_effect.png")

func destroy():
	var duration = 1.0
	var curr_time = 0.0
	while curr_time < duration:
		await get_tree().process_frame
		if int(curr_time * 10) % 2 == 0:
			modulate[3] = 0
		else:
			modulate[3] = 1
		curr_time += get_process_delta_time() * G.animation_time_scale
		position.y -= 20.0 * get_process_delta_time() * G.animation_time_scale
	queue_free()