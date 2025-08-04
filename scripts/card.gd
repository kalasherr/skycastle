extends Node2D

class_name Card

var card_name = "default"
var init_position = Vector2.ZERO
var card_size = Vector2(290, 470)

var follow_threshold = 0.1
func apply():
	pass

func init():
	default_init()

func default_init():
	define_sprite()
	add_button()

func post_init():
	pass

func _ready():
	init()
	
func add_button():
	var button = TextureButton.new()
	button.name = "Button"
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.texture_click_mask = load("res://sprites/cards/card_bitmap.png")
	button.position = - card_size / 2
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
	sprite.texture = load("res://sprites/cards/card_base.png")
	sprite.name = "MainSprite"
	sprite_tree.add_child(sprite)

func check_hover():
	var found = false
	for child in get_children():
		if child.name == "Button":
			found = true
	if found:
		if get_node("Button").is_hovered():
			return true
	return false

