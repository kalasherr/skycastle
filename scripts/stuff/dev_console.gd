extends Node2D

class_name DevConsole

var lineedit
var accept

func _ready():
	name = "Console"
	lineedit = LineEdit.new()
	G.CONSOLE = self
	add_child(lineedit)
	lineedit.size = Vector2(500,30)
	lineedit.position = - get_viewport_rect().size / 2 / G.GS.camera.zoom.x + Vector2(100,100)
	accept = Button.new()
	add_child(accept)
	accept.size = Vector2(30,30)
	accept.position = lineedit.position + Vector2(500,0)
	accept.connect("pressed", call_function)
	
func _process(delta):
	input_check()
	lineedit.position = - get_viewport_rect().size / 2 / G.GS.camera.zoom.x + Vector2(100,100)
	
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
	G.GS.call(function, argument)
