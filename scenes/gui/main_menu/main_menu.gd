extends Control

signal  on_show_gui_window(name)

@onready var ui_top = get_node("MainMenu_Top")
@onready var ui_bottom = get_node("MainMenu_Bottom")
# Called when the node enters the scene tree for the first time.

func _ready():
	ui_bottom.on_startgame_pressed.connect(_on_show_gui_window.bind("game"))
	ui_top.on_show_settings_pressed.connect(_on_show_gui_window.bind("settings"))	
		

	pass
	
func _on_show_gui_window(name):
	emit_signal("on_show_gui_window",name)	
	pass
