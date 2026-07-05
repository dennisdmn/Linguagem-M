// fxAgrupaConcatenaTexto
//
// Agrupa uma tabela por uma ou mais colunas-chave e concatena os valores
// textuais de outra coluna usando um delimitador.
//
// Uso tipico:
// - mesclar varias linhas de observacoes em uma linha por cliente, pedido ou nota;
// - transformar itens detalhados em uma lista textual por grupo;
// - criar uma coluna consolidada apos agrupamento.

let
    fxAgrupaConcatenaTexto = (
        tabela as table,
        colunasGrupo as list,
        colunaTexto as text,
        optional nomeColunaResultado as nullable text,
        optional delimitador as nullable text,
        optional removerDuplicados as nullable logical,
        optional ignorarNulosEVazios as nullable logical
    ) as table =>
    let
        NomeResultado = if nomeColunaResultado = null then colunaTexto & "_Concatenado" else nomeColunaResultado,
        Delim = if delimitador = null then ", " else delimitador,
        RemoverDuplicados = if removerDuplicados = null then true else removerDuplicados,
        IgnorarNulosEVazios = if ignorarNulosEVazios = null then true else ignorarNulosEVazios,

        Agrupado =
            Table.Group(
                tabela,
                colunasGrupo,
                {
                    {
                        NomeResultado,
                        (grupo as table) as text =>
                            let
                                ValoresOriginais = Table.Column(grupo, colunaTexto),
                                ValoresTexto = List.Transform(
                                    ValoresOriginais,
                                    each if _ = null then null else Text.From(_)
                                ),
                                ValoresFiltrados =
                                    if IgnorarNulosEVazios then
                                        List.Select(ValoresTexto, each _ <> null and Text.Trim(_) <> "")
                                    else
                                        ValoresTexto,
                                ValoresFinais =
                                    if RemoverDuplicados then
                                        List.Distinct(ValoresFiltrados)
                                    else
                                        ValoresFiltrados,
                                Resultado = Text.Combine(ValoresFinais, Delim)
                            in
                                Resultado,
                        type text
                    }
                }
            )
    in
        Agrupado,

    documentation = [
        Documentation.Name = "fxAgrupaConcatenaTexto",
        Documentation.Description = "Agrupa uma tabela e concatena valores textuais de uma coluna por grupo.",
        Documentation.LongDescription = "Funcao util para mesclar linhas no Power Query/Power BI usando Table.Group e Text.Combine. Permite definir colunas de agrupamento, coluna a concatenar, nome da coluna final, delimitador, remocao de duplicados e tratamento de nulos/vazios.",
        Documentation.Category = "Transformacao de Tabelas",
        Documentation.Source = "Repositorio Linguagem-M",
        Documentation.Author = "Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Concatenar produtos por pedido",
                Code = "fxAgrupaConcatenaTexto(Fonte, {\"Pedido\"}, \"Produto\", \"Produtos\", \" | \", true, true)",
                Result = "Uma linha por pedido com produtos concatenados."
            ]
        }
    ]
in
    Value.ReplaceType(
        fxAgrupaConcatenaTexto,
        Value.ReplaceMetadata(Value.Type(fxAgrupaConcatenaTexto), documentation)
    )
