extends Card

class_name GuardianAngelCard

func init():
	G.GS.connect("next_stage_started", get_shield)
	default_init()

func apply():
	return

func get_shield():
	G.player.get_shield(2)

#translate
func get_text():
	return ["Guardian angel", "Start every stage with 2 shield bonus"]
