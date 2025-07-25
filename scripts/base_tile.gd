extends Node2D

class_name Tile

var effects
var tile_size = Vector2(32,32)
var tile_coords = Vector2.ZERO
var tile_moves = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]

func init():
	self.position = tile_size * tile_coords
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
