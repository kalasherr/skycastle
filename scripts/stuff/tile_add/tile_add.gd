extends Node2D

class_name TileAdd

var playing = false
var queue = []

signal play_next

func play(sprite):
	if !playing:
		var node = Sprite2D.new()
		node.position = Vector2(0, -100)
		node.modulate[3] = 0
		node.texture = 

func play_sprite():
	pass