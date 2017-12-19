

///////////////////////////////////////////////// Materiales /////////////////////////////////////////////////
 
class Material{
				
		method esRadiactivo() = false //A excepcion del Fleeb, los materiales no son radiactivos.
		
		method electricidadGenerada() = 0 //Esto esta bien? 
			
			//Segun enunciado la cantidad de energia necesaria para recolectar un material es igual a la cantidad de gramos de metal de dicho material.	
		method cuantaEnergiaSeNecesitaParaRecolectarlo() = self.cantMetal()
		
			//Dada un "alguien", disminuye la energia del mismo, en cuanto a la energia que se necesita para recoger al material.
		method provocarEfecto(alguien){
			alguien.disminuirEnergia(alguien.cuantaEnergiaNecesitaParaLevantar(self))
		}
		
		method generaElectricidad() = self.electricidadGenerada() > 0 //Esto esta bien? 
		
		method conduceElectricidad() = self.nivelDeConductividad() > 0 //Esto esta bien? 
		
		method cantMetal() //Abstracto - Si bien es la super clase Material el metodo es abstracto se espera que lo que devuelve esta expresado en grs. 
		
		method nivelDeConductividad() //Abstracto		
		
		method estaVivo() = false

		method modificarHumor(_jerry){} //Decido que por defecto ningun material afecte a ningun Jerry, para modificar solo los que si lo hacen. 
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

class MaterialPosiblementeRadiactivo inherits Material{
	
	override method modificarHumor(_jerry){
		if(self.esRadiactivo()){
			_jerry.sobreexictarse()
		}
	}	 
}

class MaterialVivo inherits Material{
	
	override method modificarHumor(_jerry){
		_jerry.ponerseDeBuenHumor()
	}
}

class Fleeb inherits MaterialPosiblementeRadiactivo{
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
				
					//Retorna el material consumido que mas electricidad produce.
				method elMaterialConsumidoQueMasElectricidadProduce() = materialesConsumidos.max { material => material.electricidadGenerada() } 
				
					
					//Retorna el material consumido por el Fleeb que menos conductividad posee. 
				method elMaterialConsumidoQueMenosConduce() = materialesConsumidos.min { material => material.nivelDeConductividad() }
				
				
					//Retorna la cantidad total de metal de todos los materiales consumidos por el Fleeb.
				override method cantMetal() = materialesConsumidos.sum { material => material.cantMetal() } 
				
				
					//Retorna la electricidad que genera el Fleeb, la cual es igual a la cantidad que produce el material que mas energia produce. El Fleeb debe de haber consumido por lo menos un material.
				override method electricidadGenerada() = self.elMaterialConsumidoQueMasElectricidadProduce().nivelDeConductividad()
				
				
					//Denota el nivel de conductividad del Fleeb, el cual esta dado por el material consumido que menos conductividad posee.
				override method nivelDeConductividad() = self.elMaterialConsumidoQueMenosConduce().nivelDeConductividad()
									
				override method esRadiactivo() = self.edad() > 15 
				
				override method cuantaEnergiaSeNecesitaParaRecolectarlo() = 2 * super() 
				
					//Dado un "alguien", si el Fleeb NO es radiactvo, aumenta la energia del individuo en 10 unidades. Caso contrario, actua como el resto de los materiales. 
				override method provocarEfecto(alguien){
					if(! self.esRadiactivo()){
						alguien.incrementarEnergia(10)
					}				
					super(alguien)//Esto me hace ruido todavia. A su vez, entendemos que todo material cansa a quien lo recoge.
				}
				
				override method estaVivo() = true
		
				override method modificarHumor(_jerry){		
					if(self.esRadiactivo()){
						super(_jerry)
					}
					else{
						_jerry.ponerseBuenHumor()
					}
				}
}			

class MateriaOscura inherits Material{
	const materialBase//El enunciado no dice que esto pueda variar.
		
		constructor(unMaterial){
			materialBase = unMaterial	
		}
				//El nivel de conductividad de la Materia Oscura es igual que la materia base.
			override method nivelDeConductividad() = materialBase.nivelDeConductividad() / 2
			
				//La cantidad de metal de la materia oscura es igual a la cantidad de metal que posee su material base.
			override method cantMetal() = materialBase.cantMetal()
				
				//La electricidad generada de la materia oscura es el doble de la generada por su material base.
			override method electricidadGenerada() = materialBase.electricidadGenerada() * 2 

			override method esRadiactivo() = materialBase.esRadiactivo()

			//Se considera que la materia oscura no esta viva, independientemente de que su material base lo este o no.
}


////////////////////////////////////////////////Parasitos Alienigenas//////////////////////////////////////////////////////////////

class ParasitoAlienigena inherits MaterialVivo{
	
	const acciones = #{}
	
	method agregarAccion(accion){
		acciones.add(accion)
	}
	
	override method estaVivo() = true
	
	override method electricidadGenerada() = 5
	
	override method cantMetal()= 10 
	
	override method nivelDeConductividad()= 0
	
	override method provocarEfecto(alguien) {
		acciones.forEach({accion => accion.provocarAlteracion(alguien)})
	}
}

class AccionDePersonalidad{
	
	method provocarAlteracion(alguien)
	
}

class AccionesEnMochila inherits AccionDePersonalidad{
	
	override method provocarAlteracion(alguien){
		alguien.sacar(self)
		self.accionEnLaMochila(alguien)
		alguien.agregarEsteObjeto(self)
	}
	
	method accionEnLaMochila(alguien)
}

object entregarObjetos inherits AccionesEnMochila{
	override method accionEnLaMochila(alguien){
		alguien.darObjetos(alguien.companiero())
	}
}

object tirarObejetoAlAzar inherits AccionesEnMochila{
	 
	 override method accionEnLaMochila(alguien){
	 	alguien.sacarCualquiera()
	 }
}

class AccionDeEnergia inherits AccionDePersonalidad{
	
	const porcentaje 
		constructor (_porcentaje){
			porcentaje = _porcentaje
	}
}

class IncrementarEnergia inherits AccionDeEnergia{
	
  	override method provocarAlteracion(alguien){
  		alguien.incrementarEnergia( alguien.energia() * porcentaje / 100 )
	}
}

class DisminuirEnergia inherits AccionDeEnergia{
	
	 override method provocarAlteracion(alguien){
		alguien.disminuirEnergia( alguien.energia() * porcentaje / 100 )
	}
}

class AccionDeRecolectar inherits AccionDePersonalidad {
	const objeto 
		
		constructor (_unObjeto){
			objeto = _unObjeto
		}
			override method provocarAlteracion(alguien){
				alguien.recolectar(objeto)//El comportamiento de que si puede o no recolectar esta en personajeRecolector.
			}
}


///////////////////////////////////////////////// MATERIALES COMPLEJOS /////////////////////////////////////////////////

class MaterialCompuesto inherits MaterialPosiblementeRadiactivo{
	var componentes
		
		constructor(unosComponentes){
			componentes = unosComponentes
		}
		
			method componentes() = componentes 
					
			override method cantMetal() = componentes.sum { componente => componente.cantMetal() }
}

class Bateria inherits MaterialCompuesto{
		
		override method nivelDeConductividad() = 0
		
		override method electricidadGenerada() = 2 * self.cantMetal()
		
		override method esRadiactivo() = true
		
		override method provocarEfecto(alguien){
			alguien.companiero().disminuirEnergia(5)
		}
}

class Circuito inherits MaterialCompuesto{
	
	method loQueConducenSusComponentes() = componentes.sum{ componente => componente.nivelDeConductividad() }
	
	override method nivelDeConductividad() = self.loQueConducenSusComponentes() * 3
	
	override method esRadiactivo() = componentes.any { componente => componente.esRadiactivo() }
	
	override method generaElectricidad() = false //Ver si es necesario, dado que material no modifica la cantidad de electricidad generada y en esa clase se detemrina que un material genera electricidad si su self.electricidadGenerada() > 0

	override method provocarEfecto(alguien){
		//No provoca nada.
	}
}


///////////////////////////////////////////////// EXPERIMENTOS /////////////////////////////////////////////////

	// -Aclaracion: A partir de aca, en lo que experimentos se refiere, cada vez que hablamos de "unaMochila",
	//				en realidad se refiere es a una coleccion de materiales. Hablamos de "mochila" a razon de conservar el dominio,
	//				y de seguir siendo descriptivos con los terminos que veniamos manejando antes.
	//					(*)  

class Experimento{
	const materialesNecesarios = #{}
	var estrategiaSeleccionMateriales = new AlAzar()
	

		method estrategia() = 	estrategiaSeleccionMateriales 
		
			//En el tests de estrategias se usa ese metodo, pero no estaba en este archivo. Ver si quedo algo util en el otro .wlk!!
		method setEstrategiaDeSeleccion(unaEstrategia){
			estrategiaSeleccionMateriales = unaEstrategia
		}
			//Retorna la coleccion de materiales que necesita un eperimento para ser realizado.
		method materialesNecesarios() = materialesNecesarios
	
			//Dada una mochila* y una condicion, agrega a la coleccion de materiales necesarios un objeto de la mochila que cumpla dicha condicion.
		method materialesNecesarios(unaMochila, condicion1, condicion2){ 
			materialesNecesarios.add(unaMochila.find(condicion1))
			materialesNecesarios.add(unaMochila.find(condicion2))
		}		
			
		method hayMaterialesQueCumplan(unaMochila, unaCondicion) = unaMochila.any(unaCondicion)

		method tieneMaterialesNecesarios(unaMochila)//Abstracto
		
		method loQueProduce()//Abstracto

		method agarrarLoQueNecesita(personaje)//Abstracto
}


object construirBateria inherits Experimento{
	const condicionDeRadiactivo = { material => material.esRadiactivo() }
	const condicionDeMetal = { material => material.cantMetal() > 200 }	
		
		method hayMaterialesRadiactivos(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeRadiactivo)	
		
		method hayMaterialesConMuchoMetal(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeMetal)
					
		override method agarrarLoQueNecesita(personaje){
			self.materialesNecesarios(personaje.mochila(), condicionDeRadiactivo, condicionDeMetal)
		}
		
			//Dada una mochila*, retorna "True" si en la misma hay materiales que sean radiactivos y hay materiales que tengan mas de 200 grs. de metal.
		override method tieneMaterialesNecesarios(unaMochila) = self.hayMaterialesRadiactivos(unaMochila) and  self.hayMaterialesConMuchoMetal(unaMochila)
		
			//Retorna una bateria cuyos componentes son los materiales necesarios del experimento.
		override method loQueProduce() = new Bateria(self.materialesNecesarios())
}        

object construirCircuito inherits Experimento{
	const condicionDeConductividad = { material => material.nivelDeConductividad() > 5 }
	
			//Dada una mochila*, retorna el conjunto de materiales de la misma que tenga una conductividad mator a 5 amperes.
		method losMaterialesConductores(unaMochila) = unaMochila.filter(condicionDeConductividad).asSet()
		
			//Dada una lista de materiales, agrega al conjunto de materiales necesarios, dichos materiales.
		method agregarTodos(unosMateriales){
			materialesNecesarios.addAll(unosMateriales)
		}
		
		override method agarrarLoQueNecesita(personaje){
			self.agregarTodos(self.losMaterialesConductores(personaje.mochila()))
		}	
		
		override method tieneMaterialesNecesarios(unaMochila)= self.hayMaterialesQueCumplan(unaMochila, condicionDeConductividad)

			//Retorna un circuito cuyos componenetes son los materiales necesarios del experimento.
		override method loQueProduce() = new Circuito(self.materialesNecesarios())
}

object shockElectrico inherits Experimento{
	const condicionDeGenerarElectricidad = { material => material.generaElectricidad() }
	const condicionDeConducirElectricidad = { material => material.conduceElectricidad() }		
	
		method tieneMaterialQueGenereElectricidad(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeGenerarElectricidad)
	
		method tieneMaterialQueConduzcaElectricidad(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeConducirElectricidad)
		
		method elGenerador() = materialesNecesarios.max { materiales => materiales.electricidadGenerada() }
		
		method elConductor() = materialesNecesarios.max { materiales => materiales.nivelDeConductividad() } 
		
		method capacidadConductor() = self.elConductor().nivelDeConductividad()
		
		method capacidadGenerador() = self.elGenerador().electricidadGenerada()
		
		method provocarEfecto(alguien){
			alguien.companiero().incrementarEnergia(self.capacidadGenerador() * self.capacidadConductor())
		}
				
		override method tieneMaterialesNecesarios(unaMochila)= self.tieneMaterialQueGenereElectricidad(unaMochila) and self.tieneMaterialQueConduzcaElectricidad(unaMochila) 
			
		override method loQueProduce() = self
			//No produce ningun material como el resto de los experimentos.
		
		override method agarrarLoQueNecesita(personaje){
			self.materialesNecesarios(personaje.mochila(), condicionDeGenerarElectricidad, condicionDeConducirElectricidad)
		} 
}


 ///////////////////////////////////////////////// Mochilas /////////////////////////////////////////////////

class Mochila{
	const objetos = #{} //Seria const, pero el hecho de vaciar se me facilita que sea var.
		
		method agregar(objeto){
			objetos.add(objeto)
		}
		
		method agregarEstos(unosObjetos){//Puede ser que la lista de objetos
			objetos.addAll(unosObjetos)
		}
		
		method sacar(unObjeto){
			objetos.remove(unObjeto)
		}
		
		method sacarEstos(unosObjetos){
			objetos.removeAll(unosObjetos)
		}
		
		method vaciar(){
			objetos.clear()
		}
		
		method estaVacia() = objetos.isEmpty()
		
		method tieneEspacioParaRecibir(materiales) = true
		
		method cuantosObjetosTiene() = objetos.size()
		
		method objetos() = objetos	
}

 class MochilaConLimite inherits Mochila{
	var limite 
		
		constructor(unLimite){
			limite = unLimite
		}	
		
			method cambiarCapacidad(unLimite){
				limite = unLimite
			}
			
			method duplicarCapacidad(){
				self.cambiarCapacidad(self.limite() * 2)
			}
			
			method limite() = limite
		
			method tieneLugar() = self.espacioDisponible() > 0
		
			method laMedidaDe(materiales) = materiales.size()
	 
			method espacioDisponible() =  limite - self.cuantosObjetosTiene()  						
			
			method errorDeEspacio(){
				self.error("No hay suficiente espacio")
			} 
			
			/*  
			 *  Se realizan consultas sobre si puede o no agregar objetos a su contenido por si en algun momento se 
			 *	manipula  a la mochila con limite desde algun lugar que no sea desde el personaje.
			 */
			override method agregarEstos(materiales){
				if(!self.tieneEspacioParaRecibir(materiales)){
					self.errorDeEspacio()
				}  
				super(materiales)
			}
			
			override method agregar(material){
				if(!self.tieneLugar()){
					self.errorDeEspacio()		
				}
				super(material)
			}
			
			override method tieneEspacioParaRecibir(materiales)  = self.laMedidaDe(materiales) <= self.espacioDisponible()
}


///////////////////////////////////////////////// Personajes /////////////////////////////////////////////////
		
		/*
		 * ACLARACION: En la primera y segunda parte, no era necesario que otros personajes a diferencia de Rick 
		 *			   recuerden cual es su companiero. Quizas esto cambie en el futuro.
		 */

class Personaje{//Clase creada por comodidad para juntar el comportamiento en comun de Rick y de Morty. //De todos los personajes, deberiamos decir ahora.
	const mochila
	var energia = 100
	var companiero
	
		constructor(unaMochila, unCompaniero){
			mochila = unaMochila
			companiero = unCompaniero
			
		}
		
			method cambiarHumorCuandoDaObjetos(_jerry){//El resto de los personajes no modifican el humor de ningun otro personaje. Solo Rick.
			}
			
				//Retorna el companiero del personaje. En principio, este sera Morty para Rick, pero puede cambiar en el futuro.
			method companiero() = companiero
			
				//Dado un companiero, asigna el mismo como companiero del personaje. 
			method cambiarCompaniero(unCompaniero){
				companiero = unCompaniero
			}	
			
				//Dado una coleccion de objetos, los guarda en la mochila. No pedido, agregado por comodidad a la hora de hacer el test.
			method recibirObjetos(unosMateriales){
				mochila.agregarEstos(unosMateriales)
			}	
			
				//Dado un material, lo guarda en la mochila. 
			method meterEnLaMochila(unMaterial){
				mochila.agregar(unMaterial)	
			}
		
			method mochila() = mochila.objetos()//Mejor dicho la coleccion de objetos que la mochila "guarda".
		
			method darObjetos(_companiero){
				if(! _companiero.puedeRecibir(self.mochila())){
					self.error("La mochila de " + _companiero.nombre() + " no tiene mas espacio suficiente")
				}
				_companiero.recibirObjetos(self.mochila()) //El companiero de Morty debe entender este mensaje*
				self.descartarObjetos()
			}
			
			method puedeRecibir(materiales) = mochila.tieneEspacioParaRecibir(materiales)
			
				//Dado un material, elimina de dicho material de la mochila del personaje.
			method sacar(unMaterial){
				mochila.sacar(unMaterial)
			}
					//? Y esto para que esta?
			method sacarCualquiera(){
				mochila.remove(mochila.objetos().anyOne())
			}
			
				//Vacia totalmente la mochila del personaje.
			method descartarObjetos(){
				mochila.vaciar()
			}
						
				//Dada una lista de materiales, los saca de la moochila del personaje.
			method sacarEstos(unosMateriales){
				mochila.sacarEstos(unosMateriales)
			}
				
					//Si bien en un principio, esto tenia sentido solo en la clase PersonajeRecolector, en la Tercera Parte se da la idea de que Rick tambien posee una energia la cual disminuye si Summer le da algun material. 
				//(1*) setter de la energia por si en alguna ocasion se quiere empezar con otro valor
			method energia(unaEnergia){ 
				energia = unaEnergia//No pedido por el enunciado
			}	
		
			method energia() = energia
		
			method disminuirEnergia(unaCantidad){
				energia = (energia  - unaCantidad).max(0)
			}
		
			method incrementarEnergia(unaCantidad){
				energia += unaCantidad 
			}
			 
			method nombre() = "Personaje Anonimo" //Abstracto - Agregado para poder instanciar otro personaje para probar desde el test. Obviamente no es lo que se quiere, que haya ersonaje instanciados de PersonajeRecolectores, por eso en principio el metodo estaba abstracto.
}


class PersonajeRecolector inherits Personaje{
	constructor(unLimite, unCompaniero) = super(new MochilaConLimite(unLimite), unCompaniero)
	
		method cuantaEnergiaNecesitaParaLevantar(unMaterial) = unMaterial.cuantaEnergiaSeNecesitaParaRecolectarlo() 
	
			//Dado un material, retorna "True" en caso de que el personaje pueda recolectar dicho material. Caso contrario retorna "False". 
		method puedeRecolectar(unMaterial) = self.tieneLugarEnLamochila() && self.tieneEnergiaParaLevantar(unMaterial)

			//Dado un material, retorna "True" si el personaje tiene energia para recolectar dicho material.
		method tieneEnergiaParaLevantar(unMaterial) = energia >= self.cuantaEnergiaNecesitaParaLevantar(unMaterial)
			
			//Dado un material, si el personaje puede recogerlo, lo agrega a su mochila, caso contrario, tira un error avisando que no es posible realizar dicha accion. 
		method recolectar(unMaterial){
			if(!self.puedeRecolectar(unMaterial)){
				self.errorDeRecoleccion()
			}
			self.meterEnLaMochila(unMaterial)
			unMaterial.provocarEfecto(self) 
		}
		
		method agregarEsteObjeto(objeto){
			mochila.agregar(objeto)
		}
		
		method tieneLugarEnLamochila() = mochila.tieneLugar()		

		method cuantoPuedeLlevar() = mochila.capacidad()
		
		method errorDeRecoleccion(){
			self.error(self.nombre() + " no puede recolectar el material en este momento.")
		}
}

/*
Estaria bueno agregar estas clases por escalabilidad:
*  
class PersonajeRecolectorPromedio inherits PersonajeRecolector{
	constructor() = super(3, rick)//Entonces decimos que todo PRP tienea rick como companiero
	constructor(unCompaniero) = super(3, unCompaniero)// salvo que necesitemos que sea otro.
}

class PersonajeCreador inherits Personaje{
	const experimentos
		
		constructor(unosExperimentos, unCompaniero) = super(new Mochila(), unCompaniero){
			experimentos = unosExperimentos
		}
		
			method experimentos() = experimentos
			
			method agregarExperimento(unExperimento){
				experimentos.add(unExperimento)
			} 
			
			method agregarExperimentos(unosExperimentos){
				experimentos.addAll(unosExperimentos)
			} 
			
			method sacarExperimento(unExperimento){
				experimentos.remove(unExperimento)
			}
			
			method sacarExperimentos(unosExperimentos){
				experimentos.removeAll(unosExperimentos)
			}

			method sePuedeRealizar(unExperimento) //Abstracto
			
			method realizar(unExperimento) //Abstracto
}

class PersonajeCreadorPromedio inherits PersonajeCreador{ //Llegado el caso, eliminar la repeticion de codigo con una clase ExperimentosConocidos o similar.
	constructor() = super(#{construirBateria, construirCircuito, shockElectrico}, morty)
	
	constructor(unCompaniero) = super(#{construirBateria, construirCircuito, shockElectrico}, unCompaniero)
}
 	
*/


///////////////////////////////////////////////// Rick, Morty, Summer y Jerry /////////////////////////////////////////////////
		
//Inicialmente, decimos que todo personaje empieza con 100 de energia. Esto podria llegar a variar. (*1)
							
										//mochila - comapniero - energia inicial 
object morty inherits PersonajeRecolector(3, rick){  //Se deja el comportamiento de Morty en PersonajeRecolector.
	
 	override method nombre() = "Morty"	
}

object summer inherits PersonajeRecolector(2, rick){
	
	override method nombre() = "Summer"
																				
	override method cuantaEnergiaNecesitaParaLevantar(unMaterial) = super(unMaterial) * 0.8 //Summer requiere un 20% menos de energia que Morty. Es decir, un 80% del mismo.

	override method darObjetos(alguien){
		alguien.disminuirEnergia(10)
		super(alguien)
	}
}			

object jerry inherits PersonajeRecolector(3, morty){ //Dado que Jerry actua igual que Morty, ambos estan instanciados a partir de la misma clase. Quizas sea mas prolijo hacer una clase de  Morty, en vez de un object, para que Jerry pueda heredar de el. 
	var humor = new BuenHumor() //En prncipio, decimos que Jerry comienza de buen humor.
			
			method humor() = humor 
				
			method estaBuenHumor() = humor.esBueno()
			
			method estaSobreexcitado() = humor.esSobreexitado()
			
			method estaMalHumor() = not self.estaBuenHumor()
			
			method tieneLaMochilaVacia() = mochila.estaVacia()
			
			method cambiarHumor(_humor){
				humor = _humor
			}
			
			method ponerseDeBuenHumor(){
				self.cambiarHumor(new BuenHumor())
			}
			
			method duplicarCapacidadMochila(){
				mochila.duplicarCapacidad()
			}
		
			method ponerseDeMalHumor(){
				self.cambiarHumor(new MalHumor())
			}
		
			method sobreexictarse(){
				self.cambiarHumor(new SobreExcitado())
			}
			
			method quizasPierdeTodo(){
				if(self.esUnaPosibilidad()){//Es hasta el 4 inclusive?
					self.descartarObjetos()				
				}
			}
				//Minimizando el calculo de probabilidades, hay 1 de 4 posibilidades de que Jerry pierda el contenido de la mochila pero...
			method esUnaPosibilidad() = 1.randomUpTo(4) == 2 //Elegi el 2 como podria haber sido cualquier numero dentro del rango. Tecnicamente, hay 25% que el randomUpTo devuelva cualquiera de ellos... 
															//En el caso de ...(4), deberia decir 4 o 5? Al probarlo desde el repl 10/10 veces me daba "x" numero que oscilaba entre 0 y 3. 		
			override method nombre() = "Jerry"
			
			override method puedeRecolectar(_material) = super(_material) && (self.estaBuenHumor() || self.tieneLaMochilaVacia())
			
			override method recolectar(_material){
				humor.recolectar(_material, self)
			}
			
			override  method darObjetos(_personaje){
				_personaje.cambiarHumorCuandoDaObjetos(self)
				super(_personaje)
			}		
			
			method levantarSoloUno(_material){
				if(self.puedeRecolectar(_material)){
					self.meterEnLaMochila(_material)
				}
				//Sino, no hace nada. --Else innecesario
			}
}

class Humor{
		
	method recolectar(_material, _persona)
	
	method esBueno() = false
	
	method esSobreexitado() = false
}

class BuenHumor inherits Humor{
	
	override method recolectar(_material, _persona){
		_persona.meterEnLaMochila(_material)
	}
	
	override method esBueno() = true
}

class MalHumor inherits BuenHumor{
	
	override method recolectar(_material, _persona){
		_persona.levantarSoloUno(_material)
	}
}

class SobreExcitado inherits BuenHumor{
	
	override method recolectar(_material, _persona){
		_persona.quizasPierdeTodo()
		_persona.duplicarCapacidadMochila()
		super(_material, _persona)
	}
		
	override method esSobreexitado() = true
}


object rick inherits Personaje(new Mochila(), morty){
	//Inicialmente decimos que el companiero de Rick es Morty, pero esto puede variar en el futuro.
	//Lo mismo decimos que los experimentos que saber hacer rick es el construoir la bateria, el circuito y el shock electrico, pero esta tmb puede cambiar.		
	const experimentos = #{construirBateria, construirCircuito, shockElectrico}
		
			override method cambiarHumorCuandoDaObjetos(_jerry){
				_jerry.ponerDeMalHumor()	
			}
			
			method experimentosQuePuedeRealizar() = experimentos.filter { experimento => experimento.tieneMaterialesNecesarios(self.mochila()) }
			
			method sePuedeRealizar(unExperimento) = unExperimento.tieneMaterialesNecesarios(self.mochila())
				
			method realizar(unExperimento){
				if(! self.sePuedeRealizar(unExperimento)){
					self.error("Rick no puede hacer el experimento en este instante")
				}
				self.accionesAlRealizar(unExperimento)
			}
			
			method accionesAlRealizar(unExperimento){
				unExperimento.agarrarLoQueNecesita(self)//Es decir, copia los materiales que necesita de la mochila en la coleccion de materiales necesarios para el experimento
				unExperimento.loQueProduce().provocarEfecto(self)
				self.accionesEnLaMochilaAlCrear(unExperimento)
			}
			
			method accionesEnLaMochilaAlCrear(unExperimento){
				mochila.sacarEstos(unExperimento.materialesNecesarios())
				mochila.agregar(unExperimento.loQueProduce())
			}

			override method nombre() = "Rick"
}


////////// INTELIGENCIA ARTIFICIAL ///////

class Estrategia {
	
	method seleccion(condicion)

}


class AlAzar inherits Estrategia {
	
	override method seleccion(condicion){
		if(rick.mochila().any({condicion})){
			return rick.mochila().find({condicion})
			} else {
			return "No hay material en la mochila que cumpla la condicion"
			}
	}
}

class MenorMetal inherits Estrategia {
	
	override method seleccion(condicion){
		if(rick.mochila().any({condicion})){
			return rick.mochila().filter({condicion}).min({material => material.cantMetal()})			
				} else {
			return "No hay material en la mochila que cumpla la condicion"
			}
	}
	
			method menorCantidadDeMetal() = rick.mochila().min({material => material.cantMetal()}) 
	
}

class MayorGenerador inherits Estrategia{
	
	override method seleccion(condicion){
		if(rick.mochila().any({condicion})){
			return rick.mochila().filter({condicion}).max({materiales => materiales.electricidadGenerada()})					
				} else {
			return "No hay material en la mochila que cumpla la condicion"
			}
	}
	
	method mayorCantidadDeEnergia() = rick.mochila().max({materiales => materiales.electricidadGenerada()})
}


class Ecologico inherits Estrategia{
	
	override method seleccion(condicion){
		if(rick.mochila().any({condicion})){
			return rick.mochila().filter({condicion}).find({self.materialVivoORadiactivo()})
			} else {
			return "No hay material en la mochila que cumpla la condicion"
			}
	}
	
	method materialVivoORadiactivo(){
		if(rick.mochila().any({material => material.estaVivo()})){
			return	{material => material.estaVivo()}
		} else  {
			return {material => material.esRadiactivo()}
		}
	}
	
}








