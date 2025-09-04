extends TileEffect

class_name CoinEffect

func on_enter():
	if G.player.update_money(1):
		for effect in bound_tile.tile_in_deck.effects_to_add:
			if effect == "coin":
				bound_tile.tile_in_deck.effects_to_add.pop_at(bound_tile.tile_in_deck.effects_to_add.find(effect))
	G.GS.tile_deck.pop_at(G.GS.tile_deck.find(bound_tile.tile_in_deck))
	bound_tile.tile_in_deck.queue_free()
	destroy()
	

func get_effect_name():
	return "coin"

func destroy():
	var init_time = 1.0
	var curr_time = 0.0
	while curr_time < init_time:
		if int(curr_time * 10) % 2 == 0:
			modulate[3] = 0
		else:
			modulate[3] = 1
		curr_time += get_process_delta_time() * G.animation_time_scale
		position.y -= 20.0 * get_process_delta_time() * G.animation_time_scale
		await get_tree().process_frame
	queue_free()