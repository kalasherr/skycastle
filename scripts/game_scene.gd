extends Node2D

var board_size = Vector2(4,4)
var tile_deck = []
var current_deck = []
var game_phase = "player"
var player
var stage_transfer = false
var focused = false
var focused_tile
var restarting = false
var generating = false

@onready var tile_moves = get_node("TileMoves")
@onready var camera = get_node("Camera")
@onready var card_manager = camera.get_node("CardManager")

func _ready():
	card_manager.init()
	camera.position = G.tile_size * board_size / 2 - G.tile_size / 2
	
	game_phase = "player"
	G.GS = self
	fill_deck()
	generating = true
	await generate_field()
	
	await disable_buttons()
	
	add_player()
	generating = false
	change_hp(player.hp)
	next_turn()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		restart_game("forced")
	if Input.is_action_just_pressed("ui_cancel"):
		show_all_deck()

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
		current_deck[i].tile_in_deck = tile_deck[i]
	
	if !get_tile(board_size - Vector2(1,1)):
		var start_tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
		start_tile.tile_moves = [Vector2(-1,0), Vector2(0,-1)]
		get_node("TileManager").add_child(start_tile)
		start_tile.tile_coords = Vector2(board_size.x-1, board_size.y-1)
		start_tile.init()
	
	await get_tree().create_timer(0.1).timeout
	
	var end_tile = load("res://scenes/tiles/basic_tile.tscn").instantiate()
	end_tile.tile_moves = [Vector2(-1,0), Vector2(0,-1), Vector2(1,0), Vector2(0,1)]
	get_node("TileManager").add_child(end_tile)
	end_tile.tile_coords = Vector2(0, 0)
	end_tile.add_effect("crown")
	end_tile.init()
	
	await get_tree().create_timer(0.1).timeout
		
	var second_tile = current_deck.pick_random()
	while true:
		current_deck.shuffle()
		rotate_deck(current_deck)
		second_tile = current_deck.pick_random()
		if second_tile.tile_moves.find(Vector2(1,0)) != -1:
			break

	get_node("TileManager").add_child(second_tile)
	current_deck.pop_at(current_deck.find(second_tile))
	second_tile.tile_coords = Vector2(board_size.x-2, board_size.y-1)
	second_tile.init()
	
	second_tile = current_deck.pick_random()
	while true:
		current_deck.shuffle()
		second_tile = current_deck.pick_random()
		if second_tile.tile_moves.find(Vector2(0,1)) != -1:
			break
	get_node("TileManager").add_child(second_tile)
	current_deck.pop_at(current_deck.find(second_tile))
	second_tile.tile_coords = Vector2(board_size.x-1, board_size.y-2)
	second_tile.init()
	
	await get_tree().create_timer(0.1).timeout

	for i in range (0,board_size.x + board_size.y):
		var i1 = board_size.x + board_size.y - 1 - i
		var found = false
		for j in range (0,board_size.x + board_size.y):
			var j1 = board_size.x + board_size.y - 1 - j
			if check_availability(Vector2(i1 - j1, j1)):
				found = true
				var tile = current_deck.pick_random()
				current_deck.pop_at(current_deck.find(tile))
				get_node("TileManager").add_child(tile)
				tile.tile_coords = Vector2(i1 - j1, j1)
				tile.init()
		if found:
			await get_tree().create_timer(0.1).timeout
	return

				
func fill_deck():
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,3):
			moves.shuffle()
			moves.pop_front()
		var tile = BasicTile.new()
		tile.tile_moves = moves
		tile_deck.append(tile)
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,2):
			moves.shuffle()
			moves.pop_front()
		var tile = BasicTile.new()
		tile.tile_moves = moves
		tile_deck.append(tile)
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,1):
			moves.shuffle()
			moves.pop_front()
		var tile = BasicTile.new()
		tile.tile_moves = moves
		tile_deck.append(tile)
		tile.add_effect("bandage")
	for i in range (0,10):
		var moves = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		for j in range(0,0):
			moves.shuffle()
			moves.pop_front()
		var tile = BasicTile.new()
		tile.tile_moves = moves
		tile_deck.append(tile)
# 		tile.add_effect("spikes")
	for i in range(0,2):
		var tile = BellTile.new()
		tile.tile_moves = get_tile_moves(tile)
		tile_deck.append(tile)
	for i in range(0,2):
		var tile = BankTile.new()
		tile.tile_moves = get_tile_moves(tile)
		tile_deck.append(tile)
	for i in range(0,2):
		var tile = MausoleumTile.new()
		tile.tile_moves = get_tile_moves(tile)
		tile_deck.append(tile)
	for i in range(0,20):
		var tile = FireplaceTile.new()
		tile.tile_moves = get_tile_moves(tile)
		tile_deck.append(tile)
		
	rotate_deck(tile_deck)

func get_tile_moves(tile):
	if tile is BankTile:
		return G.rotate_array([Vector2(1,0)], 90 * (round(randf_range(0,4) - 0.5)))
	elif tile is BellTile:
		return G.rotate_array([Vector2(1,0)], 90 * (round(randf_range(0,4) - 0.5)))
	elif tile is CrownTile:
		return [Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1)]
	elif tile is FireplaceTile:
		var moves = G.rotate_array([Vector2(1,0),Vector2(0,1)], 90 * (round(randf_range(0,4) - 0.5)))
		return moves
	elif tile is MausoleumTile:
		return  G.rotate_array([Vector2(1,0),Vector2(-1,0)], 90 * (round(randf_range(0,4) - 0.5)))
	elif tile is StoneTile:
		return []
	elif tile is WeaponryTile:
		return  G.rotate_array([Vector2(1,0),Vector2(-1,0)], 90 * round(randf_range(0,4) - 0.5))

func rotate_deck(deck):
	for tile in deck:
		var rot = round(randf_range(-0.5, 3.5))
		rot *= 90
		for move in tile.tile_moves:
			move = move.rotated(deg_to_rad(rot))


func randomize_exits():
	pass

func check_availability(coords):
	for tile in get_node("TileManager").get_children():
		if get_tile(coords):
			return false
		if coords.x < 0 or coords.y < 0 or coords.x >= board_size.x or coords.y >= board_size.y:
			return false
	return true

func button_pressed(tile):
	await player.move(tile)
	next_turn()

func next_turn(flag = "none"):
	var tile
	if current_deck.size() > 0:
		tile = current_deck[0]
		if tile:
			var effects = []
			for effect in tile.effects_to_add:
				effects.append(load("res://sprites/effects/" + effect + "_effect.png"))
			update_next_tile(tile.get_sprite()[0], tile.get_sprite()[1], effects)
	else:
		camera.get_node("NextTile").texture = null
		for effect in camera.get_node("NextTile/Effects").get_children():
			effect.queue_free()
		camera.get_node("DeckLeft").text = str(0)
		restart_game()
	
	

	if !stage_transfer and !restarting:
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
			G.GS.light_off_tiles()
			game_phase = "player"
		
func update_next_tile(texture, texture_rotation, effects = []):
	var next = get_node("Camera/NextTile")
	next.texture = texture
	next.rotation = texture_rotation
	for child in next.get_node("Effects").get_children():
		child.queue_free()
	for effect in effects:
		next.get_node("Effects").add_child(Sprite2D.new())
		next.get_node("Effects").get_child(next.get_node("Effects").get_children().size() - 1).rotation = - next.rotation
		next.get_node("Effects").get_child(next.get_node("Effects").get_children().size() - 1).texture = effect
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
	await destroy_all_tiles("leave_player")
				
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
# 		if curr < 1.0:
# 			return 8 * ((curr/init_time - 0.25) ** 2) - 0.5
# 		else:
# 			return - 4 * ((curr/init_time - 1) ** 2)  + 1

		#if curr < 1.0:
			#return (4 * (curr/init_time - 0.25)) ** 2 - 1
		#else:
			#return 2 * (1 - pow(4, -(curr/init_time - 0.5)))
			
		if curr < 0.4:
			return 0.75 * (((curr/init_time - 0.1) ** 2) * 10.0 - 0.1)
		else:
			return - ((curr/init_time - 1) ** 2) * 1.25 * 1.25 + 1

# 		return (sin(curr/init_time * PI / 2) ** 3)
	card_manager.call_cards()
	
	await card_manager.CardApplied
	
	while curr_time < init_time:
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
	
	await generate_field()
	await disable_buttons()
	game_phase = "player"
	stage_transfer = false
	change_shield(0)
	
	next_turn()

func change_hp(amount):
	camera.get_node("PlayerHP").text = str(player.hp) + "/" + str(player.max_hp)
	if player.hp == 0:
		restart_game()
	
func light_up_tiles(coords_arr, color = "premove"):
	if !restarting:
		for coords in coords_arr:
			if get_tile(coords):
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

func restart_game(flag = "none"):
	restarting = true
	await disable_buttons()
	if flag != "forced":	
		await destroy_all_tiles()
	else:
		await destroy_all_tiles("ignore_player")
	if player:
		player.queue_free()
	for card in camera.get_node("AppliedCards/Cards").get_children():
		card.queue_free()
	player = null
	tile_deck = []
	current_deck = []
	game_phase = "tile"
	stage_transfer = false
	focused = false
	focused_tile = null
	board_size = Vector2(4,4)
	restarting = false
	_ready()

func destroy_all_tiles(flag = "cascade", parameters = []):
	if flag == "cascade":
		for i in range(0, board_size.x + board_size.y):
			var found = false
			for tile in get_node("TileManager").get_children():
				var difference = tile.tile_coords
				if player:
					difference = Vector2(tile.tile_coords - player.player_coords)
				if abs(difference.x) + abs(difference.y) == board_size.x + board_size.y - i:
					tile.destroy()
					found = true
			if found:
				await get_tree().create_timer(0.2).timeout
		if get_tile(player.player_coords):
			await get_tree().create_timer(0.5).timeout
			await get_tile(player.player_coords).destroy("leave_player")
		while get_node("TileManager").get_children().size() != 0:
			await get_tree().process_frame
		return
	elif flag == "leave_player":
		var destroy = func():
			for i in range(0, board_size.x + board_size.y):
				var found = false
				for tile in get_node("TileManager").get_children():
					var difference = tile.tile_coords
					if abs(difference.x) + abs(difference.y) == board_size.x + board_size.y - i and tile.tile_coords != Vector2.ZERO:
						tile.destroy()
						found = true
				if found:
					await get_tree().create_timer(0.2).timeout
		await destroy.call()
		return
	elif flag == "ignore_player":
		for i in range(0, board_size.x + board_size.y):
			var found = false
			for tile in get_node("TileManager").get_children():
				var difference = tile.tile_coords
				if player:
					difference = Vector2(tile.tile_coords - player.player_coords)
				if abs(difference.x) + abs(difference.y) == board_size.x + board_size.y - i:
					tile.destroy()
					found = true
			if found:
				await get_tree().create_timer(0.2).timeout
		if get_tile(player.player_coords):
			await get_tile(player.player_coords).destroy("leave_player")
		while get_node("TileManager").get_children().size() != 0:
			await get_tree().process_frame
		return

func show_all_deck():
	var deck_to_show = copy_current_deck()
	
	deck_to_show.shuffle()

	var found = false
	for child in camera.get_children():
		if child.name == "DeckSpace":
			found = true
	if !found:
		var space = ColorRect.new()
		space.z_index = 1
		space.size = Vector2(2000,2000)
		space.position = - Vector2(space.size.x / 2, get_viewport_rect().size.y / 2 + 20) 
		space.color = Color.BLACK
		space.name = "DeckSpace"
		camera.add_child(space)
		var width = 6
		var tile_space = Vector2(100,100)

		for i in range(0, deck_to_show.size()):
			var tile = deck_to_show[i]
			var sprite = Sprite2D.new()
			sprite.z_index = 1
			sprite.texture = tile.get_sprite()[0]
			sprite.rotation = tile.get_sprite()[1]
	
			sprite.position.x = (space.size.x / 2) - (((float(width) / 2) - i % width - 0.5) * tile_space.x) 
			sprite.position.y = (i / width) * tile_space.y + G.tile_size.y + 50
			space.add_child(sprite)
			for effect in tile.effects_to_add:
				sprite.add_child(Sprite2D.new())
				sprite.get_child(sprite.get_children().size() - 1).rotation = - sprite.rotation
				sprite.get_child(sprite.get_children().size() - 1).texture = load("res://sprites/effects/" + effect + "_effect.png")
		return true
	else:
		camera.get_node("DeckSpace").queue_free()

func update_money(amount):
	camera.get_node("PlayerMoney").text = str(amount)

func copy_current_deck():
	var to_return = []
	for i in range(0, current_deck.size()):
		to_return.append(current_deck[i].duplicate())
		to_return[i].tile_moves = current_deck[i].tile_moves
		to_return[i].effects_to_add = current_deck[i].effects_to_add
		to_return[i].tile_in_deck = current_deck[i]
	return to_return

func add_tile_to_deck(tile, moves):
	tile.tile_moves = moves
	tile_deck.append(tile)

func change_shield(shield):
	if shield == 0:
		camera.get_node("PlayerShield").text = ""
	else:
		camera.get_node("PlayerShield").text = str(shield)
