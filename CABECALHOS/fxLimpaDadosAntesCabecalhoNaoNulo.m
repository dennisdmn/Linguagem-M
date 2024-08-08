(
    Tabela as table
)=>

let

    // Comando que identifica a 1º linha não nula e limpa as linhas desnecessárias antes do cabeçalho.

    // Adiciona uma coluna de índice para rastrear a posição das linhas
    ColunaIndice = Table.AddIndexColumn(Tabela, "Indice", 0, 1, Int64.Type),
    
    // Função para verificar se uma linha é nula (todas as colunas nulas)
    LinhaNula = each List.NonNullCount(Record.FieldValues(_)) <> null,

    // Encontra o índice da primeira linha não nula
    IndicePrimeiraLinhaNaoNula = List.First(Table.SelectRows(ColunaIndice, each not LinhaNula(_))[Indice]),

    // Remove todas as linhas antes da linha identificada como cabeçalho
    LimpaLinhasAnteriores = Table.Skip(Tabela, IndicePrimeiraLinhaNaoNula),

    // Promove a primeira linha de dados para cabeçalhos
    Cabecalhos = Table.PromoteHeaders(LimpaLinhasAnteriores, [PromoteAllScalars=true])

in

    Cabecalhos
