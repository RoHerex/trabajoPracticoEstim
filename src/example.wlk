object estim{
	const property juegos = []
	
method aniadir(juego){juegos.add(juego)}

method validarDescuento(descuento){
     return if(descuento <= 100){
	 self.descuentoDeterminado(descuento)} 
	 else{self.error("no se puede realizar un descuento de tales proporciones")}
	}
		
method descuentoDeterminado(descuento)= self.juegosQueSuperanTresCuartos().map{j =>j .descuentoDirecto(descuento)} 	 
		
method juegosQueSuperanTresCuartos()= 
	juegos.filter{j => j.precioDolares() > (self.juegoMasCaro().precioDolares()  * 0.75)}		
	
method juegoMasCaro() = juegos.max{j => j.precioDolares()}

method juegosParaMenores() = juegos.filter{j => j.esParaMenores()}

method promedioDeJuegosParaMenores() = self.juegosParaMenores().sum{j => j.precioDolares()}
	
}


class Juego{
	const property precioDolares
	const property lenguajeInapropiado
	const property contieneViolencia
	const property tematicasParaAdultos
	var property pagoCritica
	const property notasDeCriticos = []
	

	
method descuentoDirecto(descuento) = precioDolares - (descuento * precioDolares / 100)  
	
method descuentoFijo(descuento) = (precioDolares/2).max (self.descuentoDirecto(descuento))
	
method gratis() = precioDolares - precioDolares

method descuentoDeterminado(descuento)= estim.descuentoDeterminado(descuento)

method contenidosDeCategoria()= contieneViolencia and tematicasParaAdultos and lenguajeInapropiado

method juegosQueSuperanTresCuartos()= estim.juegosQueSuperanTresCuartos()

method esParaMenores() = !self.lenguajeInapropiado() and !self.tematicasParaAdultos() and !self.contieneViolencia()	

method juegosParaMenores()= estim.juegosParaMenores()

method recibirCritica(critico)= notasDeCriticos.add(critico)

method cantidadNotasPositivas()= notasDeCriticos.filter{j => j.esCriticaPositiva()}

method superaLaCantDeCriticasPositivas(cantidad){return self.cantidadDeCriticasPositivas() > cantidad}

method cantidadDeCriticasPositivas() = self.cantidadNotasPositivas().size() 

method juegoGalardonado() = notasDeCriticos.all{j => j.esCriticaPositiva()}

method tieneCriticosLiterarios() = notasDeCriticos.any{j => j.texto().size() > 100}



}

class JuegoNuevo inherits Juego{
	const property descuentoPreventa
	
override method descuentoDirecto(descuento){return super(descuento) - descuentoPreventa}	

}

class Pais{ 
	const property equivalenciaADolar
	
	
method convertirDolares(precioDeljuego) = precioDeljuego *	equivalenciaADolar


method promedioParaMenoresAMonedaLocal()= self.convertirDolares(estim.promedioDeJuegosParaMenores())
		
}


class Usuario {
	var property esCriticaPositiva
	var property texto = null
	
	
   method cambiarCritica(){esCriticaPositiva = !self.esCriticaPositiva()}
	
   method texto(){
   return if (self.esCriticaPositiva()){texto = "si"}else{ texto = "no"}}
   
}

class CriticosPagos inherits Usuario{
	
override method esCriticaPositiva(juego){
 	return if(juego.pagoCritica()){
 	 esCriticaPositiva = self.esCriticaPositiva()
 	 texto = self.textosPositivos()
 	}else{
 	 esCriticaPositiva = !self.esCriticaPositiva()
 	 texto = self.textosNegativos()
 	}
 }
 
method textosPositivos()= ["muy Bueno","Es Increible","Lo mejor que eh juego este año"]
 
method textosNegativos()= ["lamentabel", "un asco", "lo péor que eh jugado nunca"]	
}
	
class Revista inherits CriticosPagos{
	const property miembros = []
	
 method unirMiembro(unir){miembros.add(unir)}

   override method esCriticaPositiva(){
 	return self.cantidadCriticasPositivas() > self.cantidadCriticasNegativas()	
 }
 
 override method texto() = miembros.sum{j => j.texto()}
 

 
 method cantidadCriticasPositivas() = self.criticasPositivas().size()	
 
 method cantidadCriticasNegativas()	= self.criticasNegativas().size()
	
 method criticasPositivas(){return miembros.filter{j => j.esCriticaPositiva()}}
 
 method criticasNegativas(){return miembros.filter{j => !j.esCriticaPositiva()}}
	
}	
	
	




