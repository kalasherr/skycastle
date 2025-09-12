extends Node2D

class_name Card

var card_name = "default"
var init_position = Vector2.ZERO
var card_size = Vector2(290, 470)
var option = ""

var values = {
	"add" : "2b7812",
	"replace" : Color.ORANGE.to_html(),
	"delete" : Color.RED.to_html(),
	"defense" : Color.BLUE.to_html(),
	"value1" : 0,
	"value2" : 0
}

var follow_threshold = 0.1

func apply():
	pass

func init():
	default_init()

func add_labels():
	var title = Label.new()
	var font = title.get_theme_font("font")
	title.autowrap_mode = TextServer.AUTOWRAP_WORD
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var text = RichTextLabel.new()
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text.bbcode_enabled = true
	title.modulate = Color(143.0/255.0,86.0/255.0,59.0/255.0)
	text.theme = load("res://stuff/assets/default_theme.tres")
	title.theme = load("res://stuff/assets/default_theme.tres")
	text.autowrap_mode = TextServer.AUTOWRAP_WORD
	var size = len(get_text()[0])
	title.size = Vector2(font.get_string_size(get_text()[0]).x * 1.5,20)
	text.size = Vector2(270,100)
	title.position = Vector2(- title.size.x/2,60)
	text.position = Vector2(-135,90)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.text = get_text()[0]
	text.text = get_text()[1]
	var border1 = Sprite2D.new()
	var border2 = Sprite2D.new()
	border1.scale = Vector2((270 - title.size.x - 8) / 4, 1)
	border2.scale = Vector2((270 - title.size.x - 8) / 4, 1)
	border1.centered = false
	border2.centered = false
	border1.texture = load("res://sprites/stuff/cards/card_title_border.png")
	border2.texture = load("res://sprites/stuff/cards/card_title_border.png")
	border1.position = Vector2(-135,title.position.y + 12)
	border2.position = Vector2(title.size.x / 2 + 4, title.position.y + 12)
	add_child(border1)
	add_child(border2)
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
	sprite.texture = load("res://sprites/cards/card_base.png")
	sprite.name = "MainSprite"
	sprite_tree.add_child(sprite)
	var illustration = Sprite2D.new()
	illustration.texture = load(get_illustration())
	illustration.scale = Vector2(2,2)
	illustration.position.y = -90
	add_child(illustration)

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
	if get_parent().get_parent() is CardManager:
		get_parent().get_parent().destroy_other_cards(self)
	else:
		get_parent().get_parent().click()

func destroy():
	var f = func(x):
		return x * x
	var goal_position = init_position + Vector2(0,-1000)
	var start_position = init_position
	var init_time = 0.6
	var curr_time = 0.0
	while curr_time < init_time:
		init_position = start_position * (1 - f.call(curr_time / init_time)) + goal_position * f.call(curr_time / init_time)
		curr_time += get_process_delta_time()
		await get_tree().process_frame
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

func get_illustration():
	return "res://sprites/cards/candle_card.png"
