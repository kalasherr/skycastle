extends Node2D

var board_size = Vector2(4,4)
var tile_deck = []
var current_deck = []
var game_phase = "player"
var player
var stage_transfer = false
var focused = false
var focused_tile

@onready var tile_moves = get_node("TileMoves")
@onready var camera = get_node("Camera")

func _ready():
	camera.position = G.tile_size * board_size / 2 - G.tile_size / 2
	
	game_phase = "player"
	G.GS = self
	fill_deck()
	generate_field()
	
	await disable_buttons()
	
	add_player()
	
	next_turn()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		restart_game()

func disable_buttons():
	for tile in get_node("TileManager").get_children():
		tile.disable()
	for move in get_node("TileMoves").get_children():
		move.queue_free()
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
		current_deck[i].effects_to_add = tile_deck[i].effects_to_add
		
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
	end_tile.add_effect("crown")
	end_tile.init()
	

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
		tile.add_effect("spikes")
		



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
	var tile
	if current_deck.size() > 0:
		tile = current_deck[0]
		update_next_tile(tile.get_sprite()[0], tile.get_sprite()[1])
	else:
		camera.get_node("NextTile").texture = null
		camera.get_node("DeckLeft").text = str(0)
		restart_game()
	
	

	if !stage_transfer:
		if game_phase == "player":
			await disable_buttons()
			await get_player_moves()
			G.GS.light_off_tiles()
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
			G.GS.light_off_tiles()
			game_phase = "player"
		
func update_next_tile(texture, texture_rotation):
	get_node("Camera/NextTile").texture = texture
	get_node("Camera/NextTile").rotation = texture_rotation
	get_node("Camera/DeckLeft").text = str(current_deck.size())

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
			if get_tile(tile.tile_coords + move).tile_moves.has(-move) and !get_tile(tile.tile_coords + move).is_destroying:
				moves.append(get_tile(tile.tile_coords + move))
	if moves != []:
		for move in moves:
			move.able()
	else:
		restart_game()
	
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
	light_off_tiles()
	for move in tile_moves.get_children():
		move.modulate[3] = 0
		move.disconnect("pressed", tile_move)
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
			disable_buttons()
			if move.tile_coords.x < 0:
				await tile.move(tile.tile_coords + Vector2(1,0))
			elif move.tile_coords.y < 0:
				await tile.move(tile.tile_coords + Vector2(0,1))
			elif move.tile_coords.x >= board_size.x:
				await tile.move(tile.tile_coords + Vector2(-1,0))
			elif move.tile_coords.y >= board_size.y:
				await tile.move(tile.tile_coords + Vector2(0,-1))
			break
	if current_deck.size() > 0:
		tile = current_deck[0]
	else:
		camera.get_node("NextTile").texture = null
		camera.get_node("DeckLeft").text = str(0)
		restart_game()
	for move in tile_moves.get_children():
		move.queue_free()

	await next_turn()

func next_stage():
	stage_transfer = true
	disable_buttons()
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
	var curr_time = 0.0
	var old_pos = start_tile.position
	var new_pos = (board_size - Vector2(1,1)) * G.tile_size
	var old_camera_pos = camera.position
	var new_camera_pos = G.tile_size * board_size / 2 - G.tile_size / 2
	
	var graph = func(curr):
		#if curr < 1.0:
			#return (4 * (curr/init_time - 0.25)) ** 2 - 1
		#else:
			#return 2 * (1 - pow(4, -(curr/init_time - 0.5)))
			
		if curr < 0.4:
			return 0.75 * (((curr/init_time - 0.1) ** 2) * 10.0 - 0.1)
		else:
			return - ((curr/init_time - 1) ** 2) * 1.25 * 1.25 + 1

# 		return (sin(curr/init_time * PI / 2) ** 3)

	while curr_time < init_time:
		print(graph.call(curr_time))
		start_tile.replace(graph.call(curr_time) * new_pos + (1 - graph.call(curr_time)) * old_pos)
		camera.position = graph.call(curr_time) * new_camera_pos + (1 - graph.call(curr_time)) * old_camera_pos
		player.replace(graph.call(curr_time) * new_pos + (1 - graph.call(curr_time)) * old_pos + start_tile.get_player_offset())
		curr_time += get_process_delta_time()
		await get_tree().process_frame
	start_tile.replace(new_pos)
	camera.position = new_camera_pos
	player.replace(new_pos + start_tile.get_player_offset())
	
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
	
func light_up_tiles(coords_arr, color = "premove"):
	for coords in coords_arr:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://sprites/tiles/tile_" + color + ".png")
		sprite.name = "Focus"
		get_tile(coords).get_node("SpriteTree/Focus").add_child(sprite)

func light_off_tiles():
	for tile in get_node("TileManager").get_children():
		for sprite in tile.get_node("SpriteTree").get_children():
			if sprite.name == "Focus":
				for child in sprite.get_children():
					child.queue_free()

func restart_game():
	await disable_buttons()
	if player:
		player.queue_free()
	print("Board size: ", board_size)
	await destroy_all_tiles()
	board_size = Vector2(4,4)
	_ready()

func destroy_all_tiles():
	tile_deck = []
	current_deck = []
	game_phase = "tile"
	player = null
	stage_transfer = false
	focused = false
	focused_tile = null
	for i in range(0, board_size.x + board_size.y - 1):
		for tile in get_node("TileManager").get_children():
			if tile.tile_coords.x + tile.tile_coords.y == i:
				print("Deleted: ", tile.tile_coords)
				tile.destroy()
		await get_tree().create_timer(0.05).timeout
	while get_node("TileManager").get_children().size() != 0:
		await get_tree().process_frame
	return
