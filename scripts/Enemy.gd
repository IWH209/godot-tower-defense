extends PathFollow2D
class_name Enemy

##
## Component for enemy behaviour.
##
## Enemies follow a `Path2D` via their parent `PathFollow2D` node.  On
## each physics tick they advance along the path by `move_speed`.
## Once the end of the path is reached the base is damaged.  Enemies
## can take damage via `apply_damage()` and drop coins on death.

@export var move_speed: float = 90.0
@export var hp: int = 10
@export var base_damage: int = 1

func _physics_process(delta: float) -> void:
    progress += move_speed * delta
    if progress_ratio >= 1.0:
        Economy.damage_base(base_damage)
        queue_free()

func apply_damage(dmg: int) -> void:
    hp -= dmg
    if hp <= 0:
        Economy.add_coins(5)
        queue_free()
