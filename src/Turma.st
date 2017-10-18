Object subclass: #Turma
	instanceVariableNames: 'id horario nomeDisciplina codDisciplina professores1 contProf creditos'
	classVariableNames: ''
	poolDictionaries: ''
	category: '_UnpackagedPackage'
	
	
" Mensagens"	

getCodigoDisciplina

	^codDisciplina.

getCreditos
	^creditos
	
getHorario
	^horario.
	
getID "seria por exemplo T1, M2, N1"
	^id.	
	
getNomeDisciplina
	^nomeDisciplina.

getProfessor: posX "retornar se é professor primário ou secundário da disciplina"
	^ professores1 at:posX

iniciar "ideia semelhante ao construtor"
	professores1 := Array new: 3.
	contProf  := 1.	
	
naotemProfessor " se essa disciplina nao tem professor"
	^ (((professores1 at:1) == nil) & ((professores1 at:2) == nil)).

setCodigoDisciplina: x
	codDisciplina := x.	
	
setCreditos: x
	creditos := x.
	
setHorario: hora
	horario := hora.

setID: id1
	id := id1.

setNomeDisciplina: nomeD 
	nomeDisciplina := nomeD	
	
setProfessor: professor at: x  " alocar um professor primario ou secundario na disciplina"
	professores1 at:x put: professor.

temProfessor " inverso do naoTempProfessor"
	^(((professores1 at:1) ~= nil) | ((professores1 at:2) ~= nil)).	
	
