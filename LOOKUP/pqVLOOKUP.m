// pqVLOOKUP
// Funcao inspirada no artigo original de Ken Puls:
// http://www.excelguru.ca/blog/2015/01/28/creating-a-vlookup-function-in-power-query/
//
// Objetivo:
// Simular uma PROCV/VLOOKUP em Power Query M usando a primeira coluna da tabela
// como coluna de busca e retornando a coluna indicada por posicao.
//
// Observacao:
// Para correspondencia exata em tabelas grandes, prefira mesclar consultas.
// Esta funcao e mais util para cenarios pequenos, reaproveitamento didatico
// ou correspondencia aproximada.

(lookup_value as any, table_array as table, col_index_number as number, optional approximate_match as nullable logical) as any =>
let
    ValorNaoEncontrado = "#N/A",
    UsarCorrespondenciaAproximada = if approximate_match = null then true else approximate_match,

    NomesColunas = Table.ColumnNames(table_array),
    QuantidadeColunas = List.Count(NomesColunas),
    IndiceColunaValido =
        col_index_number >= 1
        and Number.RoundDown(col_index_number) = col_index_number
        and col_index_number <= QuantidadeColunas,

    Resultado =
        if not IndiceColunaValido then
            error Error.Record(
                "pqVLOOKUP",
                "col_index_number deve ser um numero inteiro entre 1 e a quantidade de colunas da tabela.",
                [
                    col_index_number = col_index_number,
                    quantidade_colunas = QuantidadeColunas
                ]
            )
        else
            let
                NomeColunaBusca = NomesColunas{0},
                NomeColunaRetorno = NomesColunas{col_index_number - 1},
                TabelaBuffer = Table.Buffer(table_array),

                LinhasEncontradas =
                    if UsarCorrespondenciaAproximada then
                        let
                            LinhasOrdenadas = Table.Sort(TabelaBuffer, {{NomeColunaBusca, Order.Descending}}),
                            LinhasCandidatas = Table.SelectRows(
                                LinhasOrdenadas,
                                each try Record.Field(_, NomeColunaBusca) <= lookup_value otherwise false
                            )
                        in
                            LinhasCandidatas
                    else
                        Table.SelectRows(
                            TabelaBuffer,
                            each Value.Equals(Record.Field(_, NomeColunaBusca), lookup_value)
                        ),

                ValorRetorno =
                    if Table.IsEmpty(LinhasEncontradas) then
                        ValorNaoEncontrado
                    else
                        Record.Field(LinhasEncontradas{0}, NomeColunaRetorno)
            in
                ValorRetorno
in
    Resultado
