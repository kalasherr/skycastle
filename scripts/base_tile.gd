extends Node2D

class_name Tile

var effects
var tile_size = Vector2(32,32)
var tile_coords = Vector2.ZERO
var tile_moves = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]
var is_destroying = false

func init():
	self.position = tile_size.x * tile_coords
	var node = Node2D.new()
	effects = node
	node.name = "Effects"
	add_child(node)
	define_sprite()
	add_button()
	post_init()

func tile_effect():
	pass

func define_sprite():
	pass

func post_init():
	pass

func on_enter():
	for effect in get_node("Effects").get_children():
		effect.on_enter()

func add_effect(effect):
	get_node("Effects").add_child(load("res://scenes/effects/"+effect+"_effect.tscn").instantiate())

func add_button():
	var button = TextureButton.new()
	button.position = - tile_size / 2
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
			G.player.position = position + Vector2(0,1)
		position = tile_size * tile_coords * (1 - current_time / init_time) + current_time / init_time * old_position
		current_time -= get_process_delta_time()
		await get_tree().process_frame
	position = tile_size * tile_coords
	
	if move_player:
		G.player.player_coords = coords
		G.player.position = tile_size * coords + Vector2(0, 1)
	
	if tile_coords.x < 0 or tile_coords.y < 0 or tile_coords.x >= G.GS.board_size.x or tile_coords.y >= G.GS.board_size.y:
		destroy()
	
func destroy():
	if !is_destroying:
		is_destroying = true
		while scale.x > 0:
			scale -= Vector2(0.05, 0.05) * 60 * get_process_delta_time()
			await get_tree().process_frame
		queue_free()
	

func get_sprite():
	return null
