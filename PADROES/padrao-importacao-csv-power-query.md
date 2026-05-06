# Padrão — Importação de CSV no Power Query (M)

## Objetivo

Documentar um padrão reutilizável para importar arquivos `.csv` no Power Query utilizando uma função personalizada em linguagem M.

Este padrão é indicado para rotinas em que arquivos CSV são recebidos periodicamente em uma pasta, como bases exportadas de sistemas, relatórios operacionais, extrações SAP, arquivos de conciliação ou bases auxiliares de controladoria.

---

## Quando usar

Use este padrão quando houver necessidade de:

- importar um único arquivo CSV;
- importar vários arquivos CSV de uma pasta;
- reaproveitar a mesma lógica de leitura em diferentes consultas;
- padronizar delimitador, codificação e promoção de cabeçalhos;
- reduzir repetição de código dentro do Power Query.

---

## Função padrão

Arquivo recomendado no repositório:

```text
TABLE.TRANSFORMCOLUMNS/fxImportaCsv.m
```

Código da função:

```m
let
    fxImportaCsv = (vArquivoBinario as binary) as table =>
        let
            // Lê o arquivo CSV
            Fonte = Csv.Document(
                vArquivoBinario,
                [
                    Delimiter = ";",
                    Encoding = 65001,
                    QuoteStyle = QuoteStyle.Csv
                ]
            ),

            // Promove a primeira linha como cabeçalho
            CabecalhosPromovidos = Table.PromoteHeaders(
                Fonte,
                [PromoteAllScalars = true]
            )
        in
            CabecalhosPromovidos
in
    fxImportaCsv
```

---

## Parâmetro da função

| Parâmetro | Tipo | Descrição |
|---|---|---|
| `vArquivoBinario` | `binary` | Conteúdo binário do arquivo CSV, normalmente vindo de `File.Contents` ou da coluna `Content` de `Folder.Files`. |

---

## Configurações adotadas

| Configuração | Valor | Motivo |
|---|---:|---|
| `Delimiter` | `";"` | Padrão comum em arquivos CSV brasileiros e exportações corporativas. |
| `Encoding` | `65001` | UTF-8, preservando acentuação e caracteres especiais. |
| `QuoteStyle` | `QuoteStyle.Csv` | Trata corretamente campos entre aspas, inclusive com delimitadores ou quebras de linha internas. |
| `Table.PromoteHeaders` | `PromoteAllScalars = true` | Promove a primeira linha como cabeçalho de forma mais robusta. |

---

## Exemplo 1 — importar um único CSV

```m
let
    Binario = File.Contents("C:\\Dados\\vendas.csv"),
    Resultado = fxImportaCsv(Binario)
in
    Resultado
```

---

## Exemplo 2 — importar todos os CSVs de uma pasta

```m
let
    Arquivos = Folder.Files("C:\\Dados\\CSVs"),

    ApenasCsv = Table.SelectRows(
        Arquivos,
        each Text.Lower([Extension]) = ".csv"
    ),

    TabelasImportadas = Table.TransformColumns(
        ApenasCsv,
        {"Content", each fxImportaCsv(_)}
    ),

    Resultado = Table.Combine(TabelasImportadas[Content])
in
    Resultado
```

---

## Exemplo 3 — importar CSVs mantendo o nome do arquivo como rastreabilidade

```m
let
    Arquivos = Folder.Files("C:\\Dados\\CSVs"),

    ApenasCsv = Table.SelectRows(
        Arquivos,
        each Text.Lower([Extension]) = ".csv"
    ),

    ImportaTabela = Table.AddColumn(
        ApenasCsv,
        "TabelaImportada",
        each fxImportaCsv([Content]),
        type table
    ),

    ColunasParaExpandir = Table.ColumnNames(ImportaTabela{0}[TabelaImportada]),

    Resultado = Table.ExpandTableColumn(
        ImportaTabela,
        "TabelaImportada",
        ColunasParaExpandir,
        ColunasParaExpandir
    ),

    ColunasFinais = Table.SelectColumns(
        Resultado,
        List.Combine({{"Name", "Folder Path"}, ColunasParaExpandir})
    )
in
    ColunasFinais
```

---

## Boas práticas

1. Manter a função `fxImportaCsv` em uma consulta separada no Power Query.
2. Reutilizar a função nas consultas de carga, evitando repetir `Csv.Document` em vários lugares.
3. Filtrar apenas arquivos `.csv` antes da importação quando usar `Folder.Files`.
4. Manter uma coluna de rastreabilidade, como `Name` ou `Folder Path`, quando a origem dos arquivos precisar ser auditada.
5. Aplicar tipos de dados em uma etapa posterior, depois da combinação dos arquivos.
6. Evitar nomes de etapas excessivamente longos; preferir nomes claros e auditáveis.

---

## Observações

- Este padrão assume CSV separado por ponto e vírgula.
- Para arquivos separados por vírgula, alterar `Delimiter = ","`.
- Para arquivos Windows-1252, comum em exportações antigas, avaliar `Encoding = 1252`.
- A etapa de tipagem deve ser feita fora da função quando os arquivos puderem variar de estrutura.

---

## Commit sugerido

```text
docs: documenta padrão de importação CSV em Power Query
```

## Description sugerida

```text
Documenta o padrão reutilizável de importação de arquivos CSV no Power Query usando a função fxImportaCsv, com exemplos para arquivo único, múltiplos arquivos em pasta e rastreabilidade por nome de arquivo.
```
