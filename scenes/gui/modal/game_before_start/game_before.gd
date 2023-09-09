extends Control

signal on_window_closed()
signal on_game_start()

@onready var modal = get_node("SizeBox/ModalWindow")
@onready var RuleBox = get_node("SizeBox/ModalWindow/Box/VBoxContainer/RulesBoxMargin/NinePatchRect/MarginContainer/RuleBox") 

@onready var  _rules = {
	1: RuleBox.get_node("rule1"),
	2: RuleBox.get_node("rule2"),
	3: RuleBox.get_node("rule3")
}
@export var Level:int = 0 : #_set set_caption
	get: 
		return Level
	set(value): 
		Level= value
		if modal:
			modal.set("Caption","Уровень %d"% Level)

func _ready():
	modal.on_window_closed.connect(_on_window_closed)
	for i in _rules:
		Rules.Values[i].data_init.connect(_rules[i].update_item)
	#Rules.on_moves_changed.connect(set_moves)
	
	pass
	
func _on_window_closed():
	if Globals.DEBAG:print ("(gamebefore) _on_window_closed ")
	emit_signal("on_window_closed")
	pass
	
func _on_bg_focus_entered():
	emit_signal("on_window_closed")
	pass # Replace with function body.	

func _on_btn_start_pressed():
	if Globals.DEBAG:print ("(gamebefore) _on_btn_start_pressed ")
	emit_signal("on_window_closed")
	emit_signal("on_game_start")
	pass # Replace with function body.

