(
    texto as text,
    caractere_delimitador as text
)=>
/*
    Função que elimina espaços no começo, entre as palavras e após o texto.
    Exemplo (Espacos): " Teste    da Funcao      .    " ===> "Teste da Funcao."
*/
let
    caractere = caractere_delimitador,
    quebra = Text.Split(texto, caractere),
    remove_brancas = List.Select(quebra, each _ <> "")
in
    Text.Combine(remove_brancas, caractere)
