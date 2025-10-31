extends CharacterBody2D
class_name Enemy

# Configuración de velocidad
var speed = 190

# Variable para el jugador
var player = null

# Inicialización del nodo
func _ready():
	# Obtiene el primer nodo del grupo "player"
	player = get_tree().get_nodes_in_group("player")[0]

# Función principal de actualización
func _process(delta: float) -> void:
	follow_player()

# Mueve al enemigo hacia el jugador
func follow_player():
	if player != null:
		# Calcula la dirección hacia el jugador y aplica la velocidad
		velocity = position.direction_to(player.position) * speed
		move_and_slide()

# Destructor del enemigo
func destroy():
	queue_free()
