extends CharacterBody3D
class_name Player

const SPEED := 5.0
const GRAVITY := -200.0

@export var pickup_area:Area3D
@export var score_label:Label3D
@export var master_label:Label3D

@onready var replicator: FusionServerReplicator = $FusionServerReplicator
var _tick: int = 0
#var score: int = 0
var score:int = 0:
	set(value):
		score = value
		_on_score_changed()


func _ready():
	replicator.on_process_input.connect(process_input)
	set_authority_label.call_deferred()

func set_authority_label():
	if replicator.has_input_authority():
		master_label.text = str("Host" if Fusion.is_master_client() else "Client")

func _create_input() -> PackedByteArray:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var buf = PackedByteArray()
	buf.resize(12)
	buf.encode_float(0, dir.x)
	buf.encode_float(4, dir.y)
	buf.encode_u32(8, _tick)
	_tick += 1
	return buf

func _physics_process(delta):
	if replicator.has_input_authority():
		replicator.queue_input(delta, _create_input())
	replicator.process_input_queue(delta)  # runs on all peers: prediction on input-authority, authoritative on server, no-op on remotes

# is_new is true the first time this input runs. It is false during re-simulation
# after a prediction reset. Guard one-shot effects (sounds, particles) behind is_new.
func process_input(_tick: int, delta_time: float, payload: PackedByteArray, _is_new: bool):
	simulate_movement(delta_time, payload)
	simulate_pickups()
	
func simulate_movement(delta_time: float, payload: PackedByteArray):
	var dir_x = payload.decode_float(0)
	var dir_z = payload.decode_float(4)
	velocity = Vector3(dir_x, 0.0, dir_z) * SPEED
	velocity.y += GRAVITY * delta_time
	move_and_slide()

func simulate_pickups():
	for area in pickup_area.get_overlapping_areas():
		if area is Pickup:
			area.collect(self)
			
func receive_score():
	score += 1

func _on_score_changed():
	score_label.text = str(score)
	
