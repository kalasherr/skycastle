extends Node2D

class_name SinCard

var card_name = "default"
var init_position = Vector2.ZERO
var card_size = Vector2(290, 470)

var follow_threshold = 0.1

func apply():
	pass

func init():
	default_init()

func add_labels():
	var title = Label.new()
	title.autowrap_mode = TextServer.AUTOWRAP_WORD
	var text = Label.new()
	title.modulate = Color(138.0/255.0,0/255.0,0/255.0)
	text.modulate = Color(138.0/255.0,0/255.0,0/255.0)
	text.autowrap_mode = TextServer.AUTOWRAP_WORD
	title.size = Vector2(270,20)
	text.size = Vector2(270,100)
	title.position = Vector2(-135,60)
	text.position = Vector2(-135,80)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.text = get_text()[0]
	text.text = get_text()[1]
	add_child(title)
	add_child(text)
	
func default_init():
	define_sprite()
	add_button()
	add_labels()

func init_effects():
	pass

func _ready():
	init()
	
func add_button():
	var button = TextureButton.new()
	button.name = "Button"
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.texture_click_mask = load("res://sprites/cards/card_bitmap.png")
	button.position = - card_size / 2
	button.connect("pressed", pressed)
	add_child(button)

func _process(delta):
	if check_hover():
		if (self.position - (init_position + (get_global_mouse_position() - global_position) * 0.1)).length() / 10 > follow_threshold:
			position += (init_position + (get_global_mouse_position() - global_position) * 0.1 - position).normalized() * max((init_position + (get_global_mouse_position() - global_position) * 0.1 - position).length() / 10, follow_threshold)
		else:
			self.position = init_position + (get_global_mouse_position() - global_position) * 0.1
	else:
		if (position - init_position).length() / 10 > follow_threshold:
			position += (init_position - position).normalized() * max((init_position - position).length() / 10, follow_threshold)
		else:
			position = init_position

func define_sprite():
	var sprite_tree = Sprite2D.new()
	sprite_tree.name = "SpriteTree"
	add_child(sprite_tree)
	var sprite = Sprite2D.new()
	sprite.texture = load("res://sprites/cards/sin_card_base.png")
	sprite.name = "MainSprite"
	sprite_tree.add_child(sprite)
# 	var illustration = Sprite2D.new()
# 	illustration.texture = load("res://sprites/cards/candle_card.png")
# 	illustration.scale = Vector2(2,2)
# 	illustration.position.y = -90
# 	add_child(illustration)

func check_hover():
	var found = false
	for child in get_children():
		if child.name == "Button":
			found = true
	if found:
		if get_node("Button").is_hovered():
			return true
	return false

func pressed():
	if get_parent().get_parent() is SinCardManager:
		get_parent().get_parent().destroy_other_cards(self)
	else:
		get_parent().get_parent().click()

func destroy():
	queue_free()
	return

func disable():
	get_node("Button").disabled = true

func able():
	get_node("Button").disabled = false

func add_tile_to_deck(tile, moves):
	G.GS.add_tile_to_deck(tile, moves)

func get_text():
	pass
	
func add_stones():
	for i in range(0,2):
		var tile = load("res://scenes/tiles/stone_tile.tscn").instantiate()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves, false, true)
