extends Control

signal lifeTimer_finnished

@export var Lives:int = 0 : #_set set_caption
	get: 
		return Lives
	set(value): 
		Lives= value
		$HBoxContainer/TextureRect/LabelLifes.set("text","%d"% Lives)
		
@export var TimerLife:String = "ВСЕ!" : #_set set_caption
	get: 
		return TimerLife
	set(value): 
		TimerLife= value
		$HBoxContainer/Control/NinePatchRect/MarginContainer/LabelTime.set("text","%s"% value)
		
		
