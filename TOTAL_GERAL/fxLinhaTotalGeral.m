// Função: AdicionarTotalGeral
// Parâmetros:
//   tabelaOriginal      = a tabela de entrada (qualquer consulta/tabela do Power Query)
//   nomeColunaRótulo    = o nome da coluna de texto onde será escrito "Total Geral"
// Retorno: 
//   a mesma tabela original + 1 linha extra chamada "Total Geral" com a soma de todas as colunas numéricas.

(tabelaOriginal as table, nomeColunaRótulo as text) as table =>
let
    // 1) Identificar dinamicamente quais colunas têm tipo número
    ColunasNumericas = 
        List.Select(
            Table.ColumnNames(tabelaOriginal),
            each 
                let
                    // Remove nulls e pega o primeiro valor existente
                    primeiroValor = List.First( List.RemoveNulls(Table.Column(tabelaOriginal, _)) )
                in
                    // Verifica se esse primeiro valor é do tipo number
                    Value.Type(primeiroValor) = type number
        ),

    // 2) Somar cada uma das colunas numéricas encontradas
    SomaColunas = List.Transform(
        ColunasNumericas, 
        each List.Sum(Table.Column(tabelaOriginal, _))
    ),
    // Exemplo: se ColunasNumericas = { "2023", "2024" }, então SomaColunas = {60, 18}

    // 3) Montar um Record (registro) com o rótulo "Total Geral" na coluna desejada
    //    e as somas nas colunas numéricas
    RegistroTotal = 
        Record.FromList(
            { "Total Geral" } & SomaColunas,      // Primeiro item = texto, depois as somas
            { nomeColunaRótulo } & ColunasNumericas
        ),
    // Se nomeColunaRótulo = "Categoria" e ColunasNumericas = { "2023", "2024" }, 
    // então RegistroTotal corresponde a algo como:
    //   [ Categoria = "Total Geral", 2023 = 60, 2024 = 18 ]

    // 4) Converter esse record num "registro de tabela" (uma tabela de 1 linha)
    TabelaLinhaTotal = Table.FromRecords({ RegistroTotal }),

    // 5) Concatenar (combinar) a tabela original com a linha de totais
    ResultadoFinal = Table.Combine({ tabelaOriginal, TabelaLinhaTotal })

in

    ResultadoFinal
