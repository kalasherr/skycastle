extends TextureButton

class_name TileMove

var tile_coords
var arrow = false

func _process(delta):
	if self.is_hovered() and get_children().size() > 0:
		if self.modulate[3] != 0:
			get_node("Sprite").texture = G.GS.camera.hud_next_tile.texture
			get_node("Sprite").rotation = G.GS.camera.hud_next_tile.rotation
			get_node("Sprite").global_position = position + G.tile_size / 2 + G.GS.camera.hud_next_tile.position - G.GS.camera.default_next_position
			if !G.GS.focused or G.GS.focused_tile != self:
				G.GS.focused_tile = self
				var array = []
				if tile_coords.x == G.GS.board_size.x or tile_coords.x == -1:
					for i in range(0,G.GS.board_size.x):
						array.append(Vector2(i, tile_coords.y))
				else:
					for i in range(0,G.GS.board_size.y):
						array.append(Vector2(tile_coords.x, i))
				G.GS.light_off_tiles()
				G.GS.light_up_tiles(array)
				G.GS.focused = true
			if !arrow:
				add_arrow()
				arrow = true
		else:
			get_node("Sprite").texture = null
			if arrow:
				get_node("Arrow").queue_free()
				arrow = false
			if G.GS.focused and !check_hover():
				G.GS.focused = false
			elif check_hover() and check_hover() != G.GS.focused_tile:
				G.GS.focused = false
				G.GS.light_off_tiles()
			elif G.GS.focused == false:
				G.GS.light_off_tiles()
	else:
		get_node("Sprite").texture = null
		if arrow:
			get_node("Arrow").queue_free()
			arrow = false
		if G.GS.focused and !check_hover():
			G.GS.focused = false
		elif check_hover() and check_hover() != G.GS.focused_tile:
			G.GS.focused = false
			G.GS.light_off_tiles()
		elif G.GS.focused == false:
			G.GS.light_off_tiles()
			

func check_hover():
	for button in get_parent().get_children():
		if button.is_hovered():
			return button
	return false

func _ready():
	var sprite = Sprite2D.new()
	sprite.name = "Sprite"
	sprite.position = G.tile_size / 2
	sprite.modulate[3] = 0.3
	add_child(sprite)

func add_arrow():
	var arrow_rot
	var arrow_coords
	var shift = Vector2.ZERO
	var arrow_shift = Vector2.ZERO
	if tile_coords.x == G.GS.board_size.x:
		arrow_rot = deg_to_rad(270)
		shift += Vector2(1,1)
		arrow_shift = Vector2(-1,0)
	elif tile_coords.x == -1:
		arrow_rot = deg_to_rad(90)
		shift += Vector2(0,0)
		arrow_shift = Vector2(1,0)
	elif tile_coords.y == - 1:
		arrow_rot = deg_to_rad(180)
		shift += Vector2(1,0)
		arrow_shift = Vector2(0,1)
	else:
		arrow_rot = 0
		shift += Vector2(0,1)
		arrow_shift = Vector2(0,-1)
	arrow_coords = tile_coords + shift
	var sprite = Arrow.new()
	sprite.centered = false
	sprite.shift = arrow_shift
	sprite.rotation = arrow_rot
	sprite.position = (arrow_coords - tile_coords) * G.tile_size.x
	sprite.texture = load("res://sprites/arrow_sprite.png")
	sprite.name = "Arrow"
	add_child(sprite)
