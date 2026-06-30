let
    fxTrataBaseContabilSAPFPT8 =
        (Fonte as table) as table =>
        let
            // 📌 Etapa 1: Mantém apenas linhas com empresa preenchida
            Etapa_FiltraEmpresa = Table.SelectRows(
                Fonte,
                each [Empresa] <> ""
            ),

            // 🧮 Etapa 2: Define os tipos de dados das colunas do layout /CONTROLTEC2
            Etapa_DefineTipos = Table.TransformColumnTypes(
                Etapa_FiltraEmpresa,
                {
                      { "Empresa",             Int64.Type  }
                    , { "Conta de contrato",   type text   }
                    , { "Conta do Razão",      Int64.Type  }
                    , { "Data de lançamento",  type date   }
                    , { "Montante",            type number }
                    , { "Ctg.de um item",      type text   }
                    , { "Chave reconciliação", type text   }
                    , { "Status",              type text   }
                    , { "Segmento",            type text   }
                    , { "Loc.negócios",        type text   }
                    , { "Centro de lucro",     type text   }
                    , { "Nº doc.",             type text   }
                    , { "Nº doc.referência",   type text   }
                    , { "Divisão",             type text   }
                    , { "Operação principal",  type text   }
                    , { "Agrupamento itens",   type text   }
                }
            ),

            // 🧼 Etapa 3: Substitui textos vazios por nulo em colunas textuais
            Etapa_SubstituiVazios = Table.ReplaceValue(
                Etapa_DefineTipos,
                "",
                null,
                Replacer.ReplaceValue,
                {
                      "Conta de contrato"
                    , "Status"
                    , "Segmento"
                    , "Loc.negócios"
                    , "Centro de lucro"
                    , "Nº doc."
                    , "Nº doc.referência"
                    , "Divisão"
                    , "Operação principal"
                    , "Agrupamento itens"
                }
            )
        in
            Etapa_SubstituiVazios,

    documentation = [
        Documentation.Name = "fxTrataBaseContabilSAPFPT8",
        Documentation.Description = "Trata a base contábil SAP FPT8 no layout personalizado /CONTROLTEC2 do SAP HANA da Cogna.",
        Documentation.LongDescription = "Esta função trata uma tabela já importada para o Power Query M a partir da base contábil SAP FPT8, considerando o layout personalizado /CONTROLTEC2 no SAP HANA da Cogna. O tratamento mantém apenas linhas com empresa preenchida, aplica os tipos esperados para campos de empresa, conta de contrato, conta do razão, data de lançamento, montante e demais atributos contábeis, além de substituir textos vazios por nulo nas colunas textuais relevantes. A função não importa arquivos nem pastas; ela deve ser aplicada depois da etapa de importação/consolidação da origem.",
        Documentation.Category = "Casos Específicos - Cogna - SAP FPT8",
        Documentation.Author = "ChatGPT + Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Tratar base contábil SAP FPT8 importada de uma pasta",
                Code = "fxTrataBaseContabilSAPFPT8( Etapa_Fonte )",
                Result = "Retorna a base filtrada, tipada e com textos vazios substituídos por nulo."
            ]
        }
    ]
in
    Value.ReplaceType(
        fxTrataBaseContabilSAPFPT8,
        Value.ReplaceMetadata(
            Value.Type(fxTrataBaseContabilSAPFPT8),
            documentation
        )
    )
