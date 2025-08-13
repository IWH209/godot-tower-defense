extends Node2D
class_name Bullet

@export var speed: float = 400.0
var target: Enemy
var damage:int = 1

func _physics_process(delta):
    if not is_instance_valid(target):
        queue_free(); return
    var dir = (target.global_position - global_position).normalized()
    position += dir * speed * delta
    if global_position.distance_to(target.global_position) < 8.0:
        target.apply_damage(damage)
        queue_free()
