extends Node2D

class_name Tile

var effects
var tile_size = G.tile_size
var tile_coords = Vector2.ZERO
var tile_moves = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]
var is_destroying = false
var effects_to_add = []
var time_from_init = 0
var curr_position = position
var tile_in_deck

var main_sprite

func add_essential_nodes():
	var sprite_tree = false
	for child in get_children():
		if child.name == "SpriteTree":
			sprite_tree = true
	if !sprite_tree:
		sprite_tree = Sprite2D.new()
		sprite_tree.name = "SpriteTree"
		add_child(sprite_tree)
		var sprite = Sprite2D.new()
		sprite.name = "MainSprite"
		sprite_tree.add_child(sprite)
		var focus = Node2D.new()
		sprite_tree.add_child(focus)
		focus.name = "Focus"
	main_sprite = get_node("SpriteTree/MainSprite")

func init():
	add_essential_nodes()
	var node = Node2D.new()
	effects = node
	node.name = "Effects"
	add_child(node)
	self.scale = Vector2.ZERO
	replace(tile_size.x * tile_coords)
	define_sprite()
	add_button()
	if self.tile_coords.x < G.GS.board_size.x and self.tile_coords.x >= 0 and self.tile_coords.y < G.GS.board_size.y and self.tile_coords.y >= 0:
		var init_time = 0.2
		var curr_time = init_time
		while curr_time > 0:
			var curr_scale = 1 - curr_time / init_time
			scale = Vector2(curr_scale, curr_scale)
			await get_tree().process_frame
			curr_time -= get_process_delta_time()
	self.scale = Vector2(1,1)
	post_init()
	for effect in effects_to_add:
		add_effect(effect)

func tile_effect():
	pass

func replace(coords):
	z_index = - int(G.GS.board_size.y) + int(coords.y) / int(tile_size.y) 
	self.position = coords
	curr_position = coords
	
func _process(delta):
	time_from_init += get_process_delta_time()
	if G.GS.player or G.GS.generating:
		if G.GS.player:
			if G.GS.player.player_coords == tile_coords:
				position = curr_position
			else:
				position.y = curr_position.y + sin(3 * (time_from_init + (position.x + curr_position.y) / 50)) * 2

		else:
			position.y = curr_position.y + sin(3 * (time_from_init + (position.x + curr_position.y) / 50)) * 2

func define_sprite():
	pass

func post_init():
	pass

func on_enter():
	for effect in get_node("Effects").get_children():
		effect.on_enter()

func add_effect(effect):
	if effects_to_add == null:
		effects_to_add = []
	if check_node("Effects"):
		effects.add_child(load("res://scenes/effects/"+effect+"_effect.tscn").instantiate())
		effects.get_child(effects.get_children().size() - 1).position = get_player_offset()
	else:
		effects_to_add.append(effect)

func add_button():
	var button = TextureButton.new()
	button.position =- tile_size / 2
	button.visible = false
	button.name = "Button"
	button.texture_normal = load("res://sprites/tiles/tile_focus.png")
	button.texture_click_mask = load("res://sprites/tiles/tile_bitmap.png")
	button.connect("pressed", button_press)
	add_child(button)

func button_press():
	G.GS.button_pressed(self)

func disable():
	get_node("Button").disabled = true
	get_node("Button").visible = false

func able():
	get_node("Button").disabled = false
	while get_node("Button").visible == false:
		get_node("Button").visible = true

func move(coords):
	var old_position = position
	var move_player = false
	
	if G.player.player_coords == tile_coords:
		move_player = true
	if G.GS.get_tile(coords):
		G.GS.get_tile(coords).move(coords * 2 - tile_coords)
	tile_coords = coords
	
	var timer = Timer.new()
	add_child(timer)
	timer.start(50)
	var init_time = 0.5
	var current_time = init_time
	
	var i = 0
	while current_time > 0:
		i += 1
		if move_player:
			G.player.position = position  + get_player_offset()
		replace(tile_size * tile_coords * (1 - current_time / init_time) + current_time / init_time * old_position)
		current_time -= get_process_delta_time()
		await get_tree().process_frame
	replace(tile_size * tile_coords)

	if move_player:
		G.player.player_coords = coords
		G.player.position = tile_size * coords + G.GS.get_tile(coords).get_player_offset()
	
	if tile_coords.x < 0 or tile_coords.y < 0 or tile_coords.x >= G.GS.board_size.x or tile_coords.y >= G.GS.board_size.y:
		destroy()
	
func destroy(flag = ""):
	if !is_destroying:
		is_destroying = true
		var destroy_player = false
		if G.player:
			if G.player.player_coords == tile_coords:
				destroy_player = true
		while scale.x > 0:
			scale -= Vector2(0.05, 0.05) * 60 * get_process_delta_time()
			if G.player:
				if destroy_player:
					if G.player.scale.x > 0:
						G.player.scale -= Vector2(0.05, 0.05) * 60 * get_process_delta_time()
			await get_tree().process_frame
		if destroy_player and flag != "leave_player" and !G.GS.restarting:
			G.GS.restart_game()
		queue_free()

func get_sprite():
	return null

func check_node(node_name):
	for node in get_children():
		if node.name == node_name:
			return true
	return false

func get_player_offset():
	return Vector2.ZERO

func get_moves():
	return null
	
func rotate_tile(array = tile_moves, rot = 0.0):
	var moves = []
	for vector in array:
		vector = vector.rotated(deg_to_rad(round(rot) * 90))
		moves.append(vector)
	return moves
