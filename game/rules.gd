extends Node
class_name GameRules

#-------------------------
# Сигнал о завершении уровня
# Изменилось кол-во ходов
signal on_moves_changed(moves_left)
# Осталось 5 ходов
signal on_left_5_step()
# Уровень закончен true-пройден, false - провал
signal on_level_complited(result)
#-------------------------
# Ходы
var Moves:int=0:
	get:
		return Moves
	set(new_value):
		if new_value >0:
			Moves = new_value	
		else: 
			Moves = 0	
		emit_signal("on_moves_changed",Moves)	


# Условия победы
var Values=[]

#var _bonus = {} setget , get_bonus

#-------------------------

func _ready():
	Values = {
		1: Globals.RuleItem.new(Globals.RULE_TYPE.NONE,0),
		2: Globals.RuleItem.new(Globals.RULE_TYPE.NONE,0),
		3: Globals.RuleItem.new(Globals.RULE_TYPE.NONE,0)
	}

	
#-------------------------
# Сброс игрового прогресса	
#-------------------------
func reset_data():
	print ("(rules) -> reset data")
	Moves = Loader.get_level_data("moves")
	var _items = Loader.get_level_data("rules")
	
	if (!_items):
		return
	for i in Values:
		Values[i].set_data(Globals.RULE_TYPE.NONE,0)
	var i=1
	for _type in _items:
		var _value = _items[_type]
		Values[i].set_data(Globals.get_rule_type(_type),_value) 
		i+=1

#------------------------------------------------
# Проверка правил
#------------------------------------------------
# Определение правила подсчета очков в зависимости от объекта
func update(item,score_delta=0):
	var rule_type = item.get_type()
	if rule_type == "ball":
		rule_type = "ball%s" % item.get_color()
	_update_rule(rule_type,score_delta)
	check_finished() 
#------------------------------------------------
# Правило зачета очков для базового типа  
func _update_rule(rule_type, score_delta:int):
	for i in Values:		
		if Values[i].Type == Globals.get_rule_type(rule_type):
			if int(Values[i].Value) < score_delta :
				Values[i].Value =0
			else:	
				Values[i].Value -=  int (score_delta)
			return true
	print ("No rule for ",rule_type, " in this level")	
	return false
#------------------------------------------------

#------------------------------------------------
# Правила подсчета сделанных ходов	
#------------------------------------------------
func make_step ():
	Moves -=  1
	if Moves ==5: 
		if Globals.DEBAG: print ("	EMIT signal 'make_step'")
		emit_signal("on_left_5_step")
	check_finished() 
	print ("--- Moves left = %s" % Moves)
#------------------------------------------------	
func add_moves(count:int):
	Moves += count
#------------------------------------------------
#-----------------
# Завершение уровня
func check_finished():
	if Moves <= 0:
		if is_level_complite():
			_on_level_complite(true)
		else:# Ходы закончились
			_on_level_complite(false)
	else:
		if (is_level_complite()):
			_on_level_complite(true)

#-----------------
# Проверяем пройден ли уровень
func is_level_complite():
	var finished = true 
	for i in Values:
		finished = finished and (Values[i].Value==0)
	return finished
			
# success - выйграл ли игрок true/false# 
func _on_level_complite(success:bool = false):
	var res = "win" if success else "lose"
	print ("level complite: %s - %s " % [success, res])
	emit_signal("on_level_complited",success)


