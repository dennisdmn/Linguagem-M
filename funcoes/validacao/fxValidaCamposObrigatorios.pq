let
    // 🔁 Função para validar campos obrigatórios informados como texto separado por vírgula
    Source = (
        Tabela as table,
        ColunasObrigatoriasTexto as text,
        optional NomeColunaErros as nullable text,
        optional NomeColunaStatus as nullable text
    ) as table =>

        let
            // 📌 Converte o texto separado por vírgula em lista de colunas, removendo itens vazios
            ColunasObrigatorias = List.Select(
                List.Transform(
                    Text.Split(ColunasObrigatoriasTexto, ","),
                    each Text.Trim(_)
                ),
                each _ <> ""
            ),

            // 🏷️ Define o nome da coluna que listará os campos em branco
            vNomeColunaErros =
                if NomeColunaErros = null then
                    "Campos_Em_Branco"
                else
                    NomeColunaErros,

            // 🏷️ Define o nome da coluna de status da validação
            vNomeColunaStatus =
                if NomeColunaStatus = null then
                    "Status_Validacao"
                else
                    NomeColunaStatus,

            // 🔎 Adiciona coluna com os nomes das colunas obrigatórias que estão em branco
            Etapa_AdicionaCamposEmBranco = Table.AddColumn(
                Tabela,
                vNomeColunaErros,
                each
                    Text.Combine(
                        List.Select(
                            ColunasObrigatorias,
                            (coluna) =>
                                let
                                    valor = Record.FieldOrDefault(_, coluna, null),
                                    texto = try Text.Trim(Text.From(valor)) otherwise ""
                                in
                                    valor = null
                                    or texto = ""
                        ),
                        ", "
                    ),
                type text
            ),

            // 🚦 Adiciona coluna de status da validação
            Etapa_AdicionaStatus = Table.AddColumn(
                Etapa_AdicionaCamposEmBranco,
                vNomeColunaStatus,
                each
                    if Record.Field(_, vNomeColunaErros) = "" then
                        "OK"
                    else
                        "Campo obrigatório em branco",
                type text
            )
        in
            Etapa_AdicionaStatus,

    // 📝 Documentação exibida na invocação da função no Power Query
    documentation = [
        Documentation.Name = "fxValidaCamposObrigatorios",
        Documentation.Description = "Valida campos obrigatórios em branco ou nulos em uma tabela.",
        Documentation.LongDescription =
            "Esta função recebe uma tabela e um texto com nomes de colunas separados por vírgula. " &
            "Ela verifica, linha a linha, se alguma dessas colunas obrigatórias está nula, vazia ou apenas com espaços. " &
            "A função adiciona duas colunas ao resultado: uma coluna com a lista dos campos obrigatórios em branco e outra com o status da validação. " &
            "É útil para auditoria de cargas, conferência de layouts, validação de arquivos mensais, bases contábeis, faturamento, backlog, comissões e demais rotinas de qualidade de dados. " &
            "No campo ColunasObrigatoriasTexto, informe os nomes exatamente como aparecem na tabela, separados por vírgula, por exemplo: empresa, filial, debito, credito, valor, data.",
        Documentation.Category = "Validação de Dados",
        Documentation.Source = "Power Query M",
        Documentation.Author = "Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Valida campos obrigatórios básicos de uma base contábil.",
                Code =
                    "fxValidaCamposObrigatorios(" &
                    "#(cr,lf)    Etapa_DefineTipos," &
                    "#(cr,lf)    \"empresa, filial, debito, credito, valor, data\"" &
                    "#(cr,lf))",
                Result =
                    "Retorna a tabela original com as colunas Campos_Em_Branco e Status_Validacao."
            ],
            [
                Description = "Valida campos obrigatórios usando nomes personalizados para as colunas de retorno.",
                Code =
                    "fxValidaCamposObrigatorios(" &
                    "#(cr,lf)    Etapa_DefineTipos," &
                    "#(cr,lf)    \"empresa, filial, debito, credito, valor, data\"," &
                    "#(cr,lf)    \"Campos_Com_Problema\"," &
                    "#(cr,lf)    \"Status\"" &
                    "#(cr,lf))",
                Result =
                    "Retorna a tabela original com as colunas Campos_Com_Problema e Status."
            ]
        }
    ]
in
    Value.ReplaceType(
        Source,
        Value.ReplaceMetadata(
            Value.Type(Source),
            documentation
        )
    )
