extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	# Añadimos el objeto a un grupo para ser detectado por el jugador
	add_to_group("inter")

# Método interactuar que se llama desde el jugador
func interactuar():
	print("¡Interacción exitosa con el objeto!")
	# Aquí puedes poner la lógica de lo que sucede cuando el jugador interactúa
	# Ejemplo: cambiar el estado del objeto o mostrar un mensaje.
