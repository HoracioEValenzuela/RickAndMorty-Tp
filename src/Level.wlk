
import wollok.game.* //Ya esta
import Piedras.* //Ya esta
import Arbol.*
import Cactus.*
import Agua.*
import Personaje.* //Ya CASI esta

object level{
	
	method primeraConfiguracionTablero(){
		//CONFIGURACION:	
			game.title("Rick and Morty: The Game")
			game.height(48)
			game.width(48)
			game.ground("ground.png")
	}

	method agregarVisuales(){	
		//VISUAL:
			game.addVisualCharacter(personaje)
			//Falta alguna visual mas poner en este momento?
	}

	method definirPiedrasHorizontales(){
		const anchoCerco = game.width() - 1
		const largoCerco = game.height() - 1
		
			//Horizontal:	
				(1 .. anchoCerco).forEach { n => new PiedraAbajo(new Position(n, 1)) } //Borde Abajo
					//-1 para que tenga una salida.
				(1 .. anchoCerco-1).forEach { n => new PiedraArriba(new Position(n, largoCerco-1)) } //Borde Arriba
	}
	 
 	method definirPiedrasVerticales(){
		const anchoCerco = game.width() - 1
		const largoCerco = game.height() - 1
		
			//Vertical:
			//A partir de 2 para que no se pise con las horizontales.
				(2 .. largoCerco-2).forEach { n => new PiedraIzquierda(new Position(1, n)) } //Borde Izquierda		
				(2 .. largoCerco-2).forEach { n => new PiedraDerecha(new Position(anchoCerco-1, n)) } //Borde Derecha
	}
	
/*
  	method definirPiedras(anchoOLargo, n1, _piedra){//Ver si sirve para eleminitar la repeticion de codigo
		const anchuraOAltura  = anchoOLargo - 1
			(n1 .. anchuraOAltura).forEach { n => _piedra}
	}
*/

	method definirCercoDePiedras(){
		//CERCO DE PIEDRAS:
			self.definirPiedrasHorizontales()
			self.definirPiedrasVerticales()
	}
	
	method gameOver(){
		game.clear()
		game.title("Rick and Morty: The Game")
		game.height(48)
		game.width(48)
		game.ground("groundGameOver.png")
		game.addVisual(gameOver)
		V.onPressDo{self.primeraConfiguracionTablero()} // "V" para volver a jugar
		X.onPressDo{game.stop()} // "X" para salir. 
	}
	
	method agregarVisuales(){
		
	}
	
	method configuration(){
		self.primeraConfiguracionTablero()
		self.definirCercoDePiedras()	
		self.agregarVisuales()
			//Falta poner los elementos estaticas en posiciones determinadas.
			//Falta poner los materialesSimples en posiciones randomicas.  
	
		//TECLADO:
			W.onPressDo { personaje.moverHaciaArriba() }
			A.onPressDo { personaje.moverHaciaIzquierda() }
			D.onPressDo { personaje.moverHaciaDerecha() }
			S.onPressDo { personaje.moverHaciaAbajo() }
			//No necesito esto siel material sabe que hacer cuando se coliciona. R.onPressDo { personaje.recolectar() }		  
	}
}