extends Node2D

var board_size = Vector2(4,4)
var tile_deck = []
var current_deck = []
var game_phase = "tile"
var player
var stage_transfer = false

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
	var player_scene = load("res://scenes/player_entity.tscn").instantiate()
	add_child(player_scene)
	player_scene.init(coords)
	
func generate_field():
	current_deck = []
	
	for i in range(0, tile_deck.size()):
		current_deck.append(tile_deck[i].duplicate())
		current_deck[i].tile_moves = tile_deck[i].tile_moves
		
	var deck_to_pick = current_deck
	
	if !get_tile(board_size - Vector2(1,1)):
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
	var tile = current_deck[0]
	get_node("Camera/NextTile").texture = tile.get_sprite()[0]
	get_node("Camera/NextTile").rotation = tile.get_sprite()[1]
	if !stage_transfer:
		if game_phase == "player":
			await disable_buttons()
			await get_player_moves()
			game_phase = "tile"
		else:
			await disable_buttons()
			for i in [-1, board_size.x]:
				for j in range(1, board_size.y):
					create_tile_move(Vector2(i,j))
			for j in [-1, board_size.y]:
				for i in range(1, board_size.x):
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
				coords = Vector2(-1,move.tile_coords.y)
			elif move.tile_coords.y < 0:
				coords = Vector2(move.tile_coords.x,-1)
			elif move.tile_coords.x >= board_size.x:
				coords = Vector2(board_size.x,move.tile_coords.y)
			elif move.tile_coords.y >= board_size.y:
				coords = Vector2(move.tile_coords.x, board_size.y)
		if coords:
			tile = current_deck[0]
			current_deck.pop_front()
			get_node("TileManager").add_child(tile)
			tile.tile_coords = coords
			tile.init()
			if move.tile_coords.x < 0:
				await tile.move(tile.tile_coords + Vector2(1,0))
			elif move.tile_coords.y < 0:
				await tile.move(tile.tile_coords + Vector2(0,1))
			elif move.tile_coords.x >= board_size.x:
				await tile.move(tile.tile_coords + Vector2(-1,0))
			elif move.tile_coords.y >= board_size.y:
				await tile.move(tile.tile_coords + Vector2(0,-1))
			break
	tile = current_deck[0]
	for move in tile_moves.get_children():
		move.queue_free()

	await next_turn()

func next_stage():
	stage_transfer = true

	for move in get_node("TileMoves").get_children():
		move.queue_free()
		
	for i in range(0,board_size.x):
		for j in range(0,board_size.y):
			if i != board_size.x - 1 or j != board_size.y - 1:
				if get_tile(Vector2(board_size.x - i - 1,board_size.y - j - 1)):
					get_tile(Vector2(board_size.x - i - 1,board_size.y - j - 1)).destroy()
				if get_tile(Vector2(board_size.y - j - 1,board_size.x - i - 1)):
					get_tile(Vector2(board_size.y - j - 1,board_size.x - i - 1)).destroy()
				await get_tree().create_timer(0.1).timeout
				
	var start_tile = get_tile(player.player_coords)
	
	if board_size.x > board_size.y:
		board_size.y += 1
	else:
		board_size.x += 1
	
	var init_time = 2.0
	var curr_time = init_time
	var old_pos = start_tile.position
	var new_pos = (board_size - Vector2(1,1)) * G.tile_size
	var old_camera_pos = camera.position
	var new_camera_pos = G.tile_size * board_size / 2 - G.tile_size / 2
	
	while curr_time > 0:
		start_tile.position = (1 - curr_time / init_time) * new_pos + curr_time / init_time * old_pos
		camera.position = (1 - curr_time / init_time) * new_camera_pos + curr_time / init_time * old_camera_pos
		player.position = (1 - curr_time / init_time) * new_pos + curr_time / init_time * old_pos + Vector2(0,1)
		curr_time -= get_process_delta_time()
		await get_tree().process_frame
	start_tile.tile_coords = board_size - Vector2(1,1)
	player.player_coords = board_size - Vector2(1,1)
	start_tile.position = new_pos
	
	generate_field()
	await disable_buttons()
	game_phase = "player"
	
	
	stage_transfer = false
	next_turn()

func change_hp(amount):
	print("Current hp: ", amount)
	
