extends Tile

class_name GunpowderStorageTile

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/gunpowder_storage.png")
	return [sprite,rot]

func destroy(flag = ""):
	if !is_destroying:
		is_destroying = true
		if !G.GS.stage_transfer:
			for i in [-1,0,1]:
				for j in [-1,0,1]:
					if G.GS.get_tile(tile_coords + Vector2(i,j)):
						var found = false
						for effect in G.GS.get_tile(tile_coords + Vector2(i,j)).get_node("Effects").get_children():
							if effect is CrownEffect:
								found = true
						if !found and !G.GS.get_tile(tile_coords + Vector2(i,j)).is_destroying:
							G.GS.get_tile(tile_coords + Vector2(i,j)).destroy()
		
		var destroy_player = false
		if G.player:
			if G.player.player_coords == tile_coords:
				destroy_player = true
		while scale.x > 0:
			scale -= Vector2(0.05, 0.05) * 60 * get_process_delta_time() * G.animation_time_scale
			if G.player:
				if destroy_player:
					if G.player.scale.x > 0:
						G.player.scale -= Vector2(0.05, 0.05) * 60 * get_process_delta_time() * G.animation_time_scale
			await get_tree().process_frame
		if destroy_player and flag != "leave_player" and !G.GS.restarting:
			G.GS.restart_game()
		
		queue_free()
