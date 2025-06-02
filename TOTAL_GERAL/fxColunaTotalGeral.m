// ----------------------------------------------------------------------------
// Função: AdicionarTotalIgnorandoNaoNumericas
// ----------------------------------------------------------------------------
// Esta função recebe uma tabela qualquer (com quaisquer colunas de texto ou data 
// misturadas entre colunas numéricas) e adiciona uma nova coluna que soma  
// apenas os valores numéricos de cada linha. O nome da nova coluna é passado 
// como parâmetro.
//
// Parâmetros:
//   • tabelaOriginal  (table) – sua tabela de entrada (ex.: Categoria, Subcategoria, 
//                              Janeiro, Custom, Fevereiro, Março, …).
//   • nomeColunaTotal (text)  – nome que você quer dar à coluna de soma por linha.
//                              Deve ser diferente de qualquer coluna existente.
//
// Retorno:
//   A mesma tabela original acrescida de uma coluna (nomeColunaTotal) contendo, em 
//   cada linha, a soma de todas as colunas cujo tipo seja number naquela linha.
// ----------------------------------------------------------------------------

(tabelaOriginal as table, nomeColunaTotal as text) as table =>
let
    // 1) Pega todos os nomes de coluna na ordem em que aparecem
    NomesColunas = Table.ColumnNames(tabelaOriginal),

    // 2) Detecta quais colunas têm tipo Number (verificando o primeiro valor não nulo)
    ColunasNumericas =
        List.Select(
            NomesColunas,
            each
                let
                    coluna = _,
                    // Extrai todos os valores da coluna, remove nulos e pega o primeiro valor
                    primeiroValor = List.First( List.RemoveNulls( Table.Column(tabelaOriginal, coluna) ) )
                in
                    // Confirma se esse primeiro valor é realmente do tipo number
                    Value.Type(primeiroValor) = type number
        ),
    // Exemplo: se a sua tabela for { "Categoria", "Subcategoria", "Janeiro", "Custom", "Fevereiro", "Março" },
    // e apenas Janeiro, Fevereiro, Março forem números, então:
    //    ColunasNumericas = { "Janeiro", "Fevereiro", "Março" }.

    // 3) Adiciona a coluna de soma por linha, somando apenas as colunas acima
    Resultado =
        Table.AddColumn(
            tabelaOriginal,
            nomeColunaTotal,
            each 
                let
                    // Seleciona, no registro da linha atual (_), apenas os campos de ColunasNumericas
                    registroNumerico = Record.SelectFields(_, ColunasNumericas),

                    // Converte esse record de valores numéricos em lista, para aplicar List.Sum
                    listaNumerica = Record.ToList(registroNumerico)
                in
                    List.Sum(listaNumerica),
            type number  // Define que a nova coluna será do tipo number
        )
in
    Resultado
