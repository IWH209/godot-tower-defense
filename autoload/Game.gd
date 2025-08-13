extends Node
class_name Game

##
## Singleton for global game state.
##
## This script manages pause state and exposes a random number generator
## that can be used throughout the game.  When `is_paused` is toggled
## the engine's `get_tree().paused` property is also updated and a
## signal is emitted.

signal game_paused_changed(paused: bool)

var is_paused: bool = false setget set_paused
var rng := RandomNumberGenerator.new()

func _ready() -> void:
    rng.randomize()

func set_paused(v: bool) -> void:
    if is_paused == v:
        return
    is_paused = v
    get_tree().paused = v
    game_paused_changed.emit(v)
