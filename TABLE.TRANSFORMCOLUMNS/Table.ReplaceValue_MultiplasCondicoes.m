// Exemplos de Table.ReplaceValue com multiplas condicoes
//
// Objetivo:
// Alterar valores de uma coluna no proprio lugar, usando regras baseadas
// em outra coluna ou na propria coluna.
//
// Padrao usado:
// Table.ReplaceValue(
//     tabela,
//     each [ColunaOriginal],
//     each <novo valor calculado por linha>,
//     Replacer.ReplaceValue,
//     {"ColunaOriginal"}
// )
//
// O primeiro `each [ColunaOriginal]` informa que o valor atual da celula
// sera substituido pelo valor calculado no segundo `each`.

let
    // Exemplo 1: substituir CFOP com base na coluna Observacao
    // e, se necessario, tambem no valor atual da propria coluna CFOP.
    ExemploSubstituiCFOP = (TipoAlterado as table) as table =>
        Table.ReplaceValue(
            TipoAlterado,
            each [CFOP],
            each
                if [Observação] = "Ajuste negativo" then "Ajuste Negativo"
                else if [Observação] = "Ajuste Exclusão ICMS da BC" then "Excl ICMS"
                else if [CFOP] = "1101" then "CFOP Diversos"
                else [CFOP],
            Replacer.ReplaceValue,
            {"CFOP"}
        ),

    // Exemplo 2: normalizar a coluna Referencia com regras diretas
    // e regras textuais. A tabela de de/para deixa a manutencao mais simples
    // do que uma cadeia longa de varios ifs para codigos fixos.
    ExemploNormalizaReferencia = (TabelaEntrada as table) as table =>
        let
            MapaReferencias = #table(
                type table [De = text, Para = text],
                {
                    {"19044", "1737"},
                    {"19045", "1738"},
                    {"19022", "1642"},
                    {"19029", "1672"},
                    {"19030", "1673"},
                    {"19031", "1686"},
                    {"19043", "1722"}
                }
            ),

            Resultado =
                Table.ReplaceValue(
                    TabelaEntrada,
                    each [Referência],
                    each
                        let
                            ValorReferencia = [Referência],
                            ValorTexto = if ValorReferencia = null then null else Text.From(ValorReferencia),
                            ValorMapeado =
                                if ValorTexto = null then
                                    null
                                else
                                    try MapaReferencias{[De = ValorTexto]}[Para] otherwise null
                        in
                            if ValorTexto = null then null
                            else if ValorMapeado <> null then ValorMapeado
                            else if Text.Contains(ValorTexto, "000") then Text.End(ValorTexto, 4)
                            else if Text.Contains(ValorTexto, "NC") then Text.Trim(Text.AfterDelimiter(ValorTexto, "NC"))
                            else if Text.Contains(ValorTexto, "INV.") then Text.Trim(Text.AfterDelimiter(ValorTexto, "INV."))
                            else ValorReferencia,
                    Replacer.ReplaceValue,
                    {"Referência"}
                )
        in
            Resultado
in
    [
        ExemploSubstituiCFOP = ExemploSubstituiCFOP,
        ExemploNormalizaReferencia = ExemploNormalizaReferencia
    ]
