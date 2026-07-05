# FILTER

Funcoes e exemplos de Power Query M para filtrar registros em tabelas.

## Arquivos

### `FiltroRegistrosTextuaisInvalidos.m`

Funcao personalizada para retornar registros invalidos com base em termos encontrados em uma coluna de texto.

### `Table.SelectRows_List.Contains.m`

Exemplo pratico de uso de `Table.SelectRows` com `List.Contains`.

O arquivo cobre dois padroes comuns:

1. manter apenas linhas cujo valor existe em uma lista de referencia;
2. remover linhas cujo valor existe em uma lista de referencia.

## Padrao recomendado

Para manter valores presentes na lista:

```m
Table.SelectRows(
    Fonte,
    each List.Contains(ListaDeReferencia, [Coluna])
)
```

Para remover valores presentes na lista:

```m
Table.SelectRows(
    Fonte,
    each not List.Contains(ListaDeReferencia, [Coluna])
)
```

## Observacoes

- `List.Contains` e sensivel a maiusculas/minusculas quando compara textos.
- Para filtros de texto sem diferenciar maiusculas/minusculas, normalize os dois lados com `Text.Upper` ou `Text.Lower` antes da comparacao.
- Em tabelas grandes, considere transformar listas usadas muitas vezes com `List.Buffer`.
