# Linguagem M

Repositório com exemplos, funções e padrões de uso da linguagem M do Power Query para Excel, Power BI Desktop e fluxos de dados.

## Estrutura

### Funções

- **[fxValidaCamposObrigatorios.pq](funcoes/validacao/fxValidaCamposObrigatorios.pq)**  
  Valida múltiplas colunas obrigatórias informadas como texto separado por vírgula e retorna, por linha, quais campos estão em branco.

### Exemplos

- **[fxValidaCamposObrigatorios_exemplo.pq](exemplos/fxValidaCamposObrigatorios_exemplo.pq)**  
  Exemplo com base contábil simulada e validação das colunas obrigatórias.

---

## fxValidaCamposObrigatorios

**Categoria:** Validação de Dados  
**Arquivo:** `funcoes/validacao/fxValidaCamposObrigatorios.pq`

### Descrição

A função `fxValidaCamposObrigatorios` valida, linha a linha, se colunas obrigatórias estão nulas, vazias ou preenchidas apenas com espaços.

As colunas obrigatórias são informadas em um único texto separado por vírgula, o que facilita o uso pela janela **Invocar Função Personalizada** do Power Query.

### Parâmetros

- `Tabela` (`table`): tabela que será validada.
- `ColunasObrigatoriasTexto` (`text`): nomes das colunas obrigatórias separados por vírgula.
- `NomeColunaErros` (`nullable text`, opcional): nome da coluna que listará os campos em branco. Padrão: `Campos_Em_Branco`.
- `NomeColunaStatus` (`nullable text`, opcional): nome da coluna de status. Padrão: `Status_Validacao`.

### Retorno

A função retorna a tabela original com duas colunas adicionais:

- `Campos_Em_Branco`: lista das colunas obrigatórias em branco naquela linha.
- `Status_Validacao`: retorna `OK` ou `Campo obrigatório em branco`.

### Exemplo de uso

```m
let
    Fonte = Etapa_DefineTipos,

    Etapa_ValidaCamposObrigatorios = fxValidaCamposObrigatorios(
        Fonte,
        "empresa, filial, debito, credito, valor, hist, ccustod, ccustoc, usuario, clvlrdeb, clvlrcrd, ent05deb, ent05crd, tpsaldo, lote, versao, data"
    )
in
    Etapa_ValidaCamposObrigatorios
```

### Exemplo com nomes personalizados

```m
let
    Fonte = Etapa_DefineTipos,

    Etapa_ValidaCamposObrigatorios = fxValidaCamposObrigatorios(
        Fonte,
        "empresa, filial, debito, credito, valor, data",
        "Campos_Com_Problema",
        "Status"
    )
in
    Etapa_ValidaCamposObrigatorios
```

### Comportamento

- `null` é tratado como campo obrigatório em branco.
- Texto vazio é tratado como campo obrigatório em branco.
- Texto apenas com espaços é tratado como campo obrigatório em branco.
- Campos preenchidos retornam status `OK`.
- Coluna obrigatória informada, mas ausente na tabela, será tratada como campo em branco.

---

## Como usar uma função do repositório

1. Abra o arquivo `.pq` da função desejada.
2. Copie o código completo.
3. No Power Query, crie uma **Consulta em Branco**.
4. Abra o **Editor Avançado**.
5. Cole o código da função.
6. Renomeie a consulta com o nome da função, por exemplo `fxValidaCamposObrigatorios`.
7. Use a função em outras consultas.
