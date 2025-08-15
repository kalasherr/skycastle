extends Tile

class_name RitualRoomTile

var smokes = []

func post_init():
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			var smoke = RitualSmoke.new()
			smoke.coords = tile_coords + Vector2(i,j)
			smoke.rel_coords = Vector2(i,j)
			G.GS.get_node("MapEffects").add_child(smoke)
			smokes.append(smoke)
			if abs((tile_coords + Vector2(i,j) - G.player.player_coords).x) > 1 and abs((tile_coords + Vector2(i,j) - G.player.player_coords).y) > 1:
				smoke.init()
	G.player.connect("player_moved", refresh_smokes)
	G.GS.connect("next_move", refresh_smokes)
	connect("moved", refresh_smokes)
	G.GS.connect("ready_to_play", refresh_smokes)

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/ritual_room.png")
	return [sprite,rot]

func get_spawn_priority():
	return 1

func refresh_smokes():
	for smoke in smokes:
		smoke.coords = tile_coords + smoke.rel_coords
		if ((smoke.coords.x >= 0) and (smoke.coords.y >= 0) and (smoke.coords.x < G.GS.board_size.x) and (smoke.coords.y < G.GS.board_size.y)):
			if (abs((smoke.coords - G.player.player_coords).x) > 1 or abs((smoke.coords - G.player.player_coords).y) > 1):
				smoke.show_smoke()
			else:
				smoke.hide_smoke()
		else:
			smoke.hide_smoke()
