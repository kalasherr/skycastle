extends Node2D

class_name CandleTile

var sprite 
var x_offset = 60
func _ready():
	z_index = -1
	self.name = "CandleTile"
	var sprite_scene = Sprite2D.new()
	add_child(sprite_scene)
	sprite = sprite_scene
	self.position.x = get_parent().get_node("NextTile").position.x + x_offset
	self.scale = Vector2(0.7,0.7)
	var effects = Node2D.new()
	sprite.add_child(effects)
	effects.name = "Effects"
	G.GS.connect("next_tile_updated", update)

func update():
	if G.GS.current_deck.size() > 1:
		G.GS.current_deck[1].init_effects()
		self.position.x = get_parent().get_node("NextTile").position.x + x_offset
		for effect in sprite.get_node("Effects").get_children():
			effect.queue_free()
		var array = G.GS.current_deck[1].get_sprite()
		sprite.texture = array[0]
		sprite.rotation = array[1]
		var offset = Vector2(0,0)
		if array.size() == 3:
			offset = array[2]
		var effects = []
		var dir = DirAccess.open("res://sprites/effects")
		for effect in G.GS.current_deck[1].effects_to_add:
			if dir.get_files().find(effect + "_effect.png") != -1:
				effects.append(load("res://sprites/effects/" + effect + "_effect.png"))
		for effect in effects:
			sprite.get_node("Effects").add_child(Sprite2D.new())
			sprite.get_node("Effects").get_child(sprite.get_node("Effects").get_children().size() - 1).rotation = - sprite.rotation
			sprite.get_node("Effects").get_child(sprite.get_node("Effects").get_children().size() - 1).texture = effect
		self.position.y = offset.y
	else:
		sprite.texture = null
		for effect in sprite.get_node("Effects").get_children():
			effect.queue_free()
