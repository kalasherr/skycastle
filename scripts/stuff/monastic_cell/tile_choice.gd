extends Node2D

class_name TileChoice

var bound_tile

func init():
	scale = Vector2(1,1) * 2 
	var sprite = Sprite2D.new()
	sprite.name = "Sprite"
	add_child(sprite)
	var button = TextureButton.new()
	button.position = - G.tile_size / 2
	button.name = "Button"
	button.texture_click_mask = load("res://sprites/tiles/tile_bitmap.png")
	button.texture_hover = load("res://sprites/tiles/tile_focus.png")
	add_child(button)
	button.connect("pressed", pressed)

func pressed():
	get_parent().choose(bound_tile)
