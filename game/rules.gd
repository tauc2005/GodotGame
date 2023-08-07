extends Node 
#const RuleItem = preload("res://interface/game/rule.gd")
#-----------------
# Сигнал о завершении уровня
signal level_complite()
signal left_5_step()
#-----------------
# Правила проверки выигрыша на уровне
var _rules = {} #setget , get_rules
var _moves = 0 #setget ,get_moves
#-----------------
#var _bonus = {} setget , get_bonus
# получаем правила
func get_rules ():
	return _rules

#-----------------	
# Сброс игрового прогресса

func reset():
	print ("(rules) -> reset")
	for rule  in get_rules():
		print( "!!!!! ---- ", rule)
		#_rules[rule].reset 
	pass	
	
#-----------------
func _ready():
	pass # Replace with function body.
#-----------------
func init_rules(data):
	for rule in data:
		var value = data[rule]
		_rules[rule] = RuleItem.new(Globals.get_rule_type(rule),value)
#-----------------
# Проверяем пройден ли уровень
func is_level_complite():
	var finished = true 
	for rule in _rules:
		finished = finished and (_rules[rule].value==0)
	return finished
#-----------------
# Завершение уровня
func check_finished():
	if _moves == 0:
		if is_level_complite():
			_on_level_complite(true)
		else:# Ходы закончились
			_on_level_complite(false)
	else:
		if (is_level_complite()):
			_on_level_complite(true)
			
# success - выйграл ли игрок true/false# 
func _on_level_complite(success:bool = false):
	var res = "win" if success else "lose"
	print ("level complite: %s - %s " % [success, res])
	emit_signal("level_complite",success)


#------------------------------------------------
# Проверка правил
#------------------------------------------------
# Определение правила подсчета очков в зависимости от объекта
func update(item,score_delta=0):
	var rule = item.get_type()
	if rule == "ball":
		rule = "ball%s" % item.get_color()
	_update_rule(rule,score_delta)
	check_finished()
#------------------------------------------------
# Правило зачета очков для базового типа  
func _update_rule(rule, score_delta:int):
	if _rules.has(rule):
		if int(_rules[rule].value) < score_delta :
			_rules[rule].value =0
		else:	
			_rules[rule].value -=  int (score_delta)
	else:
		print ("No rule for ",rule, " in this level")	
#------------------------------------------------
	
#------------------------------------------------
# Правила подсчета сделанных ходов	
#------------------------------------------------
func make_step ():
	_moves -=  1
	if _moves<0: _moves = 0
	if _moves ==5: 
		if Globals.DEBAG: print ("	EMIT signal 'make_step'")
		emit_signal("left_5_step")
	check_finished()
#------------------------------------------------	
func add_moves(count:int):
	_moves += count
func set_moves(value:int):
	_moves = value	
	if _moves<0: _moves = 0
func get_moves():
	return _moves
#------------------------------------------------
