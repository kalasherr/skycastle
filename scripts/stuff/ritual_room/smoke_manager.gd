extends Node2D

class_name SmokeManager

func _ready():
	get_parent().get_parent().connect("ready_to_play", init)
	

func init():
	G.GS.connect("next_move", refresh_smokes)

func refresh_smokes():
	print("refresh")
	var smoke_coords = []
	if G.player.player_coords != Vector2(0,0):
		for tile in G.GS.get_node("TileManager").get_children():
			if tile is RitualRoomTile:
				for i in [-1,0,1]:
					for j in [-1,0,1]:
						if smoke_coords.find(tile.tile_coords + Vector2(i,j)) == -1:
							smoke_coords.append(tile.tile_coords + Vector2(i,j))
		for smoke in get_children():
			var diff = G.player.player_coords - smoke.coords
			if smoke_coords.find(smoke.coords) == -1 or (abs(diff.x) < 2 and abs(diff.y) < 2):
				smoke.destroy()
		for smoke in smoke_coords:
			var diff = G.player.player_coords - smoke
			if abs(diff.x) >= 2 or abs(diff.y) >= 2:
				add_smoke(smoke)
	else:
		destroy_all_smokes()

func destroy_all_smokes():
	for smoke in get_children():
		smoke.destroy()

func add_smoke(coords):
	var place = true
	for smoke in get_children():
		if smoke.coords == coords:
			place = false
		var diff = G.player.player_coords - coords
		if abs(diff.x) < 2 and abs(diff.y) < 2:
			place = false
		if !(coords.x >= 0 and coords.y >= 0 and coords.x < G.GS.board_size.x and coords.y < G.GS.board_size.y):
			place = false
	if place:
		print(coords)
		var smoke = RitualSmoke.new()
		smoke.coords = coords
		add_child(smoke)
		smoke.init()
	
