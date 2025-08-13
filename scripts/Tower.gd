extends Node2D
class_name Tower

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.6
@export var damage: int = 3

var targets: Array[Node] = []
var _timer := Timer.new()

func _ready():
    add_child(_timer)
    _timer.wait_time = fire_rate
    _timer.timeout.connect(_on_fire)
    _timer.start()
    $Area2D.body_entered.connect(_on_enter)
    $Area2D.body_exited.connect(_on_exit)

func _on_enter(body):
    if body is Enemy:
        targets.append(body)

func _on_exit(body):
    targets.erase(body)

func _on_fire():
    targets = targets.filter(func(e): return is_instance_valid(e))
    if targets.is_empty(): return
    var target: Enemy = targets[0]
    var b = bullet_scene.instantiate()
    b.global_position = global_position
    b.target = target
    b.damage = damage
    get_tree().current_scene.add_child(b)
