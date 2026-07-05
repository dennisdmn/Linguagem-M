# Power Query Formula Language Specification

Referencia para o PDF `Power Query Formula Language Specification (October 2016)` que estava no Google Drive.

## Identificacao

- Titulo: `Microsoft Power Query for Excel Formula Language Specification`
- Data: October 2016
- Publicador: Microsoft Corporation
- Tema: especificacao da linguagem M usada pelo Power Query

## Por que nao subir o PDF

O arquivo e uma especificacao oficial em PDF. Para o repositorio, e mais util manter um resumo de navegacao e os topicos relevantes do que versionar o PDF inteiro.

## Topicos mais uteis

- Expressoes e valores
- Avaliacao e imutabilidade
- `let` expression
- `if` expression
- Funcoes e parametros opcionais
- Tratamento de erro com `try ... otherwise`
- Tipos primitivos e `nullable`
- Listas, registros e tabelas
- Operadores de selecao e projecao
- Acesso a item `{}` e campo `[]`
- Identificadores com `#"Nome da Etapa"`
- Comentarios `//` e `/* ... */`
- `#shared` e `#sections`

## Exemplos importantes

### try otherwise

```m
try error "A" otherwise 1
```

### Acesso a campo

```m
Registro[Campo]
```

### Acesso a item de lista ou linha de tabela

```m
Lista{0}
Tabela{0}
```

### Identificador com espaco

```m
#"Tipo Alterado"
```

## Como usar esta referencia

Use este arquivo como mapa rapido quando precisar consultar regras da linguagem M. Para documentacao de funcoes da biblioteca, prefira tambem consultar a documentacao atual da Microsoft Learn.
