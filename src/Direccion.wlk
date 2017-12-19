class Direccion{
	const sentido
	const individuo

		constructor(_sentido, _individuo){//El sentido solo es conceptual. Sirve de algo?
			sentido = _sentido
			individuo = _individuo
		}	
			method sentido() = sentido

			method individuo() = individuo

			method moverAlOpuesto() 
			
			method moverEnSentido()

			method uno() = 1
}

class Abajo inherits Direccion{

	constructor(_individuo) = super("Abajo", _individuo)
	
		override method moverAlOpuesto(){
			individuo.getPosicion().moveUp(self.uno())
		} 

		override method moverEnSentido() {
			individuo.getPosicion().moveDown(self.uno())
		} 
}

class Arriba inherits Direccion{

	constructor(_individuo) = super("Arriba", _individuo)
		
		override method moverAlOpuesto(){
			individuo.getPosicion().moveDown(self.uno())
		}	 


		override method moverEnSentido() {
			individuo.getPosicion().moveUp(self.uno())		
		}
}


class Izquierda inherits Direccion{

	constructor(_individuo) = super("Izquierda", _individuo)

		override method moverAlOpuesto(){
			individuo.getPosicion().moveRight(self.uno())
		}

		override method moverEnSentido() {
			individuo.getPosicion().moveLeft(self.uno())
		}		
}

class Derecha inherits Direccion{

	constructor(_individuo) = super("Derecha", _individuo)

		override method moverAlOpuesto(){
			individuo.getPosicion().moveLeft(self.uno())
		}

		override method moverEnSentido() {
			individuo.getPosicion().moveRight(self.uno())
		}
}

