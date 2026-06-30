# Descrição estendida — fxTrataBaseContabilSAPFPT8

## Contexto

A `fxTrataBaseContabilSAPFPT8` é uma função específica para tratamento de bases contábeis extraídas da rotina FPT8, considerando o layout personalizado `/CONTROLTEC2` no SAP HANA da Cogna.

O foco da função é transformar uma tabela já importada para o Power Query M em uma base mais estável para análises contábeis, validações, conciliações e cruzamentos posteriores.

## Escopo

A função cobre exclusivamente o tratamento inicial da tabela de entrada.

Ela não executa:

- importação de arquivos;
- leitura de pasta;
- conexão direta com SAP;
- consolidação de múltiplos arquivos;
- padronização final dos nomes das colunas em `snake_case`.

A padronização dos cabeçalhos pode ser aplicada posteriormente com `fxConverteCabecalhosSnakeCase`.

## Layout de origem

A função foi documentada para funcionar com o layout personalizado:

```text
/CONTROLTEC2
```

no SAP HANA da Cogna.

## Regras aplicadas

### 1. Filtro de empresa

São mantidas apenas linhas em que a coluna `Empresa` é diferente de texto vazio.

```powerquery
Table.SelectRows(
    Fonte,
    each [Empresa] <> ""
)
```

### 2. Tipagem

A função aplica tipos aos campos esperados do layout `/CONTROLTEC2`.

| Campo original | Tipo aplicado |
|---|---|
| `Empresa` | `Int64.Type` |
| `Conta de contrato` | `type text` |
| `Conta do Razão` | `Int64.Type` |
| `Data de lançamento` | `type date` |
| `Montante` | `type number` |
| `Ctg.de um item` | `type text` |
| `Chave reconciliação` | `type text` |
| `Status` | `type text` |
| `Segmento` | `type text` |
| `Loc.negócios` | `type text` |
| `Centro de lucro` | `type text` |
| `Nº doc.` | `type text` |
| `Nº doc.referência` | `type text` |
| `Divisão` | `type text` |
| `Operação principal` | `type text` |
| `Agrupamento itens` | `type text` |

### 3. Substituição de textos vazios por nulo

Após a tipagem, a função substitui `""` por `null` nas colunas textuais relevantes.

Essa etapa evita que campos aparentemente vazios sejam tratados como texto em filtros, junções e validações posteriores.

## Decisão técnica importante

A função foi mantida separada da etapa de padronização de cabeçalhos em estilo cobrinha para preservar a leitura do layout original do SAP durante a tipagem.

Fluxo recomendado:

```text
Fonte importada
→ fxTrataBaseContabilSAPFPT8
→ fxConverteCabecalhosSnakeCase
→ demais transformações analíticas
```

## Exemplo recomendado

```powerquery
let
    Etapa_Fonte = fxImportarPastaExcel(
        "C:\Caminho\Da\Pasta",
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null
    ),

    Etapa_TrataBase = fxTrataBaseContabilSAPFPT8(
        Etapa_Fonte
    ),

    Etapa_PadronizaCabecalhos = fxConverteCabecalhosSnakeCase(
        Etapa_TrataBase
    )
in
    Etapa_PadronizaCabecalhos
```

## Saída esperada

A saída da `fxTrataBaseContabilSAPFPT8` mantém os nomes originais do layout SAP, mas já retorna a base:

- filtrada por empresa preenchida;
- com tipos aplicados;
- com textos vazios convertidos em `null` nas colunas textuais.

## Status

Função registrada como referência para casos específicos da Cogna relacionados à rotina FPT8 no layout personalizado `/CONTROLTEC2` do SAP HANA.
