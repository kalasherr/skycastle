extends Node2D

var board_size = Vector2(6,6)
var tile_deck = []

func _ready():
	G.GS = self
	fill_deck()
	generate_field()
	add_player()

func add_player(coords = board_size - Vector2(1,1)):
	var player = load("res://scenes/player_entity.tscn").instantiate()
	add_child(player)
	player.init(coords)
	
func generate_field():
	var deck_to_pick = tile_deck.duplicate()
	
	var start_tile = deck_to_pick.pick_random()
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
	

	for i in range (0,board_size.x):
		for j in range (0,board_size.y):
			if i + j < board_size.x + board_size.y - 3:
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
