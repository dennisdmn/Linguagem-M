# Condicional com List.AnyTrue e Text.Contains

Arquivo de exemplo: [`Condicional_ListAnyTrue_TextContains.m`](./Condicional_ListAnyTrue_TextContains.m)

Este exemplo migra o Google Doc `= Table.AddColumn -> List.AnyTrue + If` para um formato executavel e mais facil de reaproveitar.

## Quando usar

Use esse padrao quando uma coluna textual precisa ser classificada de acordo com varias palavras-chave.

Exemplo: se `[AssignedTo]` contem `John`, `Jane` ou `Sean`, classificar como `Group 1`; se contem `Mary` ou `Pete`, classificar como `Group 2`; caso contrario, `Group 3`.

## Padrao principal

```m
List.AnyTrue(
    List.Transform(
        lista,
        (item) => Text.Contains(texto, item, Comparer.OrdinalIgnoreCase)
    )
)
```

## Correcoes feitas na migracao

1. O trecho foi colocado em uma consulta completa `let ... in`.
2. A coluna original `Assigned to` foi adaptada para `AssignedTo` no exemplo autocontido.
3. Valores `null` sao tratados antes de `Text.Contains`.
4. A busca usa `Comparer.OrdinalIgnoreCase` para ignorar maiusculas/minusculas.
5. As listas de nomes foram agrupadas em um registro `Grupos`, facilitando manutencao.
