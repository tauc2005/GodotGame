extends Node2D

signal level_complite(success,score)
signal level_loaded()
signal level_data_changed()

# Элементы GUI
@onready var level= get_node("Level")
@onready var world= get_node("Level/World")
@onready var items= get_node("Level/Items")


#------------------------------------------------
# Данные об уровне, полученнные с сервера для формирования уровня
var _level_data = null

# Called when the node enters the scene tree for the first time.
func _ready():
	level.set_item_node(get_node("Level/Items"))
	level.set_world_node(get_node("Level/World"))
	pass # Replace with function body.


func startGame():
	if Globals.DEBAG: print ("=== GAME STARTET ===")
	level.reset_level()
	load_level()
	pass

func exitGame():
	level.reset_level()
	
	
#------------------------------------------------		
# Формирование уровня из json
func load_level():
	var _level_numb = 1 #TODO
	
	# Загружаем данные уровня (Правила проверки)
	_level_data = Loader.load_level_from_file(_level_numb)
	if (_level_data ==null):
		return false
		
	if _level_data.has("world"):	
		# Генерируем уровень
		level.init_level(_level_data["world"])
	else:
		printerr ("Нет данных о карте уровня")	
	# Загружаем правила победы TODO
	#load_rules()
	#load_bonus()
	emit_signal("level_loaded")

