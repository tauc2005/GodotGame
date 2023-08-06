extends Control

signal  on_show_gui_window(wnd_name)

@onready var ui_top = get_node("GameMenu_Top")
#@onready var ui_bottom = get_node("GameMenu_Bottom")
# Called when the node enters the scene tree for the first time.

func _ready():
	ui_top.on_backtomain_pressed.connect(_on_show_gui_window.bind("main"))
	ui_top.on_show_settings_pressed.connect(_on_show_gui_window.bind("settings"))	
		

	pass
	
func _on_show_gui_window(wnd_name):
	emit_signal("on_show_gui_window",wnd_name)	
	pass
