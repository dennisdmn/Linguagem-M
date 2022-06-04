(Valor as text) =>

/*
	Script para colocar a 1º letra em maiúscula no começo de cada sentença.
*/

let
	
	/* 
        Text.Split => quebra o texto de uma lista conforme um delimitador, formando novas linhas.
        
        Obs.: No entanto, podemos ter mais de um delimitador como: "?", "!", etc. Nesse caso, temos que 
              alterar o 2º argumento por meio da inclusão de mais carcateres.  
    */
    QuebrarTextoCadaPonto = Text.Split(Valor,"."),
    
	// Text.TrimStart => Elimina o espaço do começo de um texto.
	TrimarInicioTexto = List.Transform(QuebrarTextoCadaPonto, each Text.TrimStart(_) ),
    
	// List.Select + each + _ => Seleção de cada linha que não esteja em branco.
	SelecionarSomenteDiferenteBranco = List.Select(TrimarInicioTexto, each _ <> ""),
    
	// Transforma a 1º letra de cada texto em Maiuscula. 
	PrimeiraMaiuscula = List.Transform(SelecionarSomenteDiferenteBranco, each 
        
		let 
			      // Transformar o texto em minusculo e remove espaços no inicio e fim.
            Texto 			= Text.Lower(Text.Trim(_)),
			
            // Transformar a 1º letra de cada texto em Maiuscula.
			      PrimeiraLetra 	= Text.Upper(Text.Start(Texto,1)),
            
            // Verifica o tamanho do texto.
            TamanhoTexto 	= Text.Length(Texto),
            
            // Destaca o texto sem o 1º caracter.
            UltimasLetras 	= Text.End(Texto,TamanhoTexto-1),
            
            // Junção da 1º letra (tratada) com o restante da sentença.
            TextoNovo 		= PrimeiraLetra & UltimasLetras,
			
			      // Elimina espaços no inicio e no fim.
            TextoTrimado 	= Text.Trim(TextoNovo)
			
        in
            
			      TextoTrimado
        ),
		
	// Unifica a lista de texto tratados.
  UnirTextoNovamente = Text.Combine(PrimeiraMaiuscula,". ")

in

    UnirTextoNovamente
