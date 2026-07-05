# LOOKUP

Funcoes Power Query M para cenarios de busca de valores em tabelas.

## pqVLOOKUP

Arquivo: [`pqVLOOKUP.m`](./pqVLOOKUP.m)

A funcao `pqVLOOKUP` simula a PROCV/VLOOKUP do Excel em Power Query M. Ela usa a primeira coluna da tabela informada como coluna de busca e retorna o valor da coluna indicada por posicao.

## Assinatura

```m
pqVLOOKUP(
    lookup_value as any,
    table_array as table,
    col_index_number as number,
    optional approximate_match as nullable logical
) as any
```

## Parametros

| Parametro | Tipo | Obrigatorio | Descricao |
|---|---|---:|---|
| `lookup_value` | `any` | Sim | Valor que sera procurado na primeira coluna de `table_array`. |
| `table_array` | `table` | Sim | Tabela de busca. A primeira coluna e usada como chave de busca. |
| `col_index_number` | `number` | Sim | Numero da coluna a retornar, iniciando em `1`, como no Excel. |
| `approximate_match` | `logical` | Nao | Quando omitido ou `true`, retorna a maior chave menor ou igual ao valor procurado. Quando `false`, exige correspondencia exata. |

## Exemplo de uso

```m
let
    TabelaBusca = #table(
        type table [Codigo = number, Descricao = text, Grupo = text],
        {
            {1, "Produto A", "Grupo 1"},
            {2, "Produto B", "Grupo 1"},
            {3, "Produto C", "Grupo 2"}
        }
    ),
    Resultado = pqVLOOKUP(2, TabelaBusca, 2, false)
in
    Resultado
```

Resultado esperado: `Produto B`.

## Correspondencia aproximada

Quando `approximate_match` e omitido ou definido como `true`, a funcao ordena a primeira coluna em ordem decrescente e retorna a primeira linha cuja chave seja menor ou igual ao valor buscado.

```m
pqVLOOKUP(2.5, TabelaBusca, 2, true)
```

Nesse caso, a funcao retorna o item da chave `2`.

## Correcoes feitas em relacao ao snippet original

1. A busca exata agora usa igualdade direta com `Value.Equals`, sem passar antes pelo filtro de menor ou igual.
2. O indice da coluna de retorno e validado antes da leitura.
3. O parametro opcional `approximate_match` continua assumindo `true` quando omitido, preservando o comportamento inspirado no Excel.
4. A tabela e armazenada com `Table.Buffer` para evitar recomputacoes em usos simples.
5. Comparacoes invalidas na busca aproximada sao ignoradas com `try ... otherwise false`.

## Cuidados

- Para correspondencia exata em tabelas grandes, prefira mesclar consultas no Power Query.
- A correspondencia aproximada pressupoe que os valores da primeira coluna possam ser comparados com `<=`.
- A funcao retorna `"#N/A"` quando nenhum valor e encontrado, mantendo comportamento parecido com o Excel.
- `col_index_number` usa a numeracao do Excel: `1` e a primeira coluna, `2` e a segunda, e assim por diante.
