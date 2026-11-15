# Danganmake Title Screen Template

Make your own title screen and main menu for a Danganmake mod.

## How it works

1. Build your title screen in `Menu/scene.tscn` (change anything you like: pictures, fonts, music, animations).
2. Export it as `title_screen.pck` (Project > Export > **Title Screen** > Export PCK/ZIP).
3. Put `title_screen.pck` in your mod's folder, next to `data.txt`.

Players turn it on in Danganmake: **Play**, pick your mod, press **TITLE SCREEN**. From then on, pressing **Play** on your mod opens your title screen (and the last mod turned on also opens when Danganmake starts). It is never on by default.

Danganmake always adds its own **DANGANMAKE** button in the corner, so players can always get back to Danganmake's menu.

## Talking to Danganmake

Keep these in `Menu/scene_script.gd`:

| Signal | What Danganmake does |
| --- | --- |
| `new_game` | Starts the first chapter (or the mod, if it has no chapters) |
| `continue_game` | Continues from the last save |
| `chapter_selected(index)` | Starts that chapter |
| `danganmake_menu` | Goes to Danganmake's menu |

Before the screen shows, Danganmake calls `setup(info)`:

```
{
  "title": "My Mod", "description": "...", "version": "0.3.0",
  "has_save": true,
  "continue_chapter": "Chapter 2",
  "chapters": [{"name": "Chapter 1", "ready": true, "has_save": false}, ...]
}
```

`chapters` is empty when the mod has no chapters.

## Rules

Title screens are checked before they open, and are blocked if they use any of these:

- Files or folders (`FileAccess`, `DirAccess`, `ConfigFile`, `user://`...)
- The system or the window (`OS`, `DisplayServer`, `Engine`, `get_tree()`, `get_viewport()`...)
- Anything outside your own scene (`get_parent()`, `get_node()`, `".."` paths, Danganmake's autoloads)
- Calling things by name (`call()`, `call_deferred()`, `Callable()`, `set_deferred()`...)
- The `Input` singleton (use `_input()` or `_unhandled_input()` instead)
- `CanvasLayer`, `Window` and popups

Use your own nodes (`$Node`, `%UniqueNode`), signals and normal Godot nodes. `Menu/uid_solver` and `Test` are not exported.

## Trying it

Press **F5**: `Test/preview.tscn` opens your title screen with a made up mod (change it in the Inspector) and shows which signal each button sends.

If your mod has the same scene paths as another mod, run `Menu/uid_solver/UID_renevew.gd` (File > Run in the Script editor) to give your files new UIDs.
