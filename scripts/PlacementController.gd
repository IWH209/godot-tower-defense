extends Node2D
class_name PlacementController

@export var tower_cost:int = 25
@export var tower_scene:PackedScene

var can_place := true

func _unhandled_input(event):
    if event.is_action_pressed("place_tower"):
        if not can_place: return
        if Economy.spend_coins(tower_cost):
            var t = tower_scene.instantiate()
            t.global_position = get_global_mouse_position().snapped(Vector2(16,16)) # snap to grid
            add_child(t)
