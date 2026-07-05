# Table.ReplaceValue com multiplas condicoes

Arquivo de exemplo: [`Table.ReplaceValue_MultiplasCondicoes.m`](./Table.ReplaceValue_MultiplasCondicoes.m)

Este exemplo mostra como substituir valores em uma coluna sem criar coluna auxiliar, usando `Table.ReplaceValue` com regras condicionais.

## Quando usar

Use este padrao quando voce quer alterar uma coluna no proprio lugar com base em:

- valores de outra coluna da mesma linha;
- valores da propria coluna que esta sendo alterada;
- regras de de/para;
- regras textuais, como `Text.Contains`, `Text.End` e `Text.AfterDelimiter`.

## Padrao base

```m
Table.ReplaceValue(
    tabela,
    each [ColunaOriginal],
    each <novo valor calculado por linha>,
    Replacer.ReplaceValue,
    {"ColunaOriginal"}
)
```

O primeiro `each [ColunaOriginal]` representa o valor atual da celula. O segundo `each` calcula o novo valor para aquela linha.

## Correcoes feitas nos snippets originais

1. Os trechos foram colocados dentro de uma estrutura `let ... in`, em vez de iniciarem com `=` solto.
2. O exemplo de `Referência` usa uma tabela de de/para para codigos fixos, facilitando manutencao.
3. A regra de `Referência` trata valores `null` antes de chamar funcoes de texto.
4. Os exemplos foram transformados em funcoes nomeadas para facilitar reaproveitamento.
5. A logica preserva o valor original quando nenhuma condicao e atendida.

## Funcoes retornadas pelo arquivo

Ao carregar o arquivo no Power Query, a consulta retorna um registro com duas funcoes:

- `ExemploSubstituiCFOP`
- `ExemploNormalizaReferencia`

Para usar uma delas em outra consulta, referencie o campo do registro ou copie a funcao desejada para uma consulta propria.

## Observacoes

- `Text.Contains` e sensivel a maiusculas/minusculas por padrao.
- Se a coluna puder conter numeros e textos, use `Text.From` antes de aplicar funcoes textuais.
- Para muitas regras fixas, uma tabela de de/para costuma ser mais legivel que uma cadeia longa de `if ... else if`.
