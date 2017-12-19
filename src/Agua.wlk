import Cosas.*

class Agua inherits CosaQueDania{
	
	constructor(_posicion) = super(10, _posicion, "water.png")//Por simplicidad, vamos a decir que el agua ahoga: Y es decir hace 10 puntos de danio cuando el pj colisiona con ella.

}

class AguaProfunda inherits Agua{
	
	override method accion(personaje){
		personaje.direccion().moverAlOpuesto()
		game.say(personaje, "Este rio es imposible de cruzar! Debo buscar otra forma." ) 
	}
}

class AguaBaja inherits Agua{
	//Completitud
}