extends Node2D
## 
signal level_complite(success,score)
signal level_loaded()
signal level_data_changed()

# Элементы GUI
@onready var level= get_node("Level")
@onready var world= get_node("Level/World")
@onready var items= get_node("Level/Items")
@onready var rules= get_node("Level/Rules")

#------------------------------------------------
# Данные об уровне, полученнные с сервера для формирования уровня
var _level_data = null
#------------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	level.set_item_node(get_node("Level/Items"))
	level.set_world_node(get_node("Level/World"))
	
	level.make_step.connect(_on_make_step)
	level.score_changed.connect(_on_score_changed)
	
	

#------------------------------------------------
## Запуск и выход из игры
#------------------------------------------------
func startGame():
	if Globals.DEBAG: print ("=== GAME STARTET ===")
	rules.reset_data()
	level.reset_level()
	load_level()
	Player.Lives -=1 
	pass

func exitGame():
	level.reset_level()
	Rules.reset_data()
	
#------------------------------------------------		
# Формирование уровня из загруженных данных
func load_level():
	var _level_id = Player.Level
	
	# Загружаем данные уровня (Правила проверки)
	_level_data = Loader.get_level_data("world")
	if (not _level_data):
		printerr ("(game) ---> Нет данных о карте уровня")	
		return false
	# Генерируем уровень
	level.init_level(_level_data)
	
	# Загружаем правила победы TODO
	load_rules()
	#load_bonus()
	emit_signal("level_loaded")
#------------------------------------------------
func load_rules():
	var _data = Loader.get_level_data("rules")

#------------------------------------------------
#------------------------------------------------	
func _on_make_step():
	if Globals.DEBAG: 
		print ("(game) -> _on_make_step") 
		#print ("----- GAME - STEP -----")
	Rules.make_step()
	emit_signal("level_data_changed")	# Обновляем UI 
	# todo
	#check_generator_rule()	
	
#------------------------------------------------
# Произошло изменение счета
func _on_score_changed(score_delta,block):
	if Globals.DEBAG: print ("(game) -> _on_score_changed") 
	#score +=score_delta
	# Просчет по правилам уровня	
	Rules.update(block,score_delta)
	emit_signal("level_data_changed")	# Обновляем UI 
	# todo
#------------------------------------------------

