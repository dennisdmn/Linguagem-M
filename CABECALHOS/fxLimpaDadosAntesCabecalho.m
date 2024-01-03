(
    Tabela as table,
    NomePrimeiraColuna as text
)=>

let
/*
    Função abaixo fixa um texto como cabeçalho da coluna 1 e permite remover
    somente as linhas acima independente de sua posição de linha, conf. coluna indice adicionada.
*/
    ColunaIndice = Table.AddIndexColumn(Tabela, "Indice", 0, 1, Int64.Type),
    LinhaComCabecalho = Table.SelectRows(ColunaIndice, each ([Column1] = NomePrimeiraColuna))[Indice]{0},
    LimpaLinhasAnteriores = Table.Skip(Tabela, LinhaComCabecalho),
    Cabecalhos = Table.PromoteHeaders(LimpaLinhasAnteriores, [PromoteAllScalars=true])
in
    Cabecalhos
