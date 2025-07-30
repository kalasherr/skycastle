extends Sprite2D

class_name Arrow

var time = 0
var shift = Vector2.ZERO
var begin_pos 
func _process(delta):
	if !begin_pos:
		begin_pos = position
	time += get_process_delta_time()
	position = begin_pos - sin(time * 2) * 6 * shift