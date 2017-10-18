Object subclass: #Sigaa
	instanceVariableNames: 'turmas disciplinas professores contadorTurmas contadorProfessores contadorDisciplinas gradeCC gradeEC gradeSI contadorCC contadorEC contadorSI'
	classVariableNames: ''
	poolDictionaries: ''
	category: '_UnpackagedPackage'
	
	
iniciar
|resposta|
turmas := Array new: 200.
disciplinas  := Array new: 200.
professores := Array new: 50.
gradeCC := Array new: 100.
gradeSI := Array new: 100.
gradeEC := Array new: 100.

contadorDisciplinas := contadorProfessores := contadorTurmas := contadorCC := contadorEC := contadorSI := 1.

self lerArquivoDisciplina: 'Disciplina1.txt'.
self lerArquivoProfessor: 'Professor.txt'.
self lerArquivoGradeCC: 'GradeCurricular(CC).txt'.
self lerArquivoGradeEC: 'GradeCurricular(EC).txt'.
self lerArquivoGradeSI: 'GradeCurricular(SI).txt'.

self normalizarVetor.

self criarTurmasPadrao.

[resposta := UIManager default request: 'O Que deseja Fazer?
					1 - Consultar Disciplina pelo Codigo
					2 - Consultar Disciplina pelo Nome
					3 - Consultar Grade Curricular
					4 - Consultar Turmas por Docente
					5 - Menu Alocar Professor/Remover Professor
					6 - Menu Relatorios
					0 - SAIR'.	
					
	(resposta = '1') ifTrue:[
		| codigo |
		codigo := UIManager default request: 'Digite o Codigo'.
		
		self consultarDisciplinaPeloCodigo: codigo.
		
		].
	(resposta = '2') ifTrue:[
		| nome |
		nome := UIManager default request: 'Digite o Nome da Disciplina'.
		
		self consultarDisciplinaPeloNome: nome.
				
		].
	(resposta = '3') ifTrue:[
		|grade|
		grade := UIManager default request: 'Digite o Curso
											   EC - Engenharia da Computação	
											   CC - Ciência da Computação
											   SI - Sitema de Informação. '.
		(grade = 'EC') ifTrue: [ self consultarGradeCurricularEC ].
		(grade = 'CC') ifTrue: [ self consultarGradeCurricularCC ].
		(grade = 'SI') ifTrue: [ self consultarGradeCurricularSI ].
		
		].
		(resposta = '4') ifTrue:[
		|fessor|
		fessor:= UIManager default request: 'Digite o codigo do professor'.
		self turmasPorDocente: fessor.
		
		].
		(resposta = '5') ifTrue: [ 
			|answer|
			answer := UIManager default request: '|1 - Alocar profesor em Disciplina  
												  |2 - Remover professor de disciplina'.
			
				(answer='1') ifTrue:[
				|nome|
				nome := UIManager default request:'Digite o codigo do professor'.
						
				self alocarProfessor: nome.
				].
				(answer='2') ifTrue:[
					|code|
					code := UIManager default request:'Digite o codigo do professor'.
					self removerProfessor: code.
				].
			
		 ].
		(resposta = '6') ifTrue:[
			"self relatorioTodasTurmas."
			"self relatorioTurmaSemProfessor."
			self relatorioCargaHorariaProfessor. 
			self escreverOfertaPeriodo.
	
		].
		
resposta ~= '0' ]whileTrue.


alocarProfessor:  codProfessor
|x i string1 professor  z|

x := Turma new.

i := 1. " Quem é o professor?"
[i < contadorProfessores ] whileTrue:[
	((professores at: i) getCodigo = codProfessor) ifTrue: [z:= i. professor := (professores at: i).].
	
	i := i +1.
].

string1:= UIManager default request: 'Digite codigo disciplina'.

i:=1.
[ i < contadorTurmas  ] whileTrue: [  
	
	|string2 |
	string2 := (turmas at: i) getCodigoDisciplina.

	(string1 = string2) ifTrue:[ "if true 1"
		|prompt|
		prompt:= UIManager default request: 'Essa turma está no seguinte horário', ((turmas at: i ) getHorario) , 'Prosseguir? S?N'.
			((prompt = 'n') | (prompt = 'N')) ifTrue:[
				|comando|
				comando:= UIManager default request: 'deseja alterar esse horário?'.
				((comando= 's') | (comando= 'S')) ifTrue:[ 
					|horario|
					horario := UIManager default request: 'Digite o código do horario'.
					(turmas at: i ) setHorario: horario.
					].
			].
			((prompt = 's') | (prompt = 'S')) ifTrue:[ "if 2"
						|cont boleano|
						cont := 1.
						[ cont < 8 ] whileTrue: [
						
						((professor retornarHorario: cont) = (turmas at: i ) getHorario)  ifTrue: [  "if 3"
								self turmasPorDocente: (professor getCodigo).
								UIManager default request: 'Não é permitido pois o horário não está disponivel '.
								cont := 10.
								boleano := false.	] "end if 3"
							ifFalse: [
								boleano:= true.	
								cont := cont + 1.							
								].
						].
						((boleano = true))ifTrue:[ "if a"
							(((turmas at: i) getProfessor: 1) = nil) ifTrue:[ "if y"
								|resposta|
								resposta := UIManager default request: 'Deseja alocar como primeiro professor?  S/N'.
								((resposta = 's') | (resposta = 'S')) ifTrue:[ "if x"
									(turmas at: i) setProfessor:  professor at: 1.
									(professores at: z) adicionarHorario: ((turmas at: i ) getHorario).
															
									]. "if x"
									((resposta = 'n') | (resposta = 'N')) ifTrue:[
										|a|
										a := UIManager default request: 'Deseja criar nova turma?  S/N'.
											((a = 's') | (a = 'S')) ifTrue:[
												self criarTurmas: string2.
											].
										].
.									
								] "if y"
								ifFalse:[ (((turmas at: i) getProfessor: 2) = nil) ifTrue:[
										|resposta|
										resposta := UIManager default request: 'Deseja alocar como segundo professor?  S/N'.
										((resposta = 's') | (resposta = 'S')) ifTrue:[ "if x"
												(turmas at: i) setProfessor:  professor at: 2.
												(professores at: z) adicionarHorario: ((turmas at: i ) getHorario).
																
												] "if x"
										
										
										]
							
								].
								
							] "if a"
					]. "End if 2"
			]. 
		i := i + 1.	
].

criarTurmasPadrao
| a i|
 i:= 1.
     
[  i < contadorDisciplinas ] whileTrue: [
	
	a := Turma new.
	a iniciar:1.
	
	a setHorario: ((disciplinas at: i)getHorario).
	a setNomeDisciplina: ((disciplinas at: i)getNome).
	a setCodigoDisciplina: ((disciplinas at: i)getCodigo).
	a setCreditos: ((disciplinas at: i)getCreditos).
		
	(((disciplinas at: i) getHorario findString: 'M') > 0) ifTrue: [ a setID: 'M1'].
	(((disciplinas at: i) getHorario findString: 'T') > 0) ifTrue: [ a setID: 'T1'].
	(((disciplinas at: i) getHorario findString: 'N') > 0) ifTrue: [ a setID: 'N1'].
	
	turmas at: i put: a.	
	
	contadorTurmas  := contadorTurmas  +1.
	i := i + 1.
].

criarTurmas: codigo_disciplina  "Erro"
| a i respostas|
 i:= 1.

	a := Turma new.
	a iniciar:1.
	
	respostas := UIManager default request: 'Digite o horario'.
	a setHorario: respostas.
	
	respostas := UIManager default request: 'Digite o ID'.
	a setID: respostas.
	
	a setNomeDisciplina: codigo_disciplina.
	a setCodigoDisciplina: ((disciplinas at: i)getCodigo).
	a setCreditos: ((disciplinas at: i)getCreditos).
		
		
	turmas at: i put: a.	
		
	[  i < contadorDisciplinas ] whileTrue: [	
	
		contadorTurmas  := contadorTurmas  +1.
	i := i + 1.
].

removerProfessor: cod   "Não funcionando corretamente"
|i j professor cod_disc|
i := j := 1.

i := 1. " Quem é o professor?"
[i < contadorProfessores ] whileTrue:[
	((professores at: i) getCodigo = cod) ifTrue: [j:= i. professor := (professores at: i). i:= 1000].
	
	i := i +1.
].

cod_disc:= UIManager default request: 'Digite codigo disciplina'.

i := 1.

[i < contadorTurmas] whileTrue:[  
	Transcript show: ((turmas at: i) getCodigoDisciplina) asArray.
	"((((turmas at: i) getCodigoDisciplina) = cod_disc)) ifTrue:[
		Transcript show: 'Entrou aqui'.
		(turmas at: i) setProfessor: nil at:1.
		(professores at: j) removerHorario: (turmas at:i) getHorario.
	]."
i := i +1.	
].



LerArquivoDisciplina: nomeArq
| fs|

fs := FileStream fileNamed:'C:/Users/Dimitri/Desktop/',nomeArq.
[fs atEnd] whileFalse: [
 | line x linha|
  line := fs upTo: Character cr. 
 x := Disciplina new.
 linha:= (line subStrings: ';'). 

   
x setCodigo: (linha atWrap: 1) .
x setNome: (linha atWrap: 2) .
x setCreditos: (linha atWrap: 3) .
x setHorario: (linha atWrap: 4) .

disciplinas at: contadorDisciplinas  put: x.

contadorDisciplinas := contadorDisciplinas + 1.
  
]. 
fs close


lerArquivoGradeCC: nomeArq
| fs|

fs := FileStream fileNamed:'C:/Users/Dimitri/Desktop/',nomeArq.
[fs atEnd] whileFalse: [
 | line  linha|
  line := fs upTo: Character cr. 
 
 linha:= (line subStrings: ';'). 

gradeCC at: contadorCC  put: (linha atWrap: 1).

contadorCC := contadorCC + 1.
  
]. 
fs close

lerArquivoGradeEC: nomeArq
| fs|

fs := FileStream fileNamed:'C:/Users/Dimitri/Desktop/',nomeArq.
[fs atEnd] whileFalse: [
 | line  linha|
  line := fs upTo: Character cr. 

 linha:= (line subStrings: ';'). 

gradeEC at: contadorEC  put: (linha atWrap: 1).

contadorEC := contadorEC + 1.
  
]. 
fs close

lerArquivoGradeSI: nomeArq
| fs|

fs := FileStream fileNamed:'C:/Users/Dimitri/Desktop/',nomeArq.
[fs atEnd] whileFalse: [
 | line  linha|
  line := fs upTo: Character cr. 

 linha:= (line subStrings: ';'). 

gradeSI at: contadorSI  put: (linha atWrap: 1).

contadorSI := contadorSI + 1.
  
]. 
fs close

lerArquivoProfessor: nomeArq
| fs  |
fs := FileStream fileNamed:'C:/Users/Dimitri/Desktop/',nomeArq.
[fs atEnd] whileFalse: [
  | line x linha|
  line := fs upTo: Character cr. 

x := Professor new.
linha:= (line subStrings: ';'). 
   
x setCodigo: (linha atWrap: 2) .
x setNome: (linha atWrap: 1) .
x iniciar.

professores at: contadorProfessores  put: x.
contadorProfessores := contadorProfessores + 1.
]. 



normalizarVetor
|z|
z:=1.
[z  < contadorDisciplinas ] whileTrue:[
	(z > 1) ifTrue: [ 
		| i temp retorno|
		retorno := ''.
		temp:= (disciplinas at: z) getCodigo.
		temp:= temp asArray.
		
		i := 2.
		[i <= temp size] whileTrue:[
			|a|
			a := (temp at: i).
			a := a asString.
			retorno := retorno,a.
			i := i +1.
			].
			
		(disciplinas at: z) setCodigo: retorno.
		].
	z := z+ 1.
	].

z := 1.

[z  < contadorCC ] whileTrue:[
	(z > 1) ifTrue: [ 
		| i temp retorno|
		retorno := ''.
		temp:= (gradeCC at: z).
		temp:= temp asArray.
		
		i := 2.
		[i <= temp size] whileTrue:[
			|a|
			a := (temp at: i).
			a := a asString.
			retorno := retorno,a.
			i := i +1.
			].
			
		gradeCC at: z put: retorno.
		].
	z := z+ 1.
].

z := 1.

[z  < contadorEC ] whileTrue:[
	(z > 1) ifTrue: [ 
		| i temp retorno|
		retorno := ''.
		temp:= (gradeEC at: z).
		temp:= temp asArray.
		
		i := 2.
		[i <= temp size] whileTrue:[
			|a|
			a := (temp at: i).
			a := a asString.
			retorno := retorno,a.
			i := i +1.
			].
			
		gradeEC at: z put: retorno.
		].
	z := z+ 1.
].




z := 1.

[z  < contadorSI ] whileTrue:[
	(z > 1) ifTrue: [ 
		| i temp retorno|
		retorno := ''.
		temp:= (gradeSI at: z).
		temp:= temp asArray.
		
		i := 2.
		[i <= temp size] whileTrue:[
			|a|
			a := (temp at: i).
			a := a asString.
			retorno := retorno,a.
			i := i +1.
			].
			
		gradeSI at: z put: retorno.
		].
	z := z+ 1.
].

consultarDisciplinaPeloCodigo: codigo
|a i|

i:=1.

[i < contadorDisciplinas ] whileTrue: [
	a := ((disciplinas at: i) getCodigo).
	(codigo = a) ifTrue:[Transcript show: ((disciplinas at: i) getCodigo).
			Transcript clear.
			Transcript show: ((disciplinas at: i) getNome) ,  '   |'  .
			Transcript show: ((disciplinas at: i) getCreditos),  '   |'  .
			Transcript show: ((disciplinas at: i) getHorario).
			
			].
		
i:= 1 + i.
].

consultarDisciplinaPeloNome: nome
| i  a |

i :=1.
[  i < contadorDisciplinas ] whileTrue:[
	a:= ((disciplinas at: i) getNome).
(a = nome)  ifTrue:[Transcript show: ((disciplinas at: i) getCodigo).
			Transcript clear.
			Transcript show: ((disciplinas at: i) getNome),  '   |'  .
			Transcript show: ((disciplinas at: i) getCreditos),  '   |'  .
			Transcript show: ((disciplinas at: i) getHorario).
			Transcript cr.
			].
i := i+1.
]

consultarGradeCurricularEC
|i j|

i :=j:=1.
Transcript clear.
Transcript show: 'Primeiro Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr.

[  j < contadorEC    ] whileTrue:[
| temp temp2|
temp2:= (gradeEC at:j) asArray.
i:= 1.	
	[ i < contadorDisciplinas  ] whileTrue:[
	temp := ((disciplinas at: i) getCodigo) asArray.	

			(temp = temp2) ifTrue: [ Transcript show: (disciplinas at: i) getCodigo , ' | ',  (disciplinas at: i) getNome , ' | ', (disciplinas at: i) getCreditos , ' | ' .
				Transcript cr].
		
		
	i := i +1.
	]. "End while interno"

(j = 6) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Segundo Periodo'.
	Transcript cr.

Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 14) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Terceiro Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 20) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Quarto Periodo'.

Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 27) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Quinto Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 33) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Sexto Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 39) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Setimo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 45) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Oitavo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

(j = 48) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Nono Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

(j = 50) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Nono Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].


j := j+1.

]."End while externo"

consultarGradeCurricularCC
|i j|

i :=j:=1.
Transcript clear.
Transcript show: 'Primeiro Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr.

[  j < contadorCC    ] whileTrue:[
| temp temp2|
temp2:= (gradeCC at:j) asArray.
i:= 1.	
	[ i < contadorDisciplinas  ] whileTrue:[
	temp := ((disciplinas at: i) getCodigo) asArray.	
				(temp = temp2) ifTrue: [ Transcript show: (disciplinas at: i) getCodigo , ' | ',  (disciplinas at: i) getNome , ' | ', (disciplinas at: i) getCreditos , ' | ' .
				Transcript cr].
			
	i := i +1.
	]. "End while interno"

(j = 6) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Segundo Periodo'.
	Transcript cr.

Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 13) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Terceiro Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 20) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Quarto Periodo'.

Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 27) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Quinto Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 33) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Sexto Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 39) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Setimo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 42) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Oitavo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

j := j+1.

]."End while externo"


consultarGradeCurricularSI
|i j|

i :=j:=1.
Transcript clear.
Transcript show: 'Primeiro Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr.

[  j < contadorSI    ] whileTrue:[
| temp temp2|
temp2:= (gradeSI at:j) asArray.
i:= 1.	
	[ i < contadorDisciplinas  ] whileTrue:[
	temp := ((disciplinas at: i) getCodigo) asArray.	
			(temp = temp2) ifTrue: [ Transcript show: (disciplinas at: i) getCodigo , ' | ',  (disciplinas at: i) getNome , ' | ', (disciplinas at: i) getCreditos , ' | ' .
				Transcript cr].
	i := i +1.
	]. "End while interno"
j := j+1.

(j = 5) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Segundo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].


(j = 11) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Terceiro Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

(j = 17) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Quarto Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].
(j = 21) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Quinto Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

(j = 26) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Sexto Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

(j = 30) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Setimo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].


(j = 35) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Oitavo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

(j = 38) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Nono Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].

(j = 40) ifTrue: [ Transcript show: '--------------------------------------------------------------------------------'.
	Transcript cr.
	Transcript show: 'Decimo Periodo'.
Transcript cr.
Transcript show: 'Código       |     Nome                              | Creditos |     Horário'.
Transcript cr. ].


]."End while externo"

relatorioCargaHorariaProfessor
|i j fs|

fs := FileStream newFileNamed: 'C:/Users/Dimitri/Desktop/RelatorioCargaHorariaProfessor.txt'.

i := j :=1.

[  i < contadorProfessores  ] whileTrue:[
	|contadorCreditos profNome|
	contadorCreditos:=0.
	j:=1.
	profNome :=  ((professores at: i) getNome).
	fs write: profNome.
	fs write: String cr.
	"Transcript show: profNome.
	Transcript cr."
	[ j < contadorTurmas ]	whileTrue:[
		((turmas at: j) temProfessor) ifTrue:[
			|a b|
			a := ((turmas at: j) getProfessor: 1) getNome.
			b := ((turmas at: j) getProfessor: 1) getNome.
		     ((a = profNome) | (b = profNome)) ifTrue:[
			contadorCreditos := contadorCreditos + ((turmas at: j) getCreditos asInteger).
			"Transcript show: (turmas at: j) getCodigoDisciplina , ' | '. "
			fs write: (turmas at: j) getCodigoDisciplina , ' | '. 
			"Transcript show: (turmas at: j) getID. "
			fs write: (turmas at: j) getID. 
			"Transcript cr."
			fs write: String cr.
							
			].
				
			
			].
		j:= j+1.
		].		
				fs write: String cr.
				fs write: 'Carga Horaria Total:  '.
				"Transcript show: 'Carga Horaria Total:  '."
				fs write: (contadorCreditos * 15).
				"Transcript show: (contadorCreditos * 15)."
				fs write:' horas'.
				"Transcript show:  ' horas'."
				fs write: String cr.
	i := i + 1.
].

fs close.


relatorioTodasTurmas

|i fs|
fs := FileStream newFileNamed: 'C:/Users/Dimitri/Desktop/RelatorioTodasTurmas.txt'.

i:= 1.

[ i < contadorTurmas]whileTrue:[
	((turmas at: i) temProfessor) ifTrue:[
		fs write: (turmas at: i) getNomeDisciplina , ' | '. 
		fs write: (turmas at: i) getCodigoDisciplina, '  | '.
		fs write: (turmas at: i) getCreditos, ' |  '.
		fs write: (turmas at: i) getHorario, ' |  '. 
		fs write: (turmas at: i) getID, ' |  '. 
		
		Transcript show: (turmas at: i) getNomeDisciplina , ' | '. 
		Transcript show: (turmas at: i) getCodigoDisciplina, '  | '.
		Transcript show: (turmas at: i) getCreditos, ' |  '. 
		Transcript show: (turmas at: i) getHorario, ' |  '. 
		Transcript show: (turmas at: i) getID, ' |  '. 
		"Transcript show: ((turmas at: i) getProfessor: 1) , ' |  '. "
		Transcript show: ((turmas at: i) getProfessor: 2)  ifNil:[fs write:  '  ;' ]. 
		Transcript cr.
		
	].
	((turmas at: i) naotemProfessor) ifTrue:[
		fs write: (turmas at: i) getNomeDisciplina , ' | '. 
		fs write: (turmas at: i) getCodigoDisciplina, '  | '.
		fs write: (turmas at: i) getCreditos, ' |  '.
		fs write: (turmas at: i) getHorario, ' |  '. 
		(fs write: (turmas at: i) getID)  ifNil:[fs write:  '  ;' ]. 
		
		
		Transcript show: (turmas at: i) getNomeDisciplina , ' | '. 
		Transcript show: (turmas at: i) getCodigoDisciplina, '  | '.
		Transcript show: (turmas at: i) getCreditos, ' |  '. 
		Transcript show: (turmas at: i) getHorario, ' |  '. 
		(Transcript show: (turmas at: i) getID) ifNil:[fs write:  '  ;' ]. 
		Transcript cr.
		
	].	
i := i +1.
].
fs close.

relatorioTurmaSemProfessor

|i fs|
fs := FileStream newFileNamed: 'C:/Users/Dimitri/Desktop/RelatorioTurmaSemProfessor.txt'.

i:= 1.

[ i < contadorTurmas]whileTrue:[
	
	((turmas at: i) naotemProfessor) ifTrue:[
		fs write: (String cr).
		fs write: (turmas at: i) getNomeDisciplina , ' | '. 
		"Transcript show: (turmas at: i) getNomeDisciplina , ' | '. "
		fs write:  (turmas at: i) getCodigoDisciplina, '  | '.
		"Transcript show: (turmas at: i) getCodigoDisciplina, '  | '."
		fs write:  (turmas at: i) getCreditos, ' |  '. 
		"Transcript show: (turmas at: i) getCreditos, ' |  '. "
		fs write: (String cr).
		"Transcript cr."
			
	].
i := i +1.
].
fs close.

turmasPorDocente: cod_docente
|i  j  professor|  

i := 1. " Quem é o professor?"
[i < contadorProfessores ] whileTrue:[
	((professores at: i) getCodigo =cod_docente) ifTrue: [j:= i. professor := (professores at: i). i:= 1000].
	
	i := i +1.
].

i:=1.

[ i < contadorTurmas ] whileTrue:[
	((((turmas at:i) getProfessor:1) = professor) | (((turmas at:i )getProfessor:2)= professor)) ifTrue:[
		Transcript show: (turmas at:i) getHorario.
		Transcript show: (turmas at:i) getNomeDisciplina.
		
		].

	i:=1+i.
].

escreverOfertaPeriodo

|i fs|
fs := FileStream newFileNamed: 'C:/Users/Dimitri/Desktop/Oferta(2014.1).txt'.

i:= 1.

[ i < contadorTurmas]whileTrue:[
		fs write: (turmas at: i) getNomeDisciplina , ' | '. 
		fs write: (turmas at: i) getCodigoDisciplina, '  | '.
		fs write: (turmas at: i) getCreditos, ' |  '.
		fs write: (turmas at: i) getHorario, ' |  '. 
		fs write: (turmas at: i) getID, ' |  '. 

i := i +1.
].
fs close.
