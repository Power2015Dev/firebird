extends Control

## Try the title screen without Danganmake: press F5 (this scene is the main scene).
## It shows the title screen with a made up mod and prints what each button does.
## This folder is not exported.

const MENU := preload("res://Menu/scene.tscn")

@export var title := "My Danganronpa Mod"
@export var has_save := true
@export var chapters := PackedStringArray(["Prologue", "Chapter 1", "Chapter 2"])

@onready var log_label: Label = $Log

func _ready() -> void:
	var menu := MENU.instantiate()
	add_child(menu)
	move_child(menu, 0)
	var list : Array = []
	for i in chapters.size():
		list.append({"name": chapters[i], "ready": i < 2, "has_save": i == 0})
	menu.setup({"title": title, "description": "", "version": "", "has_save": has_save, "continue_chapter": chapters[0] if has_save and chapters.size() > 0 else "", "chapters": list})
	menu.new_game.connect(func(): _log("new_game"))
	menu.continue_game.connect(func(): _log("continue_game"))
	menu.chapter_selected.connect(func(i): _log("chapter_selected(%d)" % i))
	menu.danganmake_menu.connect(func(): _log("danganmake_menu"))

func _log(text: String) -> void:
	print(text)
	log_label.text = text
