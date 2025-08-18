extends ColorRect

class_name Background

var max_stage = 4
var default_modulate = Color(1,1,1,1)
var max_modulate = Color(0,0,35.0 / 255.0, 1)

func get_next_stage_modulate():
	if G.GS.board_size.x + G.GS.board_size.y - 8 < max_stage:
		var to_return = Color(0,0,0,0)
		for i in range(0,4):
			to_return[i] = max_modulate[i] * (G.GS.board_size.x + G.GS.board_size.y - 8) / max_stage + default_modulate[i] * (1.0 - (G.GS.board_size.x + G.GS.board_size.y - 8) / max_stage)
		return to_return
	else:
		return max_modulate

func reset():
	var init_time = 1.0
	var curr_time = 0.0
	var start_point = modulate
	while curr_time < init_time:
		curr_time += get_process_delta_time()
		for i in range(0,4):
			modulate[i] = start_point[i] * (1 - curr_time / init_time) + default_modulate[i] * curr_time / init_time
		await get_tree().process_frame
