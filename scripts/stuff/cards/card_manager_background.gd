extends Node2D

class_name CardManagerBackground

@onready var light = get_node("PointLight2D")
var time = 0.0
var inited = false
var destroy_time = 0.2

func _process(delta):
	if inited:
		time += delta
		light.energy = (sin(time * 2) + 1) / 2

func destroy():
	inited = false
	var curr_light = light.energy
	var init_time = destroy_time
	var curr_time = 0.0
	var curr_modulate = modulate[3]
	while curr_time < init_time:
		curr_time += get_process_delta_time() * G.animation_time_scale
		light.energy = curr_light * (1 - curr_time / init_time)
		modulate[3] = curr_modulate * (1 - curr_time / init_time)
		await get_tree().process_frame
	queue_free()