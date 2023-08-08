extends Control

@export var Money:int = 0 : #_set set_caption
	get: 
		return Money
	set(value): 
		Money= value
		$HBoxContainer/Control/NinePatchRect/MarginContainer/MoneyValue.set("text","%d"% Money)
