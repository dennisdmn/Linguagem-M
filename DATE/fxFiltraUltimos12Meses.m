// fxFiltraUltimos12Meses
// Filtra os últimos 12 meses com base na data máxima encontrada na coluna informada.
//
// Exemplo de uso:
// fxFiltraUltimos12Meses(
//     Etapa_TextoMaiusculo,
//     "DATA_DA_VENDA_CONTRATO"
// )
//
// Exemplo prático:
// Se a data máxima da coluna for 15/03/2026,
// a função retornará os registros de 01/04/2025 até 31/03/2026.

(tabela as table, nomeColunaData as text) as table =>
let
    // Valida se a coluna informada existe na tabela
    ValidaColuna =
        if not List.Contains(Table.ColumnNames(tabela), nomeColunaData) then
            error "A coluna informada não existe na tabela."
        else
            tabela,

    // Extrai apenas datas válidas da coluna escolhida
    ListaDatasValidas = List.RemoveNulls(
        List.Transform(
            Table.Column(ValidaColuna, nomeColunaData),
            each try Date.From(_) otherwise null
        )
    ),

    // Valida se existe ao menos uma data válida
    ValidaDatas =
        if List.IsEmpty(ListaDatasValidas) then
            error "A coluna informada não possui datas válidas."
        else
            ListaDatasValidas,

    // Obtém a data máxima da coluna
    DataMaxima = List.Max(ValidaDatas),

    // Define o intervalo dos últimos 12 meses
    DataInicial = Date.StartOfMonth(Date.AddMonths(DataMaxima, -11)),
    DataFinal   = Date.EndOfMonth(DataMaxima),

    // Filtra a tabela dentro do intervalo calculado
    FiltraUltimos12Meses = Table.SelectRows(
        ValidaColuna,
        each
            let
                DataLinha = try Date.From(Record.Field(_, nomeColunaData)) otherwise null
            in
                DataLinha <> null
                and DataLinha >= DataInicial
                and DataLinha <= DataFinal
    )
in
    FiltraUltimos12Meses
