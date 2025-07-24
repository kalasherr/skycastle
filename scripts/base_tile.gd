extends Node2D

class_name Tile

var tile_size = Vector2(32,32)
var tile_coords = Vector2.ZERO
var tile_moves = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]

func init():
	self.position = tile_size * tile_coords
	define_sprite()

func tile_effect():
	pass

func define_sprite():
	pass
