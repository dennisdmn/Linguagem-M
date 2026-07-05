// Exemplo: mesclar linhas no Power Query com Table.Group + Text.Combine
//
// Cenario:
// A tabela possui varias linhas por Pedido e queremos consolidar os Produtos
// em uma unica linha por Pedido.

let
    Fonte = #table(
        type table [Pedido = text, Produto = text, Valor = number],
        {
            {"P001", "Mouse", 100},
            {"P001", "Teclado", 150},
            {"P001", "Mouse", 100},
            {"P002", "Monitor", 900},
            {"P002", null, 0},
            {"P003", "Notebook", 3500}
        }
    ),

    MesclaLinhas =
        Table.Group(
            Fonte,
            {"Pedido"},
            {
                {
                    "Produtos",
                    each Text.Combine(
                        List.Distinct(
                            List.Select([Produto], each _ <> null and Text.Trim(_) <> "")
                        ),
                        " | "
                    ),
                    type text
                },
                {
                    "ValorTotal",
                    each List.Sum([Valor]),
                    type number
                }
            }
        )
in
    MesclaLinhas
