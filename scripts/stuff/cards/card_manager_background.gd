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

	T.tween(light, "energy", 0, destroy_time)
	await T.tween(self, "modulate", Color(1,1,1,0), destroy_time)
	
	queue_free()