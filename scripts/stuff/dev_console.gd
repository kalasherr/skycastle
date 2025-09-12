extends Node2D

class_name DevConsole

var lineedit
var accept

func _ready():
	self.visible = false
	name = "Console"
	lineedit = LineEdit.new()
	G.CONSOLE = self
	add_child(lineedit)
	lineedit.size = Vector2(400,30)
	lineedit.position = - get_viewport_rect().size / 2 / G.GS.camera.zoom.x + Vector2(100,100)
	accept = Button.new()
	add_child(accept)
	accept.size = Vector2(30,31)
	accept.position = lineedit.position + Vector2(500,0)
	accept.connect("pressed", call_function)
	
func _process(delta):
	input_check()
	lineedit.global_position = G.GS.camera.global_position + Vector2(-210,0)
	accept.global_position =  G.GS.camera.global_position + Vector2(200,0)
	
func open_console():
	if visible:
		visible = false
	else:
		visible = true

func input_check():
	if Input.is_action_just_pressed("ui_down"):
		open_console()

func call_function():
	var text = lineedit.text
	var function = ""
	var argument = ""
	var space = false
	for i in range(0,len(text)):
		if !space:
			if text[i] != " ":
				function += text[i]
			else:
				space = true
		else:
			argument += text[i]
	if argument == "":
		G.GS.call(function)
	else:
		G.GS.call(function, argument)
