let
    fxTrataFPG5 =
        (
            Fonte as table,
            optional Cultura as nullable text
        ) as table =>
        let
            CulturaFinal =
                if Cultura = null then
                    "pt-BR"
                else
                    Cultura,

            Etapa_PromoveCabecalhos =
                Table.PromoteHeaders(
                    Fonte,
                    [PromoteAllScalars = true]
                ),

            Etapa_FiltraLinhas =
                Table.SelectRows(
                    Etapa_PromoveCabecalhos,
                    each
                        [#"Cont.regs."] <> null
                        and Text.Trim(Text.From([#"Cont.regs."])) <> ""
                        and [#"ChvReconc."] <> "ChvReconc."
                ),

            Etapa_SelecionaColunas =
                Table.SelectColumns(
                    Etapa_FiltraLinhas,
                    {
                        "ChvReconc.",
                        "Cont.regs.",
                        "Nº documento",
                        "Itm",
                        "Empr.",
                        "Divisão",
                        "Cta.Razão",
                        "Data doc.",
                        "Montante",
                        "Base do imposto",
                        "Moeda",
                        "CódImposto",
                        "Segmento",
                        "Cen.lucro"
                    }
                ),

            Etapa_DefineTipos =
                Table.TransformColumnTypes(
                    Etapa_SelecionaColunas,
                    {
                        {"ChvReconc.", type text},
                        {"Nº documento", type text},
                        {"Divisão", type text},
                        {"Moeda", type text},
                        {"CódImposto", type text},
                        {"Segmento", type text},
                        {"Cen.lucro", type text},
                        {"Cont.regs.", Int64.Type},
                        {"Itm", Int64.Type},
                        {"Empr.", Int64.Type},
                        {"Cta.Razão", Int64.Type},
                        {"Data doc.", type date},
                        {"Montante", type number},
                        {"Base do imposto", type number}
                    },
                    CulturaFinal
                ),

            Etapa_RenomeiaCabecalhosCobrinha =
                Table.RenameColumns(
                    Etapa_DefineTipos,
                    {
                        {"ChvReconc.", "chv_reconc"},
                        {"Cont.regs.", "cont_regs"},
                        {"Nº documento", "n_documento"},
                        {"Itm", "itm"},
                        {"Empr.", "empr"},
                        {"Divisão", "divisao"},
                        {"Cta.Razão", "cta_razao"},
                        {"Data doc.", "data_doc"},
                        {"Montante", "montante"},
                        {"Base do imposto", "base_do_imposto"},
                        {"Moeda", "moeda"},
                        {"CódImposto", "cod_imposto"},
                        {"Segmento", "segmento"},
                        {"Cen.lucro", "cen_lucro"}
                    }
                )
        in
            Etapa_RenomeiaCabecalhosCobrinha
in
    fxTrataFPG5
