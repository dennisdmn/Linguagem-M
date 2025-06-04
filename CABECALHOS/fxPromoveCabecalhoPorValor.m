let
    fxPromoveCabecalhoPorValor = (
        Tabela as table,
        NomeColunaBusca as text,
        ValorCabecalho as text
    ) as table =>
    let
        // 🧮 Adiciona índice para rastrear posição da linha de cabeçalho
        Etapa_AdicionaIndice = Table.AddIndexColumn(Tabela, "Indice", 0, 1, Int64.Type),

        // 🔍 Filtra a linha cujo valor na coluna informada corresponde ao texto do cabeçalho
        Etapa_EncontraLinhaCabecalho = Table.SelectRows(
            Etapa_AdicionaIndice,
            each Record.Field(_, NomeColunaBusca) = ValorCabecalho
        ),

        // ⚠️ Validação: erro se não encontrar a linha do cabeçalho
        Etapa_ValidaExistencia = if Table.IsEmpty(Etapa_EncontraLinhaCabecalho) then
            error "Valor '" & ValorCabecalho & "' não encontrado na coluna '" & NomeColunaBusca & "'."
        else
            Etapa_EncontraLinhaCabecalho{0}[Indice],

        // ✂️ Remove linhas acima da linha de cabeçalho real
        Etapa_RemoveLinhasAcima = Table.Skip(Tabela, Etapa_ValidaExistencia),

        // 🏷️ Promove linha como novo cabeçalho
        Etapa_PromoveCabecalhos = Table.PromoteHeaders(
            Etapa_RemoveLinhasAcima,
            [PromoteAllScalars = true]
        )
    in
        Etapa_PromoveCabecalhos,

    // 📘 Metadados de documentação
    documentation = [
        Documentation.Name = "fxPromoveCabecalhoPorValor",
        Documentation.Description = "Localiza a linha onde um valor específico ocorre em uma coluna informada e promove essa linha como cabeçalho real.",
        Documentation.LongDescription =
            "Esta função permite identificar dinamicamente a linha que contém determinado valor em qualquer coluna da tabela, " &
            "remover todas as linhas acima e promovê-la como cabeçalho. Ideal para arquivos Excel onde o cabeçalho real não está na primeira linha e pode variar.",
        Documentation.Category = "Limpeza e transformação de dados",
        Documentation.Source = "Interno - Power Query",
        Documentation.Author = "Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Promover linha onde a coluna 'Cliente' tem o valor 'ID_CLIENTE'",
                Code = "fxPromoveCabecalhoPorValor(TabelaBruta, ""Cliente"", ""ID_CLIENTE"")",
                Result = "Retorna a tabela com cabeçalhos reais"
            ]
        }
    ]
in
    Value.ReplaceType(fxPromoveCabecalhoPorValor, Value.ReplaceMetadata(Value.Type(fxPromoveCabecalhoPorValor), documentation))
