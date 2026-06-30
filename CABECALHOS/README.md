# Funções de cabeçalhos

Pasta destinada a funções Power Query M para localizar, promover, tratar e padronizar nomes de colunas.

## Funções disponíveis

| Função | Objetivo |
|---|---|
| `fxCapturaNomeCabecalhoPorTexto` | Retorna o nome real de uma coluna com base em parte do texto procurado. |
| `fxPromoveCabecalhoPorValor` | Promove cabeçalhos a partir de uma referência de valor/linha. |
| `fxConverteCabecalhosSnakeCase` | Converte todos os cabeçalhos de uma tabela para `snake_case`, também chamado de estilo cobrinha. |

## fxConverteCabecalhosSnakeCase

### Objetivo

Padronizar nomes de colunas para facilitar manutenção, cruzamentos, transformação de dados e escrita de etapas posteriores no Power Query M.

A função trata casos comuns em bases exportadas de Excel, CSV, SAP e relatórios operacionais, como:

- acentos;
- espaços excedentes;
- quebras de linha;
- pontuação;
- símbolos especiais;
- mistura de maiúsculas e minúsculas.

## Assinatura

```powerquery
fxConverteCabecalhosSnakeCase(
    Tabela as table
) as table
```

## Exemplo de uso

```powerquery
let
    Etapa_Fonte = Excel.CurrentWorkbook(){[Name = "Tabela1"]}[Content],

    Etapa_PadronizaCabecalhos = fxConverteCabecalhosSnakeCase(
        Etapa_Fonte
    )
in
    Etapa_PadronizaCabecalhos
```

## Exemplo de transformação

| Cabeçalho original | Cabeçalho final |
|---|---|
| `Data da Venda#(lf)Contrato` | `data_da_venda_contrato` |
| `Centro de lucro` | `centro_de_lucro` |
| `Nº doc.referência` | `n_doc_referencia` |
| `Loc.negócios` | `loc_negocios` |

## Observação

A função altera apenas os nomes das colunas. Ela não modifica os valores das linhas nem aplica tipos de dados.
