# FUNCOES

Exemplos gerais de Power Query M migrados do Google Doc `Exemplo de Funcoes Power - Linguagem M`.

Arquivo principal: [`Exemplos_Funcoes_PowerQuery.m`](./Exemplos_Funcoes_PowerQuery.m)

## Conteudo migrado

Este guia consolida exemplos de:

- acesso a registros em tabelas com `Tabela{[Campo = Valor]}`;
- `if` com `Text.Contains`;
- condicoes combinadas com `and`, `not`, `List.AnyTrue` e `List.AllTrue`;
- `Text.PositionOf` e `Text.Range`;
- `Table.Max` em tabelas aninhadas;
- `Table.AddIndexColumn`;
- `Table.SelectRows`;
- `Table.PromoteHeaders`;
- `Date.ToText` para nome de mes e dia da semana;
- simulacao de `SWITCH` com lista de pares chave/resultado.

## Exemplos principais

### Buscar valor em uma tabela por codigo

```m
Transporte{[Cod = "P"]}[Descrição]
```

Quando quiser transformar isso em funcao reutilizavel, use o padrao `fxBuscaRegistroPorCodigo` do arquivo `.m`.

### Classificar texto com Text.Contains

```m
if Text.Contains([Produto], "Curso SSBI", Comparer.OrdinalIgnoreCase)
then "Curso SSBI"
else "Curso Dashboards"
```

### Validar classificacao contabil

```m
if Text.Contains([Tipo Lcto], "Partida Dobrada")
    and [Cta Debito] <> null
    and [Cta Credito] <> null
then "Ok"
else "Classif Contabil Errada"
```

### Extrair texto a partir de uma posicao

```m
Text.Range(
    [Produto],
    Text.PositionOf([Produto], "Tur"),
    5
)
```

### Remover acentos/caracteres especiais

O Google Doc tinha uma funcao chamada `RemovendoAcento`. No repositorio ja existe uma funcao mais completa para esse objetivo:

- [`TEXTO/fxRemovedorAcentosCaracteresEspeciais.m`](../TEXTO/fxRemovedorAcentosCaracteresEspeciais.m)

Ela usa `Text.ToList`, `List.ReplaceMatchingItems`, `Text.Combine` e `Text.Select` para substituir acentos e manter apenas caracteres permitidos.

### Retornar maior linha de uma tabela aninhada

```m
Table.Max([Vendas], "Total")
```

Use quando uma coluna contem tabelas aninhadas, por exemplo depois de agrupamentos ou merges.

### Promover cabecalhos

```m
Table.PromoteHeaders(tabela)
```

### Nome de mes e dia da semana

```m
Date.ToText([DataBase], "MMMM", "pt-BR")
Date.ToText([DataBase], "dddd", "pt-BR")
```

### Simular SWITCH

Power Query nao tem `SWITCH` nativo como DAX/Excel. Um padrao simples e usar lista de pares:

```m
let
    Valores = {{"E", "Employee"}, {"S", "SCYC"}, {"N", "Non-Taxable"}},
    Encontrado = List.Select(Valores, each _{0} = Text.Upper([Codigo])),
    Resultado = if List.IsEmpty(Encontrado) then "Undefined" else Encontrado{0}{1}
in
    Resultado
```

## Conteudos ja migrados em outras pastas

Alguns trechos do mesmo Google Doc foram tratados em arquivos dedicados:

- [`LOOKUP/pqVLOOKUP.m`](../LOOKUP/pqVLOOKUP.m)
- [`FILTER/Table.SelectRows_List.Contains.m`](../FILTER/Table.SelectRows_List.Contains.m)
- [`TABLE.TRANSFORMCOLUMNS/Table.ReplaceValue_MultiplasCondicoes.m`](../TABLE.TRANSFORMCOLUMNS/Table.ReplaceValue_MultiplasCondicoes.m)

## Correcoes feitas na migracao

1. Os exemplos foram convertidos para sintaxe copiavel em Power Query M.
2. Comparacoes como `= true` foram simplificadas quando desnecessarias.
3. Comparacoes com nulo usam `<> null` nos exemplos novos.
4. `Text.Contains` recebeu `Comparer.OrdinalIgnoreCase` onde a intencao era busca sem diferenciar maiusculas/minusculas.
5. A simulacao de `SWITCH` agora trata codigo nao encontrado sem erro.
