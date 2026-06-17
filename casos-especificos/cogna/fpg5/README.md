# fxTrataFPG5

Função Power Query M para tratar arquivos extraídos da rotina FPG5 em contexto Cogna.

## Objetivo

Padronizar o tratamento inicial da base FPG5, partindo de uma tabela bruta já carregada no Power Query.

A função executa as seguintes etapas:

1. promove a primeira linha como cabeçalho;
2. remove linhas inválidas ou cabeçalhos repetidos no corpo da base;
3. mantém apenas as colunas relevantes para análise;
4. aplica tipos de dados com cultura parametrizável;
5. renomeia os campos para padrão `snake_case`, também chamado de cabeçalho em cobrinha.

## Assinatura

```powerquery
fxTrataFPG5(
    Fonte as table,
    optional Cultura as nullable text
) as table
```

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---:|---:|---|
| `Fonte` | `table` | Sim | Tabela bruta de entrada, antes da promoção dos cabeçalhos. |
| `Cultura` | `nullable text` | Não | Cultura usada na conversão de tipos. Se omitida, assume `pt-BR`. |

## Exemplo de uso

```powerquery
= fxTrataFPG5(Fonte)
```

Com cultura explícita:

```powerquery
= fxTrataFPG5(Fonte, "pt-BR")
```

## Colunas de entrada esperadas

A função espera que, após a promoção de cabeçalhos, existam as seguintes colunas no layout original da FPG5:

- `ChvReconc.`
- `Cont.regs.`
- `Nº documento`
- `Itm`
- `Empr.`
- `Divisão`
- `Cta.Razão`
- `Data doc.`
- `Montante`
- `Base do imposto`
- `Moeda`
- `CódImposto`
- `Segmento`
- `Cen.lucro`

## Colunas finais

O resultado final retorna as colunas abaixo, já renomeadas para `snake_case`:

- `chv_reconc`
- `cont_regs`
- `n_documento`
- `itm`
- `empr`
- `divisao`
- `cta_razao`
- `data_doc`
- `montante`
- `base_do_imposto`
- `moeda`
- `cod_imposto`
- `segmento`
- `cen_lucro`

## Observação

Esta função foi validada isoladamente para tratamento do layout FPG5. Ela não importa arquivos nem pastas diretamente; a origem deve ser carregada antes e passada como tabela no parâmetro `Fonte`.
