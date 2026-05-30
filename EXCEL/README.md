# EXCEL - Funcoes Power Query M

Esta pasta concentra funcoes e exemplos de Power Query M voltados para importacao e tratamento de arquivos Excel.

## fxTrataExcelBinario

Arquivo: `EXCEL/fxTrataExcelBinario.m`

### Objetivo

A funcao `fxTrataExcelBinario` recebe o conteudo binario de um arquivo Excel e retorna:

- a lista de objetos do arquivo, quando nenhum objeto especifico e informado;
- os dados de uma aba, tabela ou nome definido especifico;
- opcionalmente, os dados com cabecalhos promovidos.

Essa abordagem e util para rotinas com `Folder.Files`, `SharePoint.Files`, `File.Contents` e consultas parametrizadas em que o arquivo Excel chega como binario na coluna `[Content]`.

### Assinatura

```m
fxTrataExcelBinario(
    pBinario as binary,
    optional pNomeObjeto as nullable text,
    optional pTipoObjeto as nullable text,
    optional pPromoverCabecalho as nullable logical
) as table
```

### Parametros

| Parametro | Tipo | Obrigatorio | Descricao |
|---|---|---:|---|
| `pBinario` | `binary` | Sim | Conteudo binario do arquivo Excel. Normalmente vem de `[Content]` em `Folder.Files` ou `SharePoint.Files`. |
| `pNomeObjeto` | `nullable text` | Nao | Nome da aba, tabela ou nome definido. Se nao informado, retorna a lista de objetos do Excel. |
| `pTipoObjeto` | `nullable text` | Nao | Tipo do objeto. Normalmente `Sheet`, `Table` ou `DefinedName`. Se nao informado, assume `Sheet`. |
| `pPromoverCabecalho` | `nullable logical` | Nao | Use `true` para promover a primeira linha como cabecalho. Se nao informado, assume `false`. |

### Exemplo 1 - listar objetos do arquivo

```m
let
    Etp_Arquivos = Folder.Files("C:\\Dados\\Excel"),
    Etp_FiltraArquivo = Table.SelectRows(
        Etp_Arquivos,
        each Text.Contains(Text.Lower([Name]), "controlador_parametros")
    ),
    Etp_Resultado = fxTrataExcelBinario(
        Etp_FiltraArquivo{0}[Content]
    )
in
    Etp_Resultado
```

### Exemplo 2 - importar uma tabela do Excel

```m
let
    Etp_Arquivos = Folder.Files("C:\\Dados\\Excel"),
    Etp_FiltraArquivo = Table.SelectRows(
        Etp_Arquivos,
        each Text.Contains(Text.Lower([Name]), "controlador_parametros")
    ),
    Etp_Resultado = fxTrataExcelBinario(
        Etp_FiltraArquivo{0}[Content],
        "tblParametros",
        "Table",
        false
    )
in
    Etp_Resultado
```

### Exemplo 3 - importar uma aba e promover cabecalhos

```m
let
    Etp_Arquivos = Folder.Files("C:\\Dados\\Excel"),
    Etp_FiltraArquivo = Table.SelectRows(
        Etp_Arquivos,
        each Text.Contains(Text.Lower([Name]), "fpg5")
    ),
    Etp_Resultado = fxTrataExcelBinario(
        Etp_FiltraArquivo{0}[Content],
        "FactExtracao_1_2",
        "Sheet",
        true
    )
in
    Etp_Resultado
```

### Boas praticas

1. Filtrar extensoes antes de chamar a funcao, como `.xlsx`, `.xlsm` e `.xlsb`.
2. Ignorar arquivos temporarios do Excel iniciados por `~$`.
3. Validar se o filtro encontrou arquivo antes de acessar `{0}[Content]`.
4. Preferir tabelas nomeadas no Excel quando o layout for controlado, por exemplo `tblParametros`.
5. Aplicar tipos de dados em etapa posterior, fora da funcao, principalmente quando a estrutura pode variar.

### Observacao

A funcao usa `Excel.Workbook(pBinario, null, true)`. O terceiro argumento como `true` ajuda a preservar comportamento de leitura adequado para arquivos Excel com estrutura tabular.
