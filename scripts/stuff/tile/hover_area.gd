extends Area2D

class_name TooltipHoverArea

@onready var tile = get_parent()
var exited = true
var tooltip = null

func _ready():
	pass

func _process(delta):
	pass

func _on_mouse_entered():
	exited = false
	await get_tree().create_timer(1).timeout
	if !exited and (get_global_mouse_position() - global_position).length() < 32.0 * sqrt(2):
		show_tooltip()

func _on_mouse_exited():
	for child in G.GS.get_children():
		if child is Tooltip:
			await T.tween(child, "modulate", Color(1,0,0,0), 0.5)
			if child:
				child.queue_free()
	exited = true

func show_tooltip():
	for child in G.GS.get_children():
		if child is Tooltip:
			child.queue_free()
	tooltip = Tooltip.new()
	tooltip.tile = tile
	G.GS.add_child(tooltip)

	await T.tween(tooltip, "modulate", Color(1,1,1,1), 0.5)

class Tooltip:
	extends Node2D
	
	var tile = null
	
	func _ready():
		construct(tile)
	
	func construct(tile_scene):
		self.name = "Tooltip"
		self.global_position = Vector2(36,-32) + tile.global_position
		self.z_index = 10
		self.modulate = Color(1,0,0,0)
		
		var label = RichTextLabel.new()
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.name = "Label"
		label.custom_minimum_size.x = 120
		label.theme = load("res://stuff/assets/default_theme.tres")
		label.add_theme_font_size_override("normal_font_size", 8)
		label.add_theme_color_override("font_shadow_color", Color(0,0,0,0))
		label.add_theme_constant_override("line_separation", 6)
		label.offset_left = 4
		label.offset_right = 4
		label.offset_top = 6
		label.offset_bottom = 4
		label.text = tile.get_tooltip()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.scroll_active = false
		add_child(label)
		label.custom_minimum_size.y = label.get_line_count() * 16
		
		var sprite_tree = Node2D.new()
		var top = Sprite2D.new()
		var bot = Sprite2D.new()
		top.centered = false
		bot.centered = false
		top.position = Vector2(0, 0)
		bot.position = Vector2(0, 16)
		top.texture = load("res://sprites/hud/tooltip_top.png")
		bot.texture = load("res://sprites/hud/tooltip_bottom.png")
		sprite_tree.add_child(top)
		sprite_tree.add_child(bot)
		var mid
		var max_i = 0
		for i in range(0, max(0, label.get_line_count() - 2)):
			mid = Sprite2D.new()
			mid.centered = false
			mid.texture = load("res://sprites/hud/tooltip_middle.png")
			mid.position = Vector2(0, (i + 1) * 16)
			sprite_tree.add_child(mid)
			max_i = i + 1
		bot.position = Vector2(0, 16 * (max_i + 1))
		sprite_tree.z_index = -1
		add_child(sprite_tree)
