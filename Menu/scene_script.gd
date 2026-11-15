extends Control

## The title screen of a Danganmake mod.
##
## Danganmake opens this scene when the player presses Play on a mod whose title
## screen is turned on in Danganmake's Mod Maker. It talks to Danganmake only through the four signals below,
## and Danganmake tells it about the mod through setup(). Change the look as much as
## you like: only keep the signals and setup().
##
## Danganmake always adds its own DANGANMAKE button on top, so the player can always
## get back to Danganmake's menu.

## Start from the beginning (the first chapter, or the mod if it has no chapters).
signal new_game
## Carry on from the last save.
signal continue_game
## Start one chapter (its place in info.chapters, starting at 0).
signal chapter_selected(index: int)
## Go to Danganmake's own menu.
signal danganmake_menu

@onready var title_label: Label = %Title
@onready var main_buttons: VBoxContainer = %MainButtons
@onready var btn_new: Button = %NewGame
@onready var btn_continue: Button = %Continue
@onready var btn_chapters: Button = %Chapters
@onready var btn_danganmake: Button = %Danganmake
@onready var chapter_panel: Control = %ChapterPanel
@onready var chapter_list: VBoxContainer = %ChapterList
@onready var chapter_template: Button = %ChapterButton
@onready var btn_back: Button = %Back

var info: Dictionary = {}

func _ready() -> void:
	chapter_panel.visible = false
	chapter_template.visible = false
	btn_new.pressed.connect(func(): new_game.emit())
	btn_continue.pressed.connect(func(): continue_game.emit())
	btn_chapters.pressed.connect(_show_chapters)
	btn_danganmake.pressed.connect(func(): danganmake_menu.emit())
	btn_back.pressed.connect(_hide_chapters)
	btn_new.grab_focus()

## Danganmake calls this before the screen shows:
## {
##   "title": String, "description": String, "version": String,
##   "has_save": bool,  (there is something to continue)
##   "continue_chapter": String,  (name of the chapter Continue opens, "" if none)
##   "chapters": [{"name": String, "ready": bool, "has_save": bool}, ...]  (empty if no chapters)
## }
func setup(mod_info: Dictionary) -> void:
	info = mod_info
	if not is_node_ready():
		await ready
	title_label.text = str(info.get("title", ""))
	btn_continue.disabled = not bool(info.get("has_save", false))
	btn_chapters.visible = not (info.get("chapters", []) as Array).is_empty()

func _show_chapters() -> void:
	for b in chapter_list.get_children():
		if b != chapter_template:
			b.queue_free()
	var chapters : Array = info.get("chapters", [])
	for i in chapters.size():
		var b : Button = chapter_template.duplicate()
		b.visible = true
		b.text = str(chapters[i].get("name", ""))
		b.disabled = not bool(chapters[i].get("ready", false))
		var index := i
		b.pressed.connect(func(): chapter_selected.emit(index))
		chapter_list.add_child(b)
	main_buttons.visible = false
	chapter_panel.visible = true
	btn_back.grab_focus()

func _hide_chapters() -> void:
	chapter_panel.visible = false
	main_buttons.visible = true
	btn_chapters.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and chapter_panel.visible:
		accept_event()
		_hide_chapters()
