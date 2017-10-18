Object subclass: #Professor
	instanceVariableNames: 'Codigo Nome horarios i'
	classVariableNames: ''
	poolDictionaries: ''
	category: '_UnpackagedPackage'
	
" mensagens"

adicionarHorario: codigo "alocar um horario para o professor"

	horarios at: i put: codigo.

	i := i + 1.

getCodigo
	^Codigo.
		
getNome
	^Nome.

iniciar
	horarios := Array new: 8.
	i := 1.	
	
removerHorario: cod
|a|
a:=1.
[a < i] whileTrue:[
	((horarios at: a) = cod) ifTrue:[
		horarios at: a put: nil.
		a := 999. "somente para sair do laço antecipadamente"

		].
	a := a +1.
].


retornarHorario: pos
	^ (horarios at: pos)
	
	
retornarI   " i se refere ao contador de horarios"
	^i.	
	
setCodigo: cod   "Código do professor"
	Codigo := cod.

setNome: nome
	Nome := nome.
	
		