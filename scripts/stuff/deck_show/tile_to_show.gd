extends Node2D

class_name TileToShow

var final_position = Vector2(0,0)
var moving = false
var button_shift = Vector2(0,0)
var hover_shift = Vector2(0,-40)

func init():
	var f = func(x):
		return - ((x - 1.0) ** 2) + 1.0
	var init_position = position
	var init_time = 0.4
	var curr_time = 0.0
	moving = true
	while curr_time < init_time:
		position.x = init_position.x * (1.0 -f.call( curr_time / init_time)) + final_position.x * f.call(curr_time / init_time)
		curr_time += get_process_delta_time()
		await get_tree().process_frame
	moving = false
	position = final_position

func _process(delta):
	if get_node("Button").is_hovered():
		self.position = final_position + hover_shift
		get_node("Button").position = -hover_shift + button_shift - G.tile_size / 2
	elif !moving:
		self.position = final_position
		get_node("Button").position = button_shift - G.tile_size / 2

func destroy():
	queue_free()