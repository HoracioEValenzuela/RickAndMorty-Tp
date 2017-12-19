import Cosas.*

class PiedraArriba inherits CosaArriba{
	constructor(_posicion) = super(_posicion, "stone.png")
}

class PiedraAbajo inherits CosaAbajo{
	constructor(_posicion) = super(_posicion, "stone.png")
}

class PiedraDerecha inherits CosaDerecha{
		constructor(_posicion) = super(_posicion, "stone.png")
}

class PiedraIzquierda inherits CosaIzquierda{
	constructor(_posicion) = super(_posicion, "stone.png")
}

class PiedraInflanqueable inherits Obstaculo{//Obstaculo
	
	constructor(_posicion) = super(_posicion, "stone.png")

}

//Necesitaria crear Factories? Exclarece algo?
