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

signal moved
signal effect_applied

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
	init_effects()
	add_essential_nodes()
	var node = Node2D.new()
	effects = node
	node.name = "Effects"
	add_child(node)
	self.scale = Vector2.ZERO
	replace(tile_size.x * tile_coords)
	define_sprite()
	add_button()
	init_effects()
	add_all_effects()
	var f = func(x):
		return (-((x * 3 - 2)) ** 2 + 5) / 4
		
	if self.tile_coords.x < G.GS.board_size.x and self.tile_coords.x >= 0 and self.tile_coords.y < G.GS.board_size.y and self.tile_coords.y >= 0:
		var init_time = 0.3
		var curr_time = 0
		while curr_time < init_time:
			var curr_scale = f.call(curr_time / init_time)
			scale = Vector2(curr_scale, curr_scale)
			await get_tree().process_frame
			curr_time += get_process_delta_time() * G.animation_time_scale
	self.scale = Vector2(1,1)

	return


func tile_effect():
	pass

func replace(coords):
	z_index = - int(G.GS.board_size.y) + int(coords.y) / int(tile_size.y) 
	self.position = coords
	curr_position = coords
	
func _process(delta):
	if !is_destroying:
		time_from_init += get_process_delta_time() * G.animation_time_scale
		if G.GS.player or G.GS.generating:
			if G.GS.player:
				if G.GS.player.player_coords == tile_coords:
					position = curr_position
				else:
					position.y = curr_position.y + sin(3 * (time_from_init + (position.x + curr_position.y) / 50)) * 2
	
			else:
				position.y = curr_position.y + sin(3 * (time_from_init + (position.x + curr_position.y) / 50)) * 2

func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]
	if get_sprite().size() == 3:
		main_sprite.get_parent().position += get_sprite()[2]

func init_effects():
	pass

func add_all_effects():
	for effect in effects_to_add:
		add_effect(effect)
		
func on_enter():
	for effect in get_node("Effects").get_children():
		await effect.on_enter()
	return

func add_effect(effect, animated = false):
	if tile_moves == []:
		return
	if effects_to_add == null:
		effects_to_add = []
	if check_node("Effects"):
		var effect_scene = load("res://scenes/effects/"+effect+"_effect.tscn").instantiate()
		for child in effects.get_children():
			if child.get_script() == effect_scene.get_script():
				return
		effects.add_child(effect_scene)
		if animated:
			effect_scene.get_node("Sprite").visible = false
			var effect_spawn = EffectSpawn.new()
			effect_scene.add_child(effect_spawn)
			effect_spawn.sprite_frames = load("res://stuff/effects/effect_spawn.tres")
			effect_spawn.play("default")
		effect_scene.position = get_player_offset()
	else:
		if effects_to_add.find(effect) == -1:
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
			G.player.replace(tile_size * tile_coords * (1 - current_time / init_time) + current_time / init_time * old_position  + get_player_offset())
		replace(tile_size * tile_coords * (1 - current_time / init_time) + current_time / init_time * old_position)
		current_time -= get_process_delta_time() * G.animation_time_scale
		await get_tree().process_frame
	replace(tile_size * tile_coords)

	if move_player:
		G.player.player_coords = coords
		G.player.position = tile_size * coords + G.GS.get_tile(coords).get_player_offset()
	
	if tile_coords.x < 0 or tile_coords.y < 0 or tile_coords.x >= G.GS.board_size.x or tile_coords.y >= G.GS.board_size.y:
		await destroy()
	
	emit_signal("moved")
	
	return
	
func destroy(flag = ""):
	if !is_destroying:
		is_destroying = true
		
		var init_time = G.tile_shake_time
		var curr_time = 0.0
		var start_scale = scale 
		var finish_scale = Vector2(0.0,0.0)
		var start_modulate = modulate[3]
		var finish_modulate = 0
		var start_position = position
		
		var fx = func(x):
			return x
		var fy = func(x):
			return x
		var fm = func(x):
			return x * x
		
		disable()
		var multiplier_x = randf_range(-1.0, 1.0)
		var multiplier_y = randf_range(-1.0, 1.0)
		var amplitude = 5
		
		if flag != "no_shake":
			while curr_time < init_time:
				var shake_x = sin(curr_time / init_time * 60.0) * amplitude * randf()
				var shake_y = cos(curr_time / init_time * 75.0) * amplitude * randf()
				position = start_position + Vector2(shake_x, shake_y)
				curr_time += get_process_delta_time()
				await get_tree().process_frame
			
		curr_time = 0.0
		init_time = G.tile_destroy_time
		
		var destroy_player = false
		if G.player:
			if G.player.player_coords == tile_coords:
				destroy_player = true
		while curr_time < init_time:
			print(scale)
			scale.x = (1 - fx.call(curr_time / init_time)) * start_scale.x + fx.call(curr_time / init_time) * finish_scale.x
			scale.y = (1 - fy.call(curr_time / init_time)) * start_scale.y + fy.call(curr_time / init_time) * finish_scale.y
			modulate[3] = (1 - fm.call(curr_time / init_time)) * start_modulate + fm.call(curr_time / init_time) * finish_modulate
			if G.player:
				if destroy_player:
					G.player.scale = Vector2(max(scale.x, scale.y), max(scale.x, scale.y))
			curr_time += get_process_delta_time() * G.animation_time_scale
			await get_tree().process_frame
		if destroy_player and flag != "leave_player" and !G.GS.restarting:
			G.GS.disable_buttons()
			G.GS.restart_game()
		elif !G.GS.restarting and G.player.player_coords != Vector2(0,0) and !(tile_coords.x < 0 or tile_coords.y < 0 or tile_coords.x >= G.GS.board_size.x or tile_coords.y >= G.GS.board_size.y) and G.player:
			G.GS.get_player_moves()
		reparent(G.GS.get_node("Stuff/Trash"))
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

func deploy_effect():
	pass

func rotatable():
	return true

func get_spawn_priority():
	return 0
