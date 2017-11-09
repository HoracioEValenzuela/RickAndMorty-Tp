///////////////////////////////////////////////// Personajes /////////////////////////////////////////////////

class Personaje{//Clase creada por comodidad para juntar el comportamiento en comun de Rick y de Morty.
	var mochila = #{}
	
			//Dado una coleccion de objetos, los guarda en la mochila. No pedido, agregado por comodidad a la hora de hacer el test.
		method recibir(unosObjetos){
			mochila.addAll(unosObjetos)
		}	
		
			//Dado un material, lo guarda en la mochila. 
		method meterEnLaMochila(unMaterial){
			mochila.add(unMaterial)	
		}
		
		method sacarDeLaMochila(unosObjetos){
			mochila.removeAll(unosObjetos)
		}
}

object morty inherits Personaje{
	
	var energia = 100 //Inicialmente, Morty empieza con 100 de energia. Esto puede variar.
		
		/*
		method recibir(unosObjetos){
			mochila.addAll(unosObjetos)//No pedido para Morty, pero lo agregamos por comodidad a la hora de realizar el test.
		}
		*/
		
			//Dada una cantidad, disminuye la energia de Morty en dicho valor.
		method disminuirEnergia(unaCantidad){
			energia = (energia  - unaCantidad).max(0)
		}
		
			//Dada una cantidad, aumenta la energia de Morty en dicho valor.
		method aumentarEnergia(unaCantidad){
			energia += unaCantidad //Nada habla sobe un limite de energia.Sino .min(limiteDeEnergia)
		}
		
			//Dado un material, retorna "True" en caso de que Morty pueda recolectar dicho material. Caso contrario retorna "False". 
		method puedeRecolectar(unMaterial) = self.tieneLugarenLaMochila() && self.tieneEnergiaParaLevantar(unMaterial)
		
			//Retorna "True" si Morty tiene lugar en su mochila. Es decir, menos de 3 materiales. Caso contrario, retorna "False".
		method tieneLugarenLaMochila() = mochila.size() < 3
		
			//Dado un material, retorna "True" si Morty tiene energia para recolectar dicho material.
		method tieneEnergiaParaLevantar(unMaterial) = energia >= unMaterial.cuantaEnergiaSeNecesitaParaRecolectarlo()
			
			//Dado un material, si Morty puede recogerlo, lo agrega a su mochila, caso contrario, tira un error avisando que no es posible realizar dicha accion. 
		method recolectar(unMaterial){
			if(!self.puedeRecolectar(unMaterial)){
				self.error("Morty no puede recolectar el material en este momento.")
			}
			//Dudas sobre esta parte. De quien es la responsabilidad?
			self.meterEnLaMochila(unMaterial)
			unMaterial.loQueVariaLaEnergiaCuandoLoRecoge(self) //No estoy seguro de esta parte
		}
		
			//Dado un companiero, agrega la mochila de Morty al inventario/mochila de dicho companiero. 
		method darObjetos(unCompaniero){
			unCompaniero.recibirObjetos(mochila) //El companiero de Morty debe entender este mensaje
			self.descartarObjetos()
		}
		
			//Vacia la mochila de Morty.
		method descartarObjetos(){
			mochila = #{}
		}
}


///////////////////////////////////////////////// Materiales /////////////////////////////////////////////////
 
class Material{
				
			method esRadioactivo() = false //A excepcion del Fleeb, los materiales no son radioactivos.
			
			method electricidadGenerada() = 0 //Esto esta bien? 
				
				//Segun enunciado la cantidad de energia necesaria para recolectar un material es igual a la cantidad de gramos de metal de dicho material.	
			method cuantaEnergiaSeNecesitaParaRecolectarlo() = self.cantMetal()
			
				//Dada un "alguien", disminuye la energia del mismo, en cuanto a la energia que se necesita para recoger al material.
			method loQueVariaLaEnergiaCuandoLoRecoge(alguien){
				if(self.esRadioactivo()){
					alguien.disminuirEnergia(self.cuantaEnergiaSeNecesitaParaRecolectarlo())//Esta bien esta responsabilidad??
				}
			}
			
			method generaElectricidad() = self.electricidadGenerada() > 0 //Esto esta bien? 
			
			method conduceElectricidad() = self.nivelDeConductividad() > 0 //Esto esta bien? 
			
			method cantMetal() //Abstracto - Si bien es la super clase Material el metodo es abstracto se espera que lo que devuelve esta expresado en grs. 
			
			method nivelDeConductividad() //Abstracto
			
}

class Lata inherits Material{
	const cantMetal 		
		
		constructor(unaCantidad){//Una cantidad expresada en gr.
			cantMetal = unaCantidad	
		}
			
			override method cantMetal() = cantMetal
			
													//Amperes
			override method nivelDeConductividad() = 0.1 * cantMetal 
}
	
class Cable inherits Material{
	const longitud
	const seccionTransversal
	
		constructor(unaLongitud, unaSeccion){
			longitud = unaLongitud
			seccionTransversal = unaSeccion			
		}
		
			override method cantMetal() = (longitud / 1000) * seccionTransversal  
								
																		//Amperes
			override method nivelDeConductividad() = seccionTransversal * 3
}

class Fleeb inherits Material{
	var edad //En principio, hasta los 15, el Fleeb no es radiactivo
	const materialesConsumidos
				
				constructor(unaEdad, unosMateriales){
					edad = unaEdad
					materialesConsumidos = unosMateriales	
				}	
				
				//Retorna la edad de Fleeb
			method edad() = edad
			
				//Dado un material, lo agrega a la coleccion de materiales consumidos del Fleeb.
			method consumir(unMaterial){
				materialesConsumidos.add(unMaterial)
			}
			
				//Dada una coleccion de materiales.
			method consumirMateriales(unosMateriales){ //No pedido, se agrega por comodidad a la hora de realizar el test.
				materialesConsumidos.addAll(unosMateriales)
			}
			
				//Retorna la cantidad total de metal de todos los materiales consumidos por el Fleeb.
			override method cantMetal() = materialesConsumidos.sum { material => material.cantMetal() } 
			
				//Retorna la electricidad que genera el Fleeb, la cual es igual a la cantidad que produce el material que mas energia produce. El Fleeb debe de haber consumido por lo menos un material.
			override method electricidadGenerada() = self.elMaterialConsumidoQueMasElectricidadProduce().nivelDeConductividad()
			
				//Retorna el material consumido que mas electricidad produce.
			method elMaterialConsumidoQueMasElectricidadProduce() = materialesConsumidos.max { material => material.electricidadGenerada() } 
			
				//Denota el nivel de conductividad del Fleeb, el cual esta dado por el material consumido que menos conductividad posee.
			override method nivelDeConductividad() = self.elMaterialConsumidoQueMenosConduce().nivelDeConductividad()
			
				//Retorna el material consumido por el Fleeb que menos conductividad posee. 
			method elMaterialConsumidoQueMenosConduce() = materialesConsumidos.min { material => material.nivelDeConductividad() }
				
				//Retorna "True" si el Fleeb es radioactivo. Caso contrario, retorna "False". Se considera que un Fleeb es radioactivo si su edad es mayor a 15 a�os.
			override method esRadioactivo() = self.edad() > 15 //Tambien se podria escribir la variable y borrar el metodo.
			
				//Retorna la cantidad de energia que se necesita para recolectar a un Fleeb. Esta cantidad es el doble de lo que se necesita para recoger a cualquier otro material.
			override method cuantaEnergiaSeNecesitaParaRecolectarlo() = 2 * super() 
			
				//Dado un "alguien", si el Fleeb NO es radioactivo, aumenta la energia del individuo en 10 unidades. Caso contrario, actua como el resto de los materiales. 
			override method loQueVariaLaEnergiaCuandoLoRecoge(alguien){
				if(!self.esRadioactivo()){
					alguien.incrementarEnergia(10)
				}				
				else{
					super(alguien)//Esto es asi o deberia de no hacer nada?
				}
			}

}			

class MateriaOscura inherits Material{
	const materialBase//El enunciado no dice que esto pueda variar.
		
		constructor(unMaterial){
			materialBase = unMaterial	
		}
				//El nivel de conductividad de la Materia Oscura es igual que la materia base.
			override method nivelDeConductividad() = materialBase.nivelDeconductividad() / 2
			
				//La cantidad de metal de la materia oscura es igual a la cantidad de metal que posee su material base.
			override method cantMetal() = materialBase.cantMetal()
				
				//La electricidad generada de la materia oscura es el doble de la generada por su material base.
			override method electricidadGenerada() = materialBase.electricidadGenerada() * 2 
}

///////////////////////////////////////////////// Personajes /////////////////////////////////////////////////

object rick inherits Personaje{
	var companiero = morty//Inicialmente decimos que el compa�ero de Rick es Morty, pero esto puede variar en el futuro.	
	var experimentos = #{construirBateria, construirCircuito, shockElectrico}	
		
			//Retorna el companiero de Rick. En principio, este sera Morty, pero puede cambiar en el futuro.
		method companiero() = companiero
		
			//Dado un companiero, asigna el mismo como companiero de Rick. 
		method cambiarCompaniero(unCompaniero){
			companiero = unCompaniero
		}
		
			//Dado un experimento, agrega el mismo a la coleccion de experimentos de Rick. No pedido, pero se agrega para hacer el programa mas escalable, si se agregan experimentos en el futuro.
		method agregarExperimento(unExperimento){
			experimentos.add(unExperimento)	
		} 
		
			//Dado una condicion (expresada en un bloque), retorna "True" si Rick tiene en su mochila al menos un elemento que cumpla con dicha condicion.
		method tieneMaterialQueCumpla(unaCondicion) = mochila.any { unaCondicion.apply() }

		method experimentosQuePuedeRealizar() = experimentos.filter { experimento => experimento.cumpleRequerimientos(self) }

		method puedeHacer(unExperimento) = self.experimentosQuePuedeRealizar().contains(unExperimento)
		
		method realizar(unExperimento){
			if(!self.puedeHacer(unExperimento)){
				self.error("Rick no puede hacer el experimento en este instante.")
			}
			//Realizar experimento
		}
				
		method agregarMaterial(unMaterial){
			mochila.add(unMaterial)
		}
}

class Experimento{//Si voy a dejar los metodos abstractos la clase es innecesaria
	
	method cumpleRequerimientos(alguien) = alguien.tieneMaterialQueCumpla(self.loQuPideElExperimento()) 

	method loQuPideElExperimento()//Abstracto 
	
	method loQueProduce(alguien)//Abstracto - basicamente quiero que esto retorne en cada subclase un bloque de codigo que sea la condicion del mensaje anterior.
}

object construirBateria inherits Experimento{
	
	override method loQuPideElExperimento() = { material => material.cantMetal() > 200 }//Bloque de codigo

	override method loQueProduce(alguien) = new Bateria()
}

object construirCircuito inherits Experimento{
	
	override method loQuPideElExperimento() = { material => material.nivelDeConductividad() > 5 }//Bloque de codigo	
	
	override method loQueProduce(alguien) = new Circuito()
}

object shockElectrico inherits Experimento{
	
	override method loQuPideElExperimento() = { material => material.generaElectricidad() && material.conduceElectricidad() }		

	override method loQueProduce(alguien) = new ShockElectrico(/*generador, conductor */)//Como pasarle el generador y el conductor.Y sino lo hacemos clase?
}


class MaterialCompuesto inherits Material{
	var componentes
		
		constructor(unosComponentes){
			componentes = unosComponentes
		}
			
			method loQueProvocaAlCompanieroDe(alguien){
				self.provocarEfecto(alguien.companiero())//Esto iria aca?O solamenmte alguien y que rick pase a su companiero?	
			}
			
			method provocarEfecto(alguien)//Abstracto
			
			override method cantMetal() = componentes.sum { componente => componente.cantMetal() }
}

class Bateria inherits MaterialCompuesto{
		
		override method nivelDeConductividad() = 0
		
		override method electricidadGenerada() = 2 * self.cantMetal()
		
		override method esRadioactivo() = true
		
		override method provocarEfecto(alguien){
			alguien.disminuirEnergia(5)
		}
}

class Circuito inherits MaterialCompuesto{
	
	method loQueConducenSusComponentes() = componentes.sum{ componente => componente.nivelDeConductividad() }
	
	override method nivelDeConductividad() = self.loQueConducenSusComponentes() * 3
	
	override method esRadioactivo() = componentes.any { componente => componente.esRadioactivo() }
	
	override method generaElectricidad() = false //Ver si es necesario, dado que material no modifica la cantidad de electricidad generada y en esa clase se detemrina que un material genera electricidad si su self.electricidadGenerada() > 0

	override method provocarEfecto(alguien){
		//No provoca nad
	}
}

class ShockElectrico{
	const generador
	const conductor
			
		constructor(unGenerador, unConductor){
			generador = unGenerador
			conductor = unConductor
		}
	
	method loQuPideElExperimento() = { material => material.generaElectricidad() && material.conduceElectricidad() }		
	
	method loQueProvoca(alguien) = alguien.aumentarEnergia(self.capacidadGeneradorElectrico() * self.capacidadConductiva() ) 

	method capacidadGeneradorElectrico() = generador.electricidadGenerada()
	
	method capacidadConductiva() = conductor.nivelDeConductividad() 
}
