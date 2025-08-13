extends Node
class_name WaveManager

##
## Singleton responsible for spawning waves of enemies.
##
## Configure the `waves` array with dictionaries that define the
## number of enemies, their hitpoints, movement speed and spawn gap.
## Set `enemy_scene` to the PackedScene of your enemy and
## `spawn_path` to the Path2D node used for movement.  Call
## `start_waves()` to begin the sequence.  Signals are emitted
## when waves start and clear.

signal wave_started(index: int)
signal wave_cleared(index: int)

var current_wave: int = -1
var active_enemies: int = 0
var waves: Array[Dictionary] = []

@export var enemy_scene: PackedScene
@export var spawn_path: NodePath ## Path2D in the level used for spawning

var _spawn_timer := Timer.new()

func _ready() -> void:
    add_child(_spawn_timer)
    _spawn_timer.timeout.connect(_spawn_tick)

func start_waves() -> void:
    current_wave = -1
    _next_wave()

func _next_wave() -> void:
    current_wave += 1
    if current_wave >= waves.size():
        # level complete
        get_tree().change_scene_to_file("res://scenes/ui/Victory.tscn")
        return
    wave_started.emit(current_wave)
    var w: Dictionary = waves[current_wave]
    _queue_spawns(w.count, w)

func _queue_spawns(count: int, w: Dictionary) -> void:
    _spawn_timer.wait_time = w.get("spawn_gap", 0.6)
    _spawn_timer.start()
    # store metadata on the timer to keep track of spawns left and config
    _spawn_timer.call_deferred("set_meta", "spawns_left", count)
    _spawn_timer.set_meta("wave_cfg", w)

func _spawn_tick() -> void:
    var left: int = int(_spawn_timer.get_meta("spawns_left"))
    var w: Dictionary = _spawn_timer.get_meta("wave_cfg")
    if left <= 0:
        _spawn_timer.stop()
        return
    var path: Path2D = get_node_or_null(spawn_path)
    if path:
        var e: Node = enemy_scene.instantiate()
        # Set stats on the enemy instance
        e.hp = w.get("hp", 10)
        e.move_speed = w.get("speed", 90.0)
        e.tree_exited.connect(_on_enemy_despawn)
        path.add_child(e) # Enemy expects to be child of Path2D
        active_enemies += 1
    _spawn_timer.set_meta("spawns_left", left - 1)
    if left - 1 == 0:
        # schedule a check for wave clear on next frame
        await get_tree().create_timer(0.1).timeout
        _check_wave_clear()

func _on_enemy_despawn() -> void:
    active_enemies = max(0, active_enemies - 1)
    _check_wave_clear()

func _check_wave_clear() -> void:
    if active_enemies == 0 and _spawn_timer.is_stopped():
        wave_cleared.emit(current_wave)
        Economy.add_coins(25)
        _next_wave()
