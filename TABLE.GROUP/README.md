# TABLE.GROUP

Exemplos e funcoes de Power Query M para agrupamento de linhas com `Table.Group`.

## Mesclar linhas no Power BI

Este conteudo preserva, em formato de codigo/documentacao, o aprendizado do video `mesclar_linhas_no_Power_BI.mp4` que estava no Google Drive.

O video em si nao foi migrado para o GitHub porque e um arquivo de midia pesado. O que vale preservar no repositorio e a receita em M.

## Arquivos

### `fxAgrupaConcatenaTexto.m`

Funcao reutilizavel para agrupar uma tabela e concatenar os valores textuais de uma coluna.

Assinatura:

```m
fxAgrupaConcatenaTexto(
    tabela as table,
    colunasGrupo as list,
    colunaTexto as text,
    optional nomeColunaResultado as nullable text,
    optional delimitador as nullable text,
    optional removerDuplicados as nullable logical,
    optional ignorarNulosEVazios as nullable logical
) as table
```

Exemplo:

```m
fxAgrupaConcatenaTexto(
    Fonte,
    {"Pedido"},
    "Produto",
    "Produtos",
    " | ",
    true,
    true
)
```

### `Mesclar_Linhas_Texto.m`

Exemplo autocontido com tabela de teste usando `Table.Group`, `Text.Combine`, `List.Distinct` e `List.Sum`.

## Padrao base

```m
Table.Group(
    Fonte,
    {"Pedido"},
    {
        {
            "Produtos",
            each Text.Combine(List.Distinct([Produto]), " | "),
            type text
        }
    }
)
```

## Cuidados importantes

- Use `List.Select` para remover `null` e textos vazios antes de `Text.Combine`.
- Use `List.Distinct` quando nao quiser repetir valores dentro do mesmo grupo.
- Se a ordem dos textos importa, ordene a tabela antes do `Table.Group`.
- Se tambem precisar somar valores, adicione agregacoes como `List.Sum([Valor])` no mesmo `Table.Group`.
- Para concatenar valores numericos, converta para texto com `Text.From`.

## Exemplo antes

| Pedido | Produto  | Valor |
|---|---|---:|
| P001 | Mouse    | 100 |
| P001 | Teclado  | 150 |
| P001 | Mouse    | 100 |
| P002 | Monitor  | 900 |

## Exemplo depois

| Pedido | Produtos        | ValorTotal |
|---|---|---:|
| P001 | Mouse \| Teclado | 350 |
| P002 | Monitor         | 900 |
