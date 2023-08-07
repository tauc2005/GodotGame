extends Object
class_name RuleItem

# Тип правила
var type 
# Стартовое значение
var default
# Текущее значение
var value:int
#-----------------
func _ready():
	pass # Replace with function body.
#-----------------
func _init (rule, _value:int):#,_target=0):
	type = rule
	value = _value
	default = _value
#-----------------	
# Сброс пройденного прогресса
func reset():
	value = default
