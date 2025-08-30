extends Tile

class_name RitualRoomTile

var smokes = []

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/ritual_room.png")
	return [sprite,rot]

func get_spawn_priority():
	return 1

func destroy(flag = ""):
	if !is_destroying:
		self.tile_coords = Vector2(10000,10000)
		is_destroying = true
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
		G.GS.get_node("Stuff/SmokeManager").refresh_smokes()
