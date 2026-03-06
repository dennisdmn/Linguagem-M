// ============================================================
// Função: fxTransformaColunaCondicionalmente
// Descrição: Altera o valor de uma coluna quando a coluna de
//            condição contiver o texto definido (case-insensitive).
// Autor: dennisdmn
// ============================================================
(
    tabela as table,
    nomeColunaAlterar as text,
    nomeColunaCondicao as text,
    textoProcurado as text,
    novoValor as any
) as table =>
    Table.ReplaceValue(
        tabela,
        each Record.Field(_, nomeColunaAlterar),
        each
            if Record.Field(_, nomeColunaCondicao) <> null
                and Text.Contains(
                    Text.From( Record.Field(_, nomeColunaCondicao) ),
                    textoProcurado,
                    Comparer.OrdinalIgnoreCase
                )
            then
                novoValor
            else
                Record.Field(_, nomeColunaAlterar),
        Replacer.ReplaceValue,
        { nomeColunaAlterar }
    )
