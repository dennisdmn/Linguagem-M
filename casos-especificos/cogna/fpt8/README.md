# fxTrataBaseContabilSAPFPT8

Função Power Query M para tratar a base contábil SAP FPT8 no layout personalizado `/CONTROLTEC2` do SAP HANA da Cogna.

## Objetivo

Padronizar o tratamento inicial da extração contábil, partindo de uma tabela já importada para o Power Query.

A função executa as seguintes etapas:

1. mantém apenas linhas com `Empresa` preenchida;
2. aplica tipos de dados nas colunas esperadas do layout `/CONTROLTEC2`;
3. substitui textos vazios por `null` nas colunas textuais relevantes.

## Assinatura

```powerquery
fxTrataBaseContabilSAPFPT8(
    Fonte as table
) as table
```

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---:|---:|---|
| `Fonte` | `table` | Sim | Tabela de entrada já importada ou consolidada antes da aplicação da função. |

## Exemplo de uso isolado

```powerquery
= fxTrataBaseContabilSAPFPT8(Fonte)
```

## Exemplo de uso em uma consulta principal

```powerquery
let
    // 📁 Etapa 1: Importa os arquivos Excel da pasta informada
    Etapa_Fonte = fxImportarPastaExcel(
        "C:\Users\a484377\OneDrive - EDITORA E DISTRIBUIDORA EDUCACIONAL S A\Documentos\lixo\Base_Extr_1000_6103020001",
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null
    ),

    // 🧼 Etapa 2: Trata a base contábil SAP FPT8 no layout /CONTROLTEC2
    Etapa_TrataBase = fxTrataBaseContabilSAPFPT8(
        Etapa_Fonte
    ),

    // 🏷️ Etapa 3: Padroniza os cabeçalhos para o estilo snake_case
    Etapa_PadronizaCabecalhos = fxConverteCabecalhosSnakeCase(
        Etapa_TrataBase
    )
in
    Etapa_PadronizaCabecalhos
```

## Colunas de entrada esperadas

A função espera as seguintes colunas no layout original `/CONTROLTEC2`:

- `Empresa`
- `Conta de contrato`
- `Conta do Razão`
- `Data de lançamento`
- `Montante`
- `Ctg.de um item`
- `Chave reconciliação`
- `Status`
- `Segmento`
- `Loc.negócios`
- `Centro de lucro`
- `Nº doc.`
- `Nº doc.referência`
- `Divisão`
- `Operação principal`
- `Agrupamento itens`

## Observação

Esta função não importa arquivos, pastas ou conexões SAP diretamente. A origem deve ser carregada antes e passada como tabela no parâmetro `Fonte`.

Para padronizar os nomes das colunas depois do tratamento, use a função utilitária:

```powerquery
fxConverteCabecalhosSnakeCase(Etapa_TrataBase)
```
