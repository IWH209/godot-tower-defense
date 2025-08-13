extends Node
class_name Economy

##
## Singleton for game economy and base health.
##
## Provides signals when coins or lives change.  Use `add_coins()`
## to increase coins (rewarding the player) and `spend_coins()` to
## deduct coins when building towers.  The `damage_base()` method
## reduces lives and triggers a game over scene when lives reach zero.

signal coins_changed(value: int)
signal lives_changed(value: int)

var coins: int = 100 setget _set_coins
var lives: int = 20 setget _set_lives

func add_coins(v: int) -> void:
    _set_coins(coins + v)

func spend_coins(v: int) -> bool:
    if coins >= v:
        _set_coins(coins - v)
        return true
    return false

func damage_base(v: int) -> void:
    _set_lives(lives - v)
    if lives <= 0:
        get_tree().change_scene_to_file("res://scenes/ui/GameOver.tscn")

func _set_coins(v: int) -> void:
    coins = max(v, 0)
    coins_changed.emit(coins)

func _set_lives(v: int) -> void:
    lives = max(v, 0)
    lives_changed.emit(lives)
