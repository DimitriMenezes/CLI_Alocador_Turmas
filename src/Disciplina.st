Object subclass: #Disciplina
	instanceVariableNames: 'nome codigo creditos horario'
	classVariableNames: ''
	poolDictionaries: ''
	category: '_UnpackagedPackage'
	
	
getCodigo
	^codigo	
	
getCreditos
	^creditos.	
	
getHorario
	^horario.

getNome
	^nome

setCodigo: cod
	codigo := cod.

setCreditos: credito 
	creditos := credito.

setHorario: hora
	horario := hora.

setNome:  nom
	nome := nom.	