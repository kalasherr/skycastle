extends TextureButton

class_name TileMove

var tile_coords

func _process(delta):
	if self.is_hovered() and get_children().size() > 0:
		get_node("Sprite").texture = G.GS.camera.get_node("NextTile").texture
		get_node("Sprite").rotation = G.GS.camera.get_node("NextTile").rotation
	else:
		get_node("Sprite").texture = null

func _ready():
	var sprite = Sprite2D.new()
	sprite.name = "Sprite"
	sprite.position = G.tile_size / 2
	sprite.modulate[3] = 0.3
	add_child(sprite)
