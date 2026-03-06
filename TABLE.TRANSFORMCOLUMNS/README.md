# TABLE.TRANSFORMCOLUMNS

> **Linguagem M — Power Query**  
> Scripts e funções personalizadas para transformar colunas de forma eficiente, evitando o padrão `Table.AddColumn` + `Table.RemoveColumns`.

---

## 🎯 Proposta deste diretório

Em Power Query, uma transformação de coluna pode ser feita de dois jeitos:

**❌ Padrão verboso (evitar)**
```m
let
    Passo1 = Table.AddColumn(Fonte, "ColTemp", each <lógica>),
    Passo2 = Table.RemoveColumns(Passo1, {"ColunaOriginal"}),
    Passo3 = Table.RenameColumns(Passo2, {"ColTemp", "ColunaOriginal"})
in
    Passo3
```

**✅ Padrão preferido (usar)**
```m
// Table.TransformColumns — transforma no lugar, sem criar colunas auxiliares
Table.TransformColumns(tabela, {"Coluna", each <lógica>})

// Table.ReplaceValue — substitui valores com controle total de condição
Table.ReplaceValue(tabela, oldValue, newValue, Replacer.ReplaceValue, {"Coluna"})
```

Os scripts e funções aqui armazenados aplicam esse princípio em cenários reais.

---

## 📁 Scripts e Funções

### 1. `Excel.Workbook` — Expansão de binários com `Table.TransformColumns`

Demonstra como usar `Table.TransformColumns` para converter a coluna `Content` (binário) em workbooks Excel **diretamente**, sem criar uma coluna auxiliar.

```m
let
    // Fonte: tabela com coluna "Content" contendo valores binários (ex: resultado de Folder.Files)
    Fonte = YourTable,

    // Transforma a coluna "Content" no lugar, convertendo cada binário em workbook
    DadosExtraidos = Table.TransformColumns(
        Fonte,
        {"Content", each Excel.Workbook(_, true)}
    )
in
    DadosExtraidos
```

> 💡 Aplicação típica: quando você carrega uma pasta de arquivos via `Folder.Files`, a coluna `Content` retorna binários. Esse script converte cada um diretamente com `Excel.Workbook`, sem `Table.AddColumn`.

---

### 2. `fxTransformaColunaCondicionalmente.m` — Substituição condicional via `Table.ReplaceValue`

Função personalizada que altera o valor de uma coluna **somente nas linhas** em que outra coluna contém um texto específico.

- A busca é **case-insensitive** (ignora maiúsculas/minúsculas).
- Linhas em que a coluna de condição for `null` **não são alteradas**.
- O novo valor pode ser de qualquer tipo (`text`, `number`, `null`, `logical`, etc.).

#### Parâmetros

| Parâmetro            | Tipo    | Descrição                                                          |
|----------------------|---------|--------------------------------------------------------------------|
| `tabela`             | `table` | Tabela de entrada                                                  |
| `nomeColunaAlterar`  | `text`  | Nome da coluna cujo valor será substituído                         |
| `nomeColunaCondicao` | `text`  | Nome da coluna usada como condição                                 |
| `textoProcurado`     | `text`  | Texto buscado na coluna de condição (case-insensitive)             |
| `novoValor`          | `any`   | Valor substituto quando a condição for satisfeita                  |

#### Como carregar no Power Query

1. Clique em **Nova Consulta → Consulta em Branco**.
2. Abra o **Editor Avançado**.
3. Cole o conteúdo de [`fxTransformaColunaCondicionalmente.m`](./fxTransformaColunaCondicionalmente.m).
4. Renomeie a consulta para `fxTransformaColunaCondicionalmente`.
5. Clique em **Concluído**.

#### Exemplo básico

```m
let
    Fonte = SuaTabela,
    Resultado = fxTransformaColunaCondicionalmente(
        Fonte,
        "Status",      // Coluna a alterar
        "Observação",  // Coluna de condição
        "cancel",      // Texto procurado (case-insensitive)
        "Cancelado"    // Novo valor
    )
in
    Resultado
```

#### Exemplo com tabela literal (teste rápido)

```m
let
    TabelaTeste = Table.FromRecords({
        [ Produto = "Notebook",  Categoria = "Eletrônico",  Ativo = true  ],
        [ Produto = "Mouse",     Categoria = "Acessório",   Ativo = true  ],
        [ Produto = "Teclado",   Categoria = "acessório",   Ativo = true  ],
        [ Produto = "Monitor",   Categoria = null,          Ativo = true  ]
    }),
    Resultado = fxTransformaColunaCondicionalmente(
        TabelaTeste,
        "Ativo",       // Coluna a alterar
        "Categoria",   // Coluna de condição
        "acessório",   // Texto procurado
        false          // Novo valor
    )
in
    Resultado
```

**Resultado esperado:**

| Produto  | Categoria  | Ativo |
|----------|------------|-------|
| Notebook | Eletrônico | true  |
| Mouse    | Acessório  | false |
| Teclado  | acessório  | false |
| Monitor  | null       | true  |

> ℹ️ `"Acessório"` e `"acessório"` são tratados igualmente pelo `Comparer.OrdinalIgnoreCase`. A linha com `null` na condição permanece inalterada.

#### Exemplo encadeando múltiplas regras

```m
let
    Fonte = SuaTabela,
    Passo1 = fxTransformaColunaCondicionalmente(Fonte,  "Valor",      "Tipo",   "devol",  0),
    Passo2 = fxTransformaColunaCondicionalmente(Passo1, "Prioridade", "Status", "pend",   "Alta"),
    Passo3 = fxTransformaColunaCondicionalmente(Passo2, "Desconto",   "Região", "norte",  "10%")
in
    Passo3
```

---

### 3. `fxMantemPrimeirasLinhasTabelaAninhada.m` — Truncar tabelas aninhadas via `Table.TransformColumns`

Função personalizada que **mantém apenas as primeiras N linhas** de uma coluna que contém tabelas aninhadas (`nested tables`). Aplica `Table.FirstN` em cada célula do tipo `table`, ignorando valores de outros tipos sem gerar erro.

- Opera **no lugar**, sem criar colunas auxiliares.
- Protege contra células não-tabela com `Value.Is(_, type table)`.
- Ideal para cenários de merge/expand onde a tabela aninhada pode ter múltiplas correspondências e você deseja apenas a primeira (ou N primeiras).

#### Parâmetros

| Parâmetro            | Tipo     | Descrição                                                                 |
|----------------------|----------|---------------------------------------------------------------------------|
| `pTabela`            | `table`  | Tabela de entrada que contém a coluna com tabelas aninhadas               |
| `pNomeColunaTabela`  | `text`   | Nome da coluna cujos valores são tabelas aninhadas                        |
| `pQuantidadeLinhas`  | `number` | Número de linhas a manter em cada tabela aninhada (ex: `1` = só a primeira) |

#### Como carregar no Power Query

1. Clique em **Nova Consulta → Consulta em Branco**.
2. Abra o **Editor Avançado**.
3. Cole o conteúdo de [`fxMantemPrimeirasLinhasTabelaAninhada.m`](./fxMantemPrimeirasLinhasTabelaAninhada.m).
4. Renomeie a consulta para `fxMantemPrimeirasLinhasTabelaAninhada`.
5. Clique em **Concluído**.

#### Exemplo de uso — manter apenas a primeira linha

```m
let
    Fonte = SuaTabela,

    // Após um merge, a coluna "DimDePara_Hyperion" contém tabelas aninhadas
    // com múltiplas correspondências. Mantemos apenas a primeira linha de cada.
    PrimeiraLinhaApenas = fxMantemPrimeirasLinhasTabelaAninhada(
        Fonte,
        "DimDePara_Hyperion",
        1
    )
in
    PrimeiraLinhaApenas
```

#### Exemplo completo — fluxo pós-merge

```m
let
    Fonte         = Excel.CurrentWorkbook(){[Name="tblVendas"]}[Content],
    Dimensao      = Excel.CurrentWorkbook(){[Name="tblDimDePara"]}[Content],

    // 1. Merge gera coluna com tabelas aninhadas (relação 1:N)
    LinhasMescladas = Table.NestedJoin(
        Fonte,    {"CodigoProduto"},
        Dimensao, {"CodigoProduto"},
        "DimDePara_Hyperion",
        JoinKind.LeftOuter
    ),

    // 2. Truncar para apenas 1 linha por tabela aninhada (deduplicação)
    PrimeiraLinhaApenas = fxMantemPrimeirasLinhasTabelaAninhada(
        LinhasMescladas,
        "DimDePara_Hyperion",
        1
    ),

    // 3. Expandir normalmente
    Expandido = Table.ExpandTableColumn(
        PrimeiraLinhaApenas,
        "DimDePara_Hyperion",
        {"DescricaoHyperion"},
        {"DescricaoHyperion"}
    )
in
    Expandido
```

**Resultado esperado (antes vs depois do truncamento):**

| CodigoProduto | DimDePara_Hyperion (antes)       | DimDePara_Hyperion (depois) |
|---------------|----------------------------------|-----------------------------|
| P001          | Table [3 linhas]                 | Table [1 linha]             |
| P002          | Table [1 linha]                  | Table [1 linha]             |
| P003          | Table [2 linhas]                 | Table [1 linha]             |

> ⚠️ Use `pQuantidadeLinhas = 1` quando o merge for do tipo **1:N** e você quiser garantir apenas uma correspondência por linha antes do expand — evitando duplicatas no resultado final.

#### Variação — manter as 3 primeiras linhas

```m
Top3Linhas = fxMantemPrimeirasLinhasTabelaAninhada(
    LinhasMescladas,
    "DimDePara_Hyperion",
    3
)
```

---

## ⚙️ Por que `Table.TransformColumns` e não `Table.AddColumn`?

| Critério               | `Table.AddColumn` + remove | `Table.TransformColumns` / `Table.ReplaceValue` |
|------------------------|----------------------------|-------------------------------------------------|
| Passos necessários     | 3 (add, remove, rename)    | 1                                               |
| Coluna auxiliar criada | Sim                        | Não                                             |
| Tipo da coluna         | Requer redefinição         | Preservado automaticamente                      |
| Legibilidade           | Verboso                    | Conciso                                         |

---

## 🔗 Referências

- [`Table.TransformColumns`](https://learn.microsoft.com/pt-br/powerquery-m/table-transformcolumns) — Microsoft Docs
- [`Table.ReplaceValue`](https://learn.microsoft.com/pt-br/powerquery-m/table-replacevalue) — Microsoft Docs
- [`Table.FirstN`](https://learn.microsoft.com/pt-br/powerquery-m/table-firstn) — Microsoft Docs
- [`Table.NestedJoin`](https://learn.microsoft.com/pt-br/powerquery-m/table-nestedjoin) — Microsoft Docs
- [`Value.Is`](https://learn.microsoft.com/pt-br/powerquery-m/value-is) — Microsoft Docs
- [`Excel.Workbook`](https://learn.microsoft.com/pt-br/powerquery-m/excel-workbook) — Microsoft Docs
- [`Text.Contains`](https://learn.microsoft.com/pt-br/powerquery-m/text-contains) — Microsoft Docs
- [`Comparer.OrdinalIgnoreCase`](https://learn.microsoft.com/pt-br/powerquery-m/comparer-ordinalignorecase) — Microsoft Docs
