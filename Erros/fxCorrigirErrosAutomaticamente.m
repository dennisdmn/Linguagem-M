// 🧠 Função genérica para tratamento automático de erros em tabelas do Power Query
// Esta função percorre todas as colunas de uma tabela, identifica colunas com erros,
// determina o tipo de dado da coluna e aplica um valor padrão para substituir os erros:
// - 0 para colunas numéricas
// - "N/D" para colunas textuais
// - null para datas e outros tipos não tratados

(CorpoTabela as table) as table =>
let
    // 🔍 Etapa 1: Identifica colunas que contêm pelo menos um valor com erro
    // A lógica compara a quantidade de valores não nulos com o número total de linhas da tabela.
    // Se a contagem for menor, significa que houve erro em alguma célula (que virou null com `try`).
    ColunasComErros = List.Select(
        Table.ColumnNames(CorpoTabela),
        (col) =>
            List.NonNullCount(
                List.Transform(Table.Column(CorpoTabela, col), each try _ otherwise null)
            ) < Table.RowCount(CorpoTabela)
    ),

    // 🔄 Etapa 2: Cria uma lista de pares {nome da coluna, valor substituto}
    // O valor substituto é definido de acordo com o tipo de dado da primeira célula não nula da coluna
    SubstituirErros = List.Transform(ColunasComErros, each
        let
            NomeColuna = _,  // Nome da coluna atual
            TipoColuna = Value.Type(CorpoTabela{0}[NomeColuna]),

            // Define o valor padrão de substituição com base no tipo
            Substituto =
                if TipoColuna = type number or TipoColuna = Int64.Type then 0
                else if TipoColuna = type text then "N/D"
                else if TipoColuna = type date or TipoColuna = type datetime then null
                else null
        in
            {NomeColuna, Substituto}  // Retorna o par para substituição
    ),

    // 🧼 Etapa 3: Aplica a substituição de erros nas colunas com problemas
    TabelaCorrigida = Table.ReplaceErrorValues(CorpoTabela, SubstituirErros)

in
    // ✅ Retorna a tabela final corrigida
    TabelaCorrigida
