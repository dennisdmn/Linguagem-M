let

    CabecalhosPromovidos = Table.PromoteHeaders(LinhasFiltradas2, [PromoteAllScalars = true]),
    
    // Bufferizando as listas de substituição para melhorar performance
    De = List.Buffer(Cabecalhos_De),
    Para = List.Buffer(Cabecalhos_Para),

    // Criando pares de substituição
    Zip = List.Zip({De, Para}),

    // Obtendo os nomes dos cabeçalhos da tabela
    NomesCabecalhos = Table.ColumnNames(CabecalhosPromovidos),

    // Substituindo os nomes dos cabeçalhos conforme definido nas listas De e Para
    NomesCabecalhosPadrao = List.ReplaceMatchingItems(NomesCabecalhos, Zip),

    // Atualizando a tabela com os nomes dos cabeçalhos padronizados
    TabelaPadronizada = Table.RenameColumns(CabecalhosPromovidos, List.Zip({NomesCabecalhos, NomesCabecalhosPadrao}))

in

    TabelaPadronizada
