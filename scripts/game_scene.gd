extends Node2D

var board_size = Vector2(4,4)
var tile_deck = []
var current_deck = []
var game_phase = "tile"
var player

@onready var tile_moves = get_node("TileMoves")
@onready var camera = get_node("Camera")

func _ready():
	camera.position = G.tile_size * board_size / 2 - G.tile_size / 2
	
	G.GS = self
	fill_deck()
	generate_field()
	
	await disable_buttons()
	
	add_player()
	
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
	current_deck = tile_deck.duplicate()
	var deck_to_pick = current_deck
	
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
	if game_phase == "player":
		await disable_buttons()
		await get_player_moves()
		game_phase = "tile"
	else:
		await disable_buttons()
		for i in [-1, board_size.x]:
			for j in range(0, board_size.y):
				create_tile_move(Vector2(i,j))
		for j in [-1, board_size.y]:
			for i in range(0, board_size.x):
				create_tile_move(Vector2(i,j))
		await get_tile_moves()
		game_phase = "player"
		

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

func get_tile_moves():
	var tiles = []
	
func create_tile_move(coords):
	var move = TileMove.new()
	move.tile_coords = coords
	move.position = coords * G.tile_size - G.tile_size / 2
	move.texture_click_mask = load("res://sprites/tiles/tile_bitmap.png")
	move.texture_normal = load("res://sprites/tiles/tile_focus.png")
	move.connect("pressed", tile_move)
	tile_moves.add_child(move)

func tile_move():
	var tile
	for move in tile_moves.get_children():
		var coords
		if move.is_hovered():
			if move.tile_coords.x < 0:
				get_tile(Vector2(0,move.tile_coords.y)).move(Vector2(1,move.tile_coords.y))
				coords = Vector2(0,move.tile_coords.y)
			elif move.tile_coords.y < 0:
				get_tile(Vector2(move.tile_coords.x,0)).move(Vector2(move.tile_coords.x,1))
				coords = Vector2(move.tile_coords.x,0)
			elif move.tile_coords.x >= board_size.x:
				get_tile(Vector2(board_size.x - 1,move.tile_coords.y)).move(Vector2(board_size.x - 2,move.tile_coords.y))
				coords = Vector2(board_size.x - 1,move.tile_coords.y)
			elif move.tile_coords.y >= board_size.y:
				get_tile(Vector2(move.tile_coords.x,board_size.y - 1)).move(Vector2(move.tile_coords.x,board_size.x - 2))
				coords = Vector2(move.tile_coords.x, board_size.y - 1)
		if coords:
			tile = current_deck[0]
			current_deck.pop_front()
			get_node("TileManager").add_child(tile)
			tile.tile_coords = coords
			tile.init()
			break
	tile = current_deck[0]
	for move in tile_moves.get_children():
		move.queue_free()
	match tile.tile_moves.size():
		1: 
			get_node("Camera/NextTile").texture = load("res://sprites/tiles/basic_dead_end.png")
			match tile.tile_moves[0]:
				Vector2(-1,0):
					get_node("Camera/NextTile").rotation = deg_to_rad(90)
				Vector2(1,0):
					get_node("Camera/NextTile").rotation = deg_to_rad(-90)
				Vector2(0,-1):
					get_node("Camera/NextTile").rotation = deg_to_rad(180)
		2:
			if tile.tile_moves[0] + tile.tile_moves[1] == Vector2.ZERO:
				get_node("Camera/NextTile").texture = load("res://sprites/tiles/basic_i.png")
				if tile.tile_moves.find(Vector2(1,0)) != -1:
					get_node("Camera/NextTile").rotation = deg_to_rad(90)
			else:
				get_node("Camera/NextTile").texture = load("res://sprites/tiles/basic_r.png")
				if tile.tile_moves.find(Vector2(-1,0)) != -1 and tile.tile_moves.find(Vector2(0,1)) != -1:
					get_node("Camera/NextTile").rotation = deg_to_rad(90)
				elif tile.tile_moves.find(Vector2(0,-1)) != -1 and tile.tile_moves.find(Vector2(-1,0)) != -1:
					get_node("Camera/NextTile").rotation = deg_to_rad(180)
				elif tile.tile_moves.find(Vector2(1,0)) != -1 and tile.tile_moves.find(Vector2(0,-1)) != -1:
					get_node("Camera/NextTile").rotation = deg_to_rad(-90)
		3:
			get_node("Camera/NextTile").texture = load("res://sprites/tiles/basic_t.png")
			if tile.tile_moves.find(Vector2(1,0)) == -1:
				get_node("Camera/NextTile").rotation = deg_to_rad(90)
			elif tile.tile_moves.find(Vector2(-1,0)) == -1:
				get_node("Camera/NextTile").rotation = deg_to_rad(-90)
			elif tile.tile_moves.find(Vector2(0,1)) == -1:
				get_node("Camera/NextTile").rotation = deg_to_rad(180)
		4:
			get_node("Camera/NextTile").texture = load("res://sprites/tiles/basic_crossroad.png")

	next_turn()
