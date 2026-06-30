let
    fxConverteCabecalhosSnakeCase =
        (Tabela as table) as table =>
        let
            // 📌 Etapa 1: Lista os nomes atuais das colunas
            Etapa_ListaCabecalhos = Table.ColumnNames(Tabela),

            // 🧼 Etapa 2: Função interna para remover acentos comuns
            Etapa_RemoveAcentos = (Texto as text) as text =>
                let
                    Lista_Substituicoes = {
                          {"á", "a"}, {"à", "a"}, {"ã", "a"}, {"â", "a"}, {"ä", "a"}
                        , {"é", "e"}, {"è", "e"}, {"ê", "e"}, {"ë", "e"}
                        , {"í", "i"}, {"ì", "i"}, {"î", "i"}, {"ï", "i"}
                        , {"ó", "o"}, {"ò", "o"}, {"õ", "o"}, {"ô", "o"}, {"ö", "o"}
                        , {"ú", "u"}, {"ù", "u"}, {"û", "u"}, {"ü", "u"}
                        , {"ç", "c"}, {"ñ", "n"}
                    },

                    Texto_SemAcentos = List.Accumulate(
                        Lista_Substituicoes,
                        Texto,
                        (Estado, Atual) => Text.Replace(Estado, Atual{0}, Atual{1})
                    )
                in
                    Texto_SemAcentos,

            // 🏷️ Etapa 3: Função interna para converter um texto para snake_case
            Etapa_ConverteTexto = (Texto as text) as text =>
                let
                    Texto_Minusculo = Text.Lower(Text.Trim(Texto)),
                    Texto_SemAcentos = Etapa_RemoveAcentos(Texto_Minusculo),

                    Texto_ComSeparadores = Text.Combine(
                        List.Transform(
                            Text.ToList(Texto_SemAcentos),
                            each
                                if Text.Contains("abcdefghijklmnopqrstuvwxyz0123456789", _) then
                                    _
                                else
                                    "_"
                        )
                    ),

                    Lista_Partes = List.Select(
                        Text.Split(Texto_ComSeparadores, "_"),
                        each _ <> ""
                    ),

                    Texto_SnakeCase = Text.Combine(
                        Lista_Partes,
                        "_"
                    )
                in
                    Texto_SnakeCase,

            // 🔁 Etapa 4: Monta a lista de renomeação dos cabeçalhos
            Etapa_ListaRenomeacao = List.Transform(
                Etapa_ListaCabecalhos,
                each {_, Etapa_ConverteTexto(_)}
            ),

            // ✅ Etapa 5: Aplica os novos nomes de colunas
            Etapa_RenomeiaCabecalhos = Table.RenameColumns(
                Tabela,
                Etapa_ListaRenomeacao
            )
        in
            Etapa_RenomeiaCabecalhos,

    documentation = [
        Documentation.Name = "fxConverteCabecalhosSnakeCase",
        Documentation.Description = "Converte os cabeçalhos de uma tabela para o padrão snake_case, também chamado de estilo cobrinha.",
        Documentation.LongDescription = "Esta função percorre todos os nomes de colunas de uma tabela Power Query M e os converte para snake_case. O tratamento inclui conversão para minúsculas, remoção de espaços nas extremidades, substituição de acentos comuns, conversão de caracteres especiais, quebras de linha e pontuações em separadores, remoção de separadores excedentes e junção das palavras por underscore. É útil para padronizar bases importadas de Excel, CSV, SAP, sistemas legados e relatórios com cabeçalhos inconsistentes.",
        Documentation.Category = "Funções de Cabeçalhos",
        Documentation.Author = "ChatGPT + Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Padronizar cabeçalhos de uma tabela importada",
                Code = "fxConverteCabecalhosSnakeCase( Etapa_Anterior )",
                Result = "Retorna a tabela com nomes como data_da_venda_contrato, centro_de_lucro e n_doc_referencia."
            ]
        }
    ]
in
    Value.ReplaceType(
        fxConverteCabecalhosSnakeCase,
        Value.ReplaceMetadata(
            Value.Type(fxConverteCabecalhosSnakeCase),
            documentation
        )
    )
