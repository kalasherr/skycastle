extends Tile

class_name BasicTile

@onready var main_sprite = $SpriteTree/MainSprite

func define_sprite():
	match tile_moves.size():
		1: 
			main_sprite.texture = load("res://sprites/tiles/basic_dead_end.png")
			match tile_moves[0]:
				Vector2(-1,0):
					main_sprite.rotation = deg_to_rad(90)
				Vector2(1,0):
					main_sprite.rotation = deg_to_rad(-90)
				Vector2(0,-1):
					main_sprite.rotation = deg_to_rad(180)
		2:
			if tile_moves[0] + tile_moves[1] == Vector2.ZERO:
				main_sprite.texture = load("res://sprites/tiles/basic_i.png")
				if tile_moves.find(Vector2(1,0)) != -1:
					main_sprite.rotation = deg_to_rad(90)
			else:
				main_sprite.texture = load("res://sprites/tiles/basic_r.png")
				if tile_moves.find(Vector2(-1,0)) != -1 and tile_moves.find(Vector2(0,1)) != -1:
					main_sprite.rotation = deg_to_rad(90)
				elif tile_moves.find(Vector2(0,-1)) != -1 and tile_moves.find(Vector2(-1,0)) != -1:
					main_sprite.rotation = deg_to_rad(180)
				elif tile_moves.find(Vector2(1,0)) != -1 and tile_moves.find(Vector2(0,-1)) != -1:
					main_sprite.rotation = deg_to_rad(-90)
		3:
			main_sprite.texture = load("res://sprites/tiles/basic_t.png")
			if tile_moves.find(Vector2(1,0)) == -1:
				main_sprite.rotation = deg_to_rad(90)
			elif tile_moves.find(Vector2(-1,0)) == -1:
				main_sprite.rotation = deg_to_rad(-90)
			elif tile_moves.find(Vector2(0,1)) == -1:
				main_sprite.rotation = deg_to_rad(180)
		4:
			main_sprite.texture = load("res://sprites/tiles/basic_crossroad.png")

func get_sprite():
	var sprite
	var rot = 0
	match tile_moves.size():
		1: 
			sprite = load("res://sprites/tiles/basic_dead_end.png")
			match tile_moves[0]:
				Vector2(-1,0):
					rot = deg_to_rad(90)
				Vector2(1,0):
					rot = deg_to_rad(-90)
				Vector2(0,-1):
					rot = deg_to_rad(180)
		2:
			if tile_moves[0] + tile_moves[1] == Vector2.ZERO:
				sprite = load("res://sprites/tiles/basic_i.png")
				if tile_moves.find(Vector2(1,0)) != -1:
					rot = deg_to_rad(90)
			else:
				sprite = load("res://sprites/tiles/basic_r.png")
				if tile_moves.find(Vector2(-1,0)) != -1 and tile_moves.find(Vector2(0,1)) != -1:
					rot = deg_to_rad(90)
				elif tile_moves.find(Vector2(0,-1)) != -1 and tile_moves.find(Vector2(-1,0)) != -1:
					rot = deg_to_rad(180)
				elif tile_moves.find(Vector2(1,0)) != -1 and tile_moves.find(Vector2(0,-1)) != -1:
					rot = deg_to_rad(-90)
		3:
			sprite = load("res://sprites/tiles/basic_t.png")
			if tile_moves.find(Vector2(1,0)) == -1:
				rot = deg_to_rad(90)
			elif tile_moves.find(Vector2(-1,0)) == -1:
				rot = deg_to_rad(-90)
			elif tile_moves.find(Vector2(0,1)) == -1:
				rot = deg_to_rad(180)
		4:
			sprite = load("res://sprites/tiles/basic_crossroad.png")
	return [sprite, rot]
