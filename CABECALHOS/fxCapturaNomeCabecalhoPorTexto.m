let
    fxCapturaNomeCabecalhoPorTexto =
        (tabela as table, textoProcurado as text) as text =>
        let
            listaColunasOriginais   = Table.ColumnNames(tabela),
            listaColunasMaiusculas  = List.Transform(listaColunasOriginais, each Text.Upper(_)),
            textoMaiusculo          = Text.Upper(textoProcurado),
            nomeColunaMaiusculo     = List.Select(listaColunasMaiusculas, each Text.Contains(_, textoMaiusculo)){0},
            indiceColuna            = List.PositionOf(listaColunasMaiusculas, nomeColunaMaiusculo),
            nomeColunaOriginal      = listaColunasOriginais{indiceColuna}
        in
            nomeColunaOriginal,

    documentation = [
        Documentation.Name = "fxCapturaNomeCabecalhoPorTexto",
        Documentation.Description = "Retorna o nome exato (com capitalização original) de uma coluna que contenha parte do texto informado, ignorando diferenças entre maiúsculas e minúsculas.",
        Documentation.LongDescription = "Esta função percorre os nomes das colunas da tabela fornecida, compara com o texto informado de forma insensível à capitalização (case-insensitive) e retorna o nome original da primeira coluna que contenha esse trecho.",
        Documentation.Category = "Funções Utilitárias",
        Documentation.Author = "ChatGPT + Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Buscar coluna com parte do nome VENDA",
                Code = "fxCapturaNomeCabecalhoPorTexto( MinhaTabela, VENDA )",
                Result = "Retorna o nome real da coluna como: Data da Venda"
            ]
        }
    ]
in
    Value.ReplaceType(fxCapturaNomeCabecalhoPorTexto, Value.ReplaceMetadata(Value.Type(fxCapturaNomeCabecalhoPorTexto), documentation))
