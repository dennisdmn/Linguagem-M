# Descrição estendida — funções de cabeçalhos

## Contexto

Esta pasta reúne funções Power Query M voltadas ao tratamento de cabeçalhos de tabelas. O objetivo é centralizar rotinas reutilizáveis para padronizar nomes de colunas e reduzir retrabalho em processos de ETL.

## Função em destaque: fxConverteCabecalhosSnakeCase

A `fxConverteCabecalhosSnakeCase` foi criada para converter todos os nomes de colunas de uma tabela para o padrão `snake_case`, também chamado no projeto de estilo cobrinha.

Esse padrão é útil porque evita nomes com espaços, acentos, quebras de linha e pontuação, tornando as consultas mais estáveis para etapas como:

- `Table.SelectColumns`;
- `Table.TransformColumnTypes`;
- `Table.RenameColumns`;
- junções entre tabelas;
- referências diretas a campos em expressões M.

## Regras aplicadas

A função executa o seguinte fluxo sobre cada cabeçalho:

```text
Texto original
→ Text.Trim
→ Text.Lower
→ remoção de acentos comuns
→ troca de caracteres não alfanuméricos por underscore
→ remoção de underscores excedentes
→ junção final em snake_case
```

## Exemplo

```text
"Data da Venda#(lf)Contrato"
→ "data_da_venda_contrato"
```

```text
"Nº doc.referência"
→ "n_doc_referencia"
```

## Escopo

A função atua somente nos nomes das colunas. Ela não promove cabeçalhos, não altera dados das linhas, não remove colunas e não aplica tipos.

## Status

Função registrada como utilitário geral de cabeçalhos para uso em consultas do Excel, Power BI Desktop e Dataflows quando o objetivo for padronizar colunas em estilo cobrinha.
