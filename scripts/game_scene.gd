extends Node2D

var board_size = Vector2(6,6)
var tile_deck = []
var game_phase = "tile"
var player

func _ready():
	G.GS = self
	fill_deck()
	generate_field()
	
	await disable_buttons()
	
	add_player(Vector2(5,5))
	
	next_turn()

func disable_buttons():
	for tile in get_node("TileManager").get_children():
		tile.disable()
	return

func add_player(coords = board_size - Vector2(1,1)):
	var player = load("res://scenes/player_entity.tscn").instantiate()
	add_child(player)
	player.init(coords)
	
func generate_field():
	var deck_to_pick = tile_deck.duplicate()
	
	var start_tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
	start_tile.tile_moves = [Vector2(-1,0), Vector2(0,-1)]
	get_node("TileManager").add_child(start_tile)
	deck_to_pick.pop_at(deck_to_pick.find(start_tile))
	start_tile.tile_coords = Vector2(board_size.x-1, board_size.y-1)
	start_tile.init()
	
	
	var second_tile = deck_to_pick.pick_random()
	while true:
		deck_to_pick.shuffle()
		second_tile = deck_to_pick.pick_random()
		if second_tile.tile_moves.find(Vector2(1,0)) != -1:
			break
	get_node("TileManager").add_child(second_tile)
	deck_to_pick.pop_at(deck_to_pick.find(second_tile))
	second_tile.tile_coords = Vector2(board_size.x-2, board_size.y-1)
	second_tile.init()
	
	
	second_tile = deck_to_pick.pick_random()
	while true:
		deck_to_pick.shuffle()
		second_tile = deck_to_pick.pick_random()
		if second_tile.tile_moves.find(Vector2(0,1)) != -1:
			break
	get_node("TileManager").add_child(second_tile)
	deck_to_pick.pop_at(deck_to_pick.find(second_tile))
	second_tile.tile_coords = Vector2(board_size.x-1, board_size.y-2)
	second_tile.init()
	
	second_tile = deck_to_pick.pick_random()
	while true:
		deck_to_pick.shuffle()
		second_tile = deck_to_pick.pick_random()
		if second_tile.tile_moves.find(Vector2(0,1)) != -1:
			break
	get_node("TileManager").add_child(second_tile)
	deck_to_pick.pop_at(deck_to_pick.find(second_tile))
	second_tile.tile_coords = Vector2(board_size.x-1, board_size.y-2)
	second_tile.init()

	var end_tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
	end_tile.tile_moves = [Vector2(-1,0), Vector2(0,-1), Vector2(1,0), Vector2(0,1)]
	get_node("TileManager").add_child(end_tile)
	end_tile.tile_coords = Vector2(0, 0)
	end_tile.init()
	end_tile.add_effect("crown")

	for i in range (0,board_size.x):
		for j in range (0,board_size.y):
			if check_availability(Vector2(i,j)):
				var tile = deck_to_pick.pick_random()
				deck_to_pick.pop_at(deck_to_pick.find(tile))
				get_node("TileManager").add_child(tile)
				tile.tile_coords = Vector2(i,j)
				tile.init()
				
func fill_deck():
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,3):
			moves.shuffle()
			moves.pop_front()
		var tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
		tile.tile_moves = moves
		tile_deck.append(tile)
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,2):
			moves.shuffle()
			moves.pop_front()
		var tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
		tile.tile_moves = moves
		tile_deck.append(tile)
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,1):
			moves.shuffle()
			moves.pop_front()
		var tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
		tile.tile_moves = moves
		tile_deck.append(tile)
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,0):
			moves.shuffle()
			moves.pop_front()
		var tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
		tile.tile_moves = moves
		tile_deck.append(tile)

func randomize_exits():
	pass

func check_availability(coords):
	for tile in get_node("TileManager").get_children():
		if tile.tile_coords == coords:
			return false
	return true

func button_pressed(tile):
	await player.move(tile)
	next_turn()

func next_turn():
	await disable_buttons()
	game_phase = "player"
	await get_player_moves()
	get_tile(Vector2(5,4)).visible = true

func get_tile(coords):
	for tile in get_node("TileManager").get_children():
		if tile.tile_coords == coords:
			return tile
	return false

func get_player_moves():
	var tile = get_tile(player.player_coords)
	var moves = []
	for move in tile.tile_moves:
		if get_tile(tile.tile_coords + move):
			if get_tile(tile.tile_coords + move).tile_moves.has(-move):
				moves.append(get_tile(tile.tile_coords + move))
	for move in moves:
		move.able()
	
	return
