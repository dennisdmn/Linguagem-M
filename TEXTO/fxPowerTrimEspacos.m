/*
  Função Personalizada para eliminar o excesso de espaços entre palavras.
  Exemplo:
          Texto_Original: "Hoje     chove."
          Texto_Tratado:  "Hoje chove."
  ------------------------------------------------------------------------
*/
(text as text) =>
	 let
		 char = " ",
		 split = Text.Split(text, char),
		 removeblanks = List.Select(split, each _ <> ""),
		 result=Text.Combine(removeblanks, char)
	 in
result
