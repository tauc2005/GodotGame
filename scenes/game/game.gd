extends Level
class_name Game

signal level_complite(success,score)
signal level_loaded()
signal level_data_changed()
signal level_load_error()

# Загруженные данные уровня 
var lvl_data = null
func _on_ready():
	
	pass
#------------------------------------------------
func startGame():
	if Globals.DEBAG: print ("=== GAME STARTET ===")
	self.visible = true
	resetLevel()
	Player.Lives -=1 
	pass

func exitGame():
	self.visible = false
	clean_level()
	if Globals.DEBAG: print ("=== GAME ENDED ===")
	pass
	
#------------------------------------------------
func InitData():
	lvl_data = Serializer.load_level(Player.Level)
	if lvl_data ==null:
		emit_signal("level_load_error") 	
	Loader.LevelData = lvl_data["rules"]
	Rules.reset_data()
	make_step.connect(_on_make_step)
	score_changed.connect(_on_score_changed)
	# подгружаем карту
	Serializer.deserialize_map(map,lvl_data["tilemap"])
	emit_signal("level_loaded")

func resetLevel():
	init_level(lvl_data["world"])
	screens.CurrentScreen = 0
	Rules.reset_data()
	
func clean_level():
	screens.CurrentScreen = 0
	Rules.reset_data()
	clear_items()
	for tmp in _world.get_children():
		tmp.free()
#------------------------------------------------
# Обработка хода игрока	
func _on_make_step():
	if Globals.DEBAG: 
		print ("(game) -> _on_make_step") 
		#print ("----- GAME - STEP -----")
	Rules.make_step()
	emit_signal("level_data_changed")	# Обновляем UI 
#------------------------------------------------
# Произошло изменение счета
func _on_score_changed(score_delta,block):
	if Globals.DEBAG: print ("(game) -> _on_score_changed") 
	#score +=score_delta
	# Просчет по правилам уровня	
	Rules.update(block,score_delta)
	emit_signal("level_data_changed")	# Обновляем UI 
	# todo
