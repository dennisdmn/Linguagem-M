# dCalendario-v5.2

Documentacao de uso para o script [`dCalendario-v5.2`](./dCalendario-v5.2), uma tabela calendario em Power Query M voltada para modelos de Power BI, Excel Power Query e Dataflows.

O arquivo gera uma dimensao calendario completa a partir de uma data inicial e uma data final, com atributos de dia, semana, mes, trimestre, semestre, bimestre, ano fiscal, feriados, dias uteis e periodos relativos a data atual.

## Origem

O script original foi criado por Alison Pezzott e mantem os creditos no cabecalho do arquivo:

- Repositorio original: <https://github.com/alisonpezzott/powerbi/tree/main/power-query-m/dcalendario>
- Arquivo de apoio para ordenacao: <https://github.com/alisonpezzott/powerbi/blob/main/power-query-m/dcalendario/dcalendario-v5.2-ordenacao.xlsx>

Este repositorio guarda uma copia de referencia para uso e consulta em projetos de Linguagem M.

## Quando usar

Use esta consulta quando o modelo precisar de uma tabela de datas padronizada para:

- relacionar fatos por data;
- criar filtros de ano, mes, semana, trimestre, semestre, bimestre e quinzena;
- trabalhar com offsets de periodo, como mes atual, mes anterior e proximo mes;
- identificar feriados, dias uteis e numero do dia util no mes;
- organizar periodos fiscais e mes de fechamento;
- ordenar nomes abreviados de meses e dias da semana corretamente em visuais.

## Como instalar no Power Query

1. Crie uma consulta em branco no Power Query.
2. Abra o Editor Avancado.
3. Copie todo o conteudo de [`dCalendario-v5.2`](./dCalendario-v5.2).
4. Cole no Editor Avancado e confirme.
5. Renomeie a consulta para `dCalendario` ou outro nome padrao do seu modelo.
6. Ajuste os parametros da secao `Configuracoes` antes de carregar a tabela.

## Parametros principais

Os parametros ficam no inicio do script.

| Parametro | Exemplo atual | Descricao |
|---|---:|---|
| `dataInicial` | `#date(2023, 1, 1)` | Primeira data gerada na tabela calendario. |
| `dataFinal` | fim do ano atual | Ultima data gerada. Por padrao usa o final do ano da data atual do servidor. |
| `dataAtual` | data atual do servidor | Base para colunas de offset e rotulos como `Mes Atual`, `Ano Atual` e `Semana Atual`. |
| `inicioSemana` | `Day.Monday` | Define o primeiro dia da semana usado em calculos semanais. |
| `mesInicioAnoFiscal` | `4` | Mes em que o ano fiscal comeca. `4` significa abril. |
| `diaInicioMesFechamento` | `16` | Dia que inicia o mes de fechamento. Com `16`, o fechamento vai do dia 16 ao dia 15 do mes seguinte. |
| `idioma` | `"pt-BR"` | Cultura usada para nomes de meses e dias da semana. |

## Ajustes comuns

### Calendario fixo ate um ano especifico

Substitua `dataFinal` por uma data fixa:

```m
dataFinal = #date(2030, 12, 31)
```

### Semana iniciando no domingo

```m
inicioSemana = Day.Sunday
```

### Ano fiscal iniciando em janeiro

```m
mesInicioAnoFiscal = 1
```

### Mes de fechamento igual ao mes calendario

Se nao houver regra de fechamento deslocada, use o primeiro dia do mes:

```m
diaInicioMesFechamento = 1
```

## Principais grupos de colunas

### Data

Colunas de identificacao basica da data:

- `DataIndice`
- `Data`
- `DataOffset`
- `DataNomeAtual`

`DataOffset` mede a distancia em dias entre a linha e `dataAtual`. Valor `0` representa a data atual, `-1` a data anterior e `1` a proxima data.

### Ano

Colunas para ano calendario e ano fiscal:

- `AnoNum`
- `AnoInicio`
- `AnoFim`
- `AnoIndice`
- `AnoDescrescenteNome`
- `AnoDescrescenteNum`
- `AnoFiscal`
- `AnoOffset`
- `AnoNomeAtual`

`AnoOffset` e util para filtros dinamicos, por exemplo `0` para ano atual, `-1` para ano anterior e `1` para proximo ano.

### Dia da semana e dia do ano

Colunas para granularidade diaria:

- `DiaDoMesNum`
- `DiaDoAnoNum`
- `DiaDaSemanaNum`
- `DiaDaSemanaNome`
- `DiaDaSemanaNomeAbrev`
- `DiaDaSemanaNomeIniciais`

As colunas com iniciais usam caracteres invisiveis de ordenacao para ajudar visuais que exibem apenas a primeira letra do dia.

### Mes

Colunas para mes, mes/ano e ordenacao:

- `MesNum`
- `MesNome`
- `MesNomeAbrev`
- `MesNomeIniciais`
- `MesAnoNum`
- `MesAnoNome`
- `MesDiaNum`
- `MesDiaNome`
- `MesInicio`
- `MesFim`
- `MesIndice`
- `MesOffset`
- `MesNomeAtual`
- `MesNomeAbrevAtual`
- `MesAnoNomeAtual`

`MesIndice` facilita ordenar periodos ao longo de varios anos. `MesOffset` facilita filtros relativos, como mes atual e meses anteriores.

### Trimestre

Colunas trimestrais:

- `TrimestreNum`
- `TrimestreInicio`
- `TrimestreFim`
- `TrimestreAnoNum`
- `TrimestreAnoNome`
- `TrimestreIndice`
- `TrimestreOffset`
- `TrimestreAnoNomeAtual`

### Semana

O script gera informacoes de semana padrao e semana ISO:

- `SemanaIsoNum`
- `AnoIsoNum`
- `SemanaIsoAnoNum`
- `SemanaIsoAnoNome`
- `SemanaIsoInicio`
- `SemanaIsoFim`
- `SemanaIsoIndice`
- `SemanaIsoOffset`
- `SemanaIsoAnoNomeAtual`
- `SemanaNum`
- `SemanaAnoNum`
- `SemanaAnoNome`
- `SemanaInicio`
- `SemanaFim`
- `SemanaPeriodo`
- `SemanaIndice`
- `SemanaOffset`
- `SemanaAnoNomeAtual`
- `SemanaDoMesNum`
- `SemanaDoMesPadraoNum`
- `SemanaDoMesAnoPadraoNome`
- `SemanaDoMesAnoPadraoNum`

Use as colunas ISO quando a regra de negocio exigir semana ISO, normalmente iniciando na segunda-feira e com ano ISO proprio.

### Semana ancorada no inicio da semana

Colunas derivadas do inicio da semana:

- `AnoSemanalNum`
- `MesSemanalNum`
- `MesSemanalNome`
- `MesSemanalNomeAbrev`
- `MesAnoSemanalNum`
- `MesAnoSemanalNome`

Essas colunas ajudam quando a semana cruza dois meses ou dois anos e o relatorio precisa atribuir a semana ao periodo em que ela comeca.

### Quinzena, semestre e bimestre

Colunas para periodos intermediarios:

- `QuinzenaDoMesNum`
- `QuinzenaMesNum`
- `QuinzenaMesNome`
- `QuinzenaMesAnoNum`
- `QuinzenaMesAnoNome`
- `QuinzenaIndice`
- `QuinzenaOffset`
- `QuinzenaMesAnoNomeAtual`
- `SemestreDoAnoNum`
- `SemestreAnoNum`
- `SemestreAnoNome`
- `SemestreIndice`
- `SemestreOffset`
- `SemestreAnoNomeAtual`
- `BimestreDoAnoNum`
- `BimestreAnoNum`
- `BimestreAnoNome`
- `BimestreIndice`
- `BimestreOffset`
- `BimestreAnoNomeAtual`

### Feriados e dias uteis

Colunas de calendario operacional:

- `FeriadoNome`
- `DiaUtilNum`
- `DiaUtilNome`
- `DiaUtilDoMes`

`DiaUtilNum` retorna `1` para dia util e `0` para fim de semana ou feriado cadastrado. `DiaUtilDoMes` soma os dias uteis acumulados dentro do mes.

Os feriados fixos e moveis sao definidos dentro do script. Revise a lista antes de usar em empresas, cidades ou estados com calendarios especificos.

### Estacao e fechamento

Colunas adicionais:

- `EstacaoAnoNum`
- `EstacaoAnoNome`
- `MesFechamentoNum`
- `MesFechamentoNome`
- `MesFechamentoNomeAbrev`
- `AnoFechamentoNum`
- `MesAnoFechamentoNum`
- `MesAnoFechamentoNome`

As colunas de fechamento usam `diaInicioMesFechamento` para deslocar datas depois do dia de corte para o mes de fechamento seguinte.

## Boas praticas no modelo

1. Marque a tabela como tabela de datas no Power BI, usando a coluna `Data`.
2. Crie relacionamentos entre fatos e `dCalendario[Data]`.
3. Use colunas numericas como `MesAnoNum`, `TrimestreAnoNum`, `SemanaAnoNum` e `MesAnoFechamentoNum` para ordenacao.
4. Revise feriados locais antes de usar `DiaUtilNum` e `DiaUtilDoMes` em indicadores operacionais.
5. Evite alterar nomes de colunas se elas ja forem usadas em medidas DAX ou em visuais.
6. Se o modelo tiver muitos anos, avalie reduzir `dataInicial` e `dataFinal` para diminuir o tamanho da tabela.

## Observacoes tecnicas

- O script usa `List.Buffer` e `Table.Buffer` em pontos especificos para reduzir recomputacoes.
- A tabela e criada com `#table`, ja declarando tipos de dados das colunas.
- Feriados moveis sao calculados a partir da Pascoa.
- Rotulos relativos dependem de `DateTime.LocalNow()`, portanto podem variar conforme o ambiente em que a consulta atualiza.

## Arquivos relacionados

- [`dCalendario-v5.2`](./dCalendario-v5.2): script principal em Power Query M.
- Arquivo externo de ordenacao do autor original: <https://github.com/alisonpezzott/powerbi/blob/main/power-query-m/dcalendario/dcalendario-v5.2-ordenacao.xlsx>
