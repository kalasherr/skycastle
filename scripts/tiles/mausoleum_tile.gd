extends Tile

class_name MausoleumTile 

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/mausoleum.png")
	if tile_moves.find(Vector2(1,0)) != -1:
		rot = deg_to_rad(90)
	return [sprite,rot]

func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]

func destroy(flag = ""):
	if !is_destroying:
		if tile_coords.x < 0 or tile_coords.y < 0 or tile_coords.x >= G.GS.board_size.x or tile_coords.y >= G.GS.board_size.y:
			var to_pick = []
			for tile in get_parent().get_children():
				if tile.get_node("Effects").get_children() == [] and tile != self and tile.tile_in_deck and tile.tile_moves.size() > 0:
					to_pick.append(tile)
			for i in range(0, min(3, to_pick.size() - 1)):
				var tile = to_pick.pick_random()
				to_pick.pop_at(to_pick.find(tile))
				tile.add_effect("spikes", true)
				tile.tile_in_deck.add_effect("spikes")
		is_destroying = true
		var destroy_player = false
		if G.player:
			if G.player.player_coords == tile_coords:
				destroy_player = true
		while scale.x > 0:
			scale -= Vector2(0.05, 0.05) * 60 * get_process_delta_time()
			if G.player:
				if destroy_player:
					if G.player.scale.x > 0:
						G.player.scale -= Vector2(0.05, 0.05) * 60 * get_process_delta_time()
			await get_tree().process_frame
		if destroy_player and flag != "leave_player" and !G.GS.restarting:
			G.GS.restart_game()
		queue_free()
