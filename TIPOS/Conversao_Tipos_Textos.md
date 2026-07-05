# Conversao de Tipos e Funcoes de Texto

Guia migrado da planilha `Data Type Conversion Functions`, com correcoes de sintaxe para Power Query M.

## Conversao para texto

| Converter | Funcao | Exemplo |
|---|---|---|
| Qualquer valor | `Text.From` | `Text.From([Column1])` |
| Data | `Date.ToText` | `Date.ToText([Column1])` |
| Hora | `Time.ToText` | `Time.ToText([Column1])` |
| Numero | `Number.ToText` | `Number.ToText([Column1])` |

## Datas

| Converter | Funcao | Exemplo |
|---|---|---|
| Numero serial para data | `Date.From` | `Date.From([Column1])` |
| Texto para data | `Date.FromText` | `Date.FromText([Column1])` |
| Texto literal para data | `Date.FromText` | `Date.FromText("Jan 31, 2015")` |

## Horas

| Converter | Funcao | Exemplo |
|---|---|---|
| Numero para hora | `Time.From` | `Time.From([Column1])` |
| Numero literal para hora | `Time.From` | `Time.From(0.586)` |
| Texto para hora | `Time.FromText` | `Time.FromText([Column1])` |
| Texto literal para hora | `Time.FromText` | `Time.FromText("2:03 PM")` |

> Correcao aplicada: a planilha original trazia exemplos de hora com `Date.FromText`; o correto e `Time.FromText`.

## Duracoes

| Converter | Funcao | Exemplo |
|---|---|---|
| Numero para duracao | `Duration.From` | `Duration.From([Column1])` |
| Numero literal para duracao | `Duration.From` | `Duration.From(2.525)` |
| Texto para duracao | `Duration.FromText` | `Duration.FromText([Column1])` |
| Texto literal para duracao | `Duration.FromText` | `Duration.FromText("15:35")` |

## Numeros e valores

| Converter | Funcao | Exemplo |
|---|---|---|
| Valor para numero decimal | `Number.From` | `Number.From([Column1])` |
| Texto para numero decimal | `Number.FromText` | `Number.FromText([Column1])` |
| Texto literal para numero decimal | `Number.FromText` | `Number.FromText("15.35")` |
| Valor para decimal | `Decimal.From` | `Decimal.From([Column1])` |
| Valor para inteiro 64 bits | `Int64.From` | `Int64.From([Column1])` |
| Valor para moeda | `Currency.From` | `Currency.From([Column1])` |

> Correcao aplicada: a planilha original misturava `Decimal.Number([Column1])`; em M, use `Number.From`, `Number.FromText` ou `Decimal.From` conforme o caso.

## Equivalencias de funcoes de texto Excel x Power Query

| Excel | Power Query M | Exemplo M | Resultado |
|---|---|---|---|
| `LEFT(text, num_chars)` | `Text.Start(text, count)` | `Text.Start("Excel", 2)` | `Ex` |
| `RIGHT(text, num_chars)` | `Text.End(text, count)` | `Text.End("Excel", 2)` | `el` |
| `LEN(text)` | `Text.Length(text)` | `Text.Length("Excel")` | `5` |
| `FIND(find_text, within_text)` | `Text.PositionOf(text, substring)` | `Text.PositionOf("Excel", "xc")` | `1` |
| `MID(text, start, num_chars)` | `Text.Range(text, offset, count)` | `Text.Range("Excel", 2, 2)` | `ce` |

> Correcao aplicada: a planilha original trazia `Start.Text`; o correto e `Text.Start`.

## Condicional e tratamento de erro

| Objetivo | Power Query M | Exemplo |
|---|---|---|
| Tratar erro | `try ... otherwise ...` | `try Time.From([Out]) otherwise null` |
| Condicional | `if ... then ... else ...` | `if [Custom] = null then [Out] else null` |

## Listas

```m
{1, 2, 3, 4, 5}
{"A", "B", "C"}
{1, 465, "M", "Data Monkey", {999, 234}}
{1..365}
{"A".."J"}
{{1, "Fred"}, {2, "John"}, {3, "Jane"}, {4, "Mary"}}
```

## Registros

```m
[Name = "Ken Puls", Country = "Canada", LanguagesSpoken = 2]
```

Lista de registros:

```m
{
    [Name = "Ken Puls", Country = "Canada", LanguagesSpoken = 2],
    [Name = "Miguel Escobar", Country = "Panama", LanguagesSpoken = 2]
}
```

## Acessar linhas e campos

```m
Fonte{0}
Fonte{0}[Price]
```

Com coluna de indice:

```m
AddedIndex{[Index]}
```

## Inspecao de funcoes compartilhadas

```m
#shared
```

## Caracteres especiais em M

| Caracter | Uso |
|---|---|
| `( )` | parametros de funcao e precedencia |
| `{ }` | listas e acesso por posicao |
| `[ ]` | registros e acesso a campos |
| `"texto"` | valores textuais |
| `#"Nome da Etapa"` | identificador com espacos ou caracteres especiais |
| `// comentario` | comentario de uma linha |
| `/* comentario */` | comentario de multiplas linhas |
