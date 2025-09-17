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
		G.GS.camera.hud_next_tile.add_child(node)
		node.global_position = G.player.global_position
		
		var launched = false
		T.tween(node, "global_position", next_tile.global_position, 0.6, f)
		T.tween(node, "scale", Vector2(1,1), 0.6)
	
		await get_tree().create_timer(0.2).timeout
		if !launched:
			playing = false
			if queue != []:
				play(queue[0][0], queue[0][1])
				queue.pop_front()

		await get_tree().create_timer(0.4).timeout
		node.queue_free()
		if queue == []:
			return
	else:
		queue.append([sprite,sender])
		

func play_sprite():
	pass
