# fxTransformaColunaCondicionalmente

> **Linguagem M — Power Query**  
> Altera o valor de uma coluna com base em uma condição textual de outra coluna.

---

## 📋 Descrição

Essa função recebe uma tabela e substitui o valor de uma coluna-alvo **somente nas linhas** em que uma coluna de condição **contém** um texto específico.

- A busca é **case-insensitive** (ignora maiúsculas/minúsculas).
- Linhas em que a coluna de condição for `null` **não são alteradas**.
- O novo valor pode ser de qualquer tipo (`text`, `number`, `null`, etc.).

---

## 🔧 Parâmetros

| Parâmetro            | Tipo     | Descrição                                                        |
|----------------------|----------|------------------------------------------------------------------|
| `tabela`             | `table`  | Tabela de entrada                                                |
| `nomeColunaAlterar`  | `text`   | Nome da coluna cujo valor será substituído                       |
| `nomeColunaCondicao` | `text`   | Nome da coluna usada como condição para aplicar a substituição   |
| `textoProcurado`     | `text`   | Texto que será buscado na coluna de condição                     |
| `novoValor`          | `any`    | Valor que substituirá o conteúdo da coluna-alvo quando satisfeita a condição |

---

## 📂 Como carregar a função no Power Query

### Opção 1 — Consulta em branco (recomendado)

1. No Power Query, clique em **Nova Consulta → Consulta em Branco**.
2. Abra o **Editor Avançado**.
3. Cole o conteúdo do arquivo [`fxTransformaColunaCondicionalmente.m`](./fxTransformaColunaCondicionalmente.m).
4. Renomeie a consulta para `fxTransformaColunaCondicionalmente`.
5. Clique em **Concluído**.

### Opção 2 — Importar direto pelo Editor Avançado

Copie e cole o código abaixo em uma nova consulta em branco:

```m
(
    tabela as table,
    nomeColunaAlterar as text,
    nomeColunaCondicao as text,
    textoProcurado as text,
    novoValor as any
) as table =>
    Table.ReplaceValue(
        tabela,
        each Record.Field(_, nomeColunaAlterar),
        each
            if Record.Field(_, nomeColunaCondicao) <> null
                and Text.Contains(
                    Text.From( Record.Field(_, nomeColunaCondicao) ),
                    textoProcurado,
                    Comparer.OrdinalIgnoreCase
                )
            then
                novoValor
            else
                Record.Field(_, nomeColunaAlterar),
        Replacer.ReplaceValue,
        { nomeColunaAlterar }
    )
```

---

## 🚀 Modo de Usar

### Exemplo básico

Substitui o valor da coluna **`"Status"`** por `"Cancelado"` sempre que a coluna **`"Observação"`** contiver o texto `"cancel"`.

```m
let
    Fonte = SuaTabela,
    Resultado = fxTransformaColunaCondicionalmente(
        Fonte,
        "Status",       // Coluna a ser alterada
        "Observação",   // Coluna de condição
        "cancel",       // Texto procurado (case-insensitive)
        "Cancelado"     // Novo valor
    )
in
    Resultado
```

### Exemplo com tabela literal (teste rápido)

```m
let
    TabelaTeste = Table.FromRecords({
        [ Produto = "Notebook",  Categoria = "Eletrônico",  Ativo = true  ],
        [ Produto = "Mouse",     Categoria = "Acessório",   Ativo = true  ],
        [ Produto = "Teclado",   Categoria = "acessório",   Ativo = true  ],
        [ Produto = "Monitor",   Categoria = null,          Ativo = true  ]
    }),
    // Marca como false todos os produtos cuja Categoria contém "acessório"
    Resultado = fxTransformaColunaCondicionalmente(
        TabelaTeste,
        "Ativo",        // Coluna a alterar
        "Categoria",    // Coluna de condição
        "acessório",    // Texto procurado
        false           // Novo valor
    )
in
    Resultado
```

**Resultado esperado:**

| Produto  | Categoria   | Ativo |
|----------|-------------|-------|
| Notebook | Eletrônico  | true  |
| Mouse    | Acessório   | false |
| Teclado  | acessório   | false |
| Monitor  | null        | true  |

> ℹ️ Repare que `"Acessório"` e `"acessório"` são tratados da mesma forma graças ao `Comparer.OrdinalIgnoreCase`. A linha com `null` na condição permanece inalterada.

### Exemplo encadeando múltiplas transformações

```m
let
    Fonte = SuaTabela,
    // Primeira regra: se Tipo contém "devol", zera o valor
    Passo1 = fxTransformaColunaCondicionalmente(Fonte,    "Valor", "Tipo", "devol",   0),
    // Segunda regra: se Status contém "pend", marca prioridade como "Alta"
    Passo2 = fxTransformaColunaCondicionalmente(Passo1,  "Prioridade", "Status", "pend", "Alta"),
    // Terceira regra: se Região contém "norte", aplica desconto "10%"
    Passo3 = fxTransformaColunaCondicionalmente(Passo2,  "Desconto", "Região", "norte", "10%")
in
    Passo3
```

---

## ⚙️ Detalhes de Implementação

A função utiliza `Table.ReplaceValue` internamente, o que garante:

- **Performance**: a substituição ocorre de forma nativa e vetorizada, sem `Table.AddColumn` + `Table.RemoveColumns`.
- **Tipagem preservada**: a coluna mantém o tipo original definido na tabela.
- **Segurança contra null**: a verificação `<> null` evita erros ao chamar `Text.From`.

---

## 📁 Arquivos do Diretório

| Arquivo                                    | Descrição                             |
|--------------------------------------------|---------------------------------------|
| `fxTransformaColunaCondicionalmente.m`     | Código-fonte da função em Linguagem M |
| `README.md`                                | Documentação completa                 |
| `Excel.Workbook`                           | Exemplo de uso em arquivo Excel       |

---

## 🔗 Referências

- [`Table.ReplaceValue`](https://learn.microsoft.com/pt-br/powerquery-m/table-replacevalue) — Microsoft Docs
- [`Text.Contains`](https://learn.microsoft.com/pt-br/powerquery-m/text-contains) — Microsoft Docs
- [`Comparer.OrdinalIgnoreCase`](https://learn.microsoft.com/pt-br/powerquery-m/comparer-ordinalignorecase) — Microsoft Docs
