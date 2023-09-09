extends Control

signal  on_show_gui_window(wnd_name)

@onready var ui_top = get_node("MainMenu_Top")
@onready var ui_bottom = get_node("MainMenu_Bottom")

#@onready var life_timer = ui_top.LifeHolder
# Called when the node enters the scene tree for the first time.

func _ready():
	ui_bottom.on_startgame_pressed.connect(_before_game_start)
	ui_top.on_show_settings_pressed.connect(_on_show_gui_window.bind("settings"))	


	
func _on_show_gui_window(wnd_name):
	emit_signal("on_show_gui_window",wnd_name)	

func _before_game_start():
	_on_show_gui_window("before_game")
	
func update(type:String,value:int):
	match type:
		"Lives": ui_top.set_lives(value)
		"Money": ui_top.set_money(value)
