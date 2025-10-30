extends StaticBody2D

@export var texto_interaccion := "Has interactuado con %s"
@export var una_vez := false
@export var desaparecer := true

var usado := false

func interactuar() -> void:
	if una_vez and usado:
		return
	usado = true
	print(texto_interaccion % name)
	if desaparecer:
		queue_free()
