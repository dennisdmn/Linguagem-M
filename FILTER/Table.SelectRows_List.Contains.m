// Exemplos de filtros com Table.SelectRows + List.Contains
//
// Cenarios cobertos:
// 1. Manter linhas cujo valor existe em uma lista de referencia.
// 2. Remover linhas cujo valor existe em uma lista de referencia.
//
// Observacao:
// List.Contains(lista, valor) retorna true quando o valor esta na lista.
// Para negar a condicao, prefira `not List.Contains(...)` em vez de comparar com `= false`.

let
    // Exemplo 1: filtra CFOPs que estao na lista de vendas.
    FiltroCFOP_Vendas =
        Table.SelectRows(
            Fonte,
            each List.Contains(
                CFOP_Vendas[CFOP_Vendas],
                [ContabilFiscal]
            )
        ),

    // Exemplo 2: remove notas fiscais que estao na lista de venda de sucata.
    Filtro_NF_Nao_Sucata =
        Table.SelectRows(
            FiltroCFOP_Vendas,
            each not List.Contains(
                Lista_NF_Venda_Sucata,
                [Numero]
            )
        )
in
    Filtro_NF_Nao_Sucata
