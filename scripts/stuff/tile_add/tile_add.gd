extends Node2D

class_name TileAdd

var playing = false
var queue = []

signal play_next

func play(sprite, sender = null):
	if !playing:
		var f = func(x):
			return (((x * 3.0 - 1.0) ** 2.0) - 1) / 3
		var next_tile = G.GS.camera.hud_next_tile
		playing = true
		var node = Sprite2D.new()
		node.scale = 0.3 * Vector2(1,1)
		node.z_index = -1
		node.modulate[3] = 1
		node.texture = sprite
		node.global_position = G.player.global_position
		G.GS.camera.hud_next_tile.add_child(node)
		var start_position = G.player.global_position
		var final_position = next_tile.global_position + Vector2(0,0)
		var init_time = 0.6
		var curr_time = 0.0
		var threshold_time = 0.2
		var launched = false
		while curr_time < init_time:
			curr_time += get_process_delta_time() * G.animation_time_scale
			node.scale = (0.3 + ((curr_time / init_time) * 0.7)) * Vector2(1,1)
			if curr_time < init_time:
				node.global_position = f.call(curr_time / init_time) * final_position + f.call(1 - curr_time / init_time) * start_position
			else:
				node.global_position = final_position
			if curr_time > threshold_time and !launched:
				playing = false
				launched = true
				if queue != []:
					play(queue[0][0], queue[0][1])
					queue.pop_front()
			await get_tree().process_frame
		node.queue_free()
		if queue == []:
			return
	else:
		queue.append([sprite,sender])
		

func play_sprite():
	pass
