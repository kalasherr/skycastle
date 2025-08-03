extends Node2D

class_name TileEffect

@onready var bound_tile = get_parent().get_parent()

func on_enter():
	pass
	
func get_effect_name():
	return "none"

func get_sprite():
	return load("res://sprites/effects/" + get_effect_name() + "_effect.png")