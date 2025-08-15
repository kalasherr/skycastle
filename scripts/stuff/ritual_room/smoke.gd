extends Sprite2D

class_name RitualSmoke

var coords = Vector2(0,0)
var rel_coords = Vector2(0,0)

func _ready():
	self.z_index = 100
	self.position = coords * G.tile_size
	self.texture = load("res://sprites/effects/smoke_effect.png")
	self.modulate[3] = 0
	init()

func init():
	var init_time = 0.1
	var curr_time = 0.0
	while curr_time < init_time:
		self.modulate[3] = curr_time / init_time
		curr_time += get_process_delta_time()
		await get_tree().process_frame
	self.modulate[3] = 1
		
func destroy():
	var init_time = 1.0
	var curr_time = 0.0
	while curr_time < init_time:
		self.modulate[3] = 1 - curr_time / init_time
		curr_time += get_process_delta_time()
		await get_tree().process_frame
	self.modulate[3] = 0
	queue_free()

func hide_smoke():
	var init_time = 1.0
	var curr_time = 0.0
	while curr_time < init_time:
		self.modulate[3] = 1 - curr_time / init_time
		curr_time += get_process_delta_time()
		await get_tree().process_frame
	self.modulate[3] = 0

func show_smoke():
	var init_time = 1.0
	var curr_time = 0.0
	while curr_time < init_time:
		self.modulate[3] = curr_time / init_time
		curr_time += get_process_delta_time()
		await get_tree().process_frame
	self.modulate[3] = 1
