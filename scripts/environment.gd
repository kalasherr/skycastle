extends Node2D

class_name EnvironmentNode

var last_cloud_y = []
var cloud_speed = 10.0
var wait_time = 1.0

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait_time
	timer.autostart = true
	timer.start()
	timer.connect("timeout", spawn_cloud)
	var pos = - get_viewport_rect().size.x / 2
	while pos < get_viewport_rect().size.x / 2:
		spawn_cloud(pos)
		pos += cloud_speed * randf_range(1,2) * wait_time

func _process(delta):
	for child in get_children():
		if child is Timer:
			pass
		else:
			child.position.x += delta * cloud_speed * abs(child.scale.x)
			if child.position.x > get_viewport_rect().size.x / 2 + 50:
				child.queue_free()
	
func spawn_cloud(x = -get_viewport_rect().size.x / 2):
	var sprite = Sprite2D.new()
	sprite.texture = load("res://sprites/enviroment/cloud1.png")
	
	var completed = false
	while !completed:
		var cloud_y = randf_range(-get_viewport_rect().size.y / 2.0 - 50, get_viewport_rect().size.y / 2.0 + 50)
		completed = true
		for cloud in last_cloud_y:
			if abs(cloud_y - cloud) < 30:
				completed = false
	
		sprite.position.y = cloud_y
	if last_cloud_y.size() >= 2:
		last_cloud_y.pop_front()
	last_cloud_y.append(sprite.position.y)
	
	sprite.z_index = - 10
	sprite.position.x = x
	sprite.modulate[3] = randf_range(0.3,0.8)
	sprite.scale.x = randf_range(1,2) * [-1,1].pick_random()
	sprite.scale.y = randf_range(1,2)
	add_child(sprite)
