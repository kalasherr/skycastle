extends Node2D

class_name DeckShow

func show_deck(deck_to_show):
	var camera = G.GS.camera
	var space = ColorRect.new()
	space.z_index = 1
	space.size = Vector2(2000,2000)
	space.position = - Vector2(space.size.x / 2, get_viewport_rect().size.y / 2 + 20) 
	space.color = Color.BLACK
	space.name = "DeckSpace"
	add_child(space)
	var width = 6
	var tile_space = Vector2(100,100)
	var scripts = []
	for i in range(0, deck_to_show.size()):
		var found = false
		for script in scripts:
			if deck_to_show[i].get_script() == script:
				found = true
				break
		if !found:
			scripts.append(deck_to_show[i].get_script())
	print(scripts)
	scripts.sort()
	var rows = []
	for script in scripts:
		var tiles = []
		for tile in deck_to_show:
			if tile.get_script() == script:
				tiles.append(tile)
		rows.append(tiles)
	for i in range(0, rows.size()):
		for j in range(0, rows[i].size()):
			var tile = rows[i][j]
			tile.init_effects()
			var sprite = Sprite2D.new()
			sprite.z_index = 1
			sprite.texture = tile.get_sprite()[0]
			sprite.rotation = tile.get_sprite()[1]
			sprite.position.x = (((float(width) / 2) - j % width - 0.5) * tile_space.x) 
			sprite.position.y = i * tile_space.y
			
			add_child(sprite)
			var effects = []
			var dir = DirAccess.open("res://sprites/effects")
			for effect in tile.effects_to_add:
				if dir.get_files().find(effect + "_effect.png") != -1:
					effects.append(load("res://sprites/effects/" + effect + "_effect.png"))
			for effect in effects:
				sprite.add_child(Sprite2D.new())
				sprite.get_child(sprite.get_children().size() - 1).rotation = - sprite.rotation
				sprite.get_child(sprite.get_children().size() - 1).texture = effect
			if tile.get_sprite().size() == 3:
				sprite.position += tile.get_sprite()[2]
				for effect in sprite.get_children():
					effect.position -= tile.get_sprite()[2]
