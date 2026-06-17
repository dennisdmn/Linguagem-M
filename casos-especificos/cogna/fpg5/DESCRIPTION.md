# Descrição estendida — fxTrataFPG5

## Contexto

A `fxTrataFPG5` é uma função específica para tratamento de extrações FPG5 utilizadas em rotinas de análise e conciliação. O foco é transformar uma tabela bruta em uma estrutura mais estável para uso em ETL, validações, cruzamentos contábeis e análises posteriores.

## Escopo

A função cobre exclusivamente o tratamento da tabela de entrada. Ela não executa importação de pasta, leitura de arquivo ou consolidação de múltiplos arquivos.

O desenho foi mantido assim porque a função funcionou plenamente de maneira isolada e evita acoplamento com lógicas de importação que podem variar conforme a origem dos dados.

## Regras aplicadas

### 1. Promoção de cabeçalhos

A função assume que a primeira linha útil da tabela contém os nomes reais dos campos da FPG5 e aplica:

```powerquery
Table.PromoteHeaders(Fonte, [PromoteAllScalars = true])
```

### 2. Filtro de linhas válidas

São mantidas apenas linhas em que:

- `Cont.regs.` não é nulo;
- `Cont.regs.` não é vazio após conversão para texto e remoção de espaços;
- `ChvReconc.` é diferente de `ChvReconc.`, evitando cabeçalhos repetidos no corpo da base.

### 3. Seleção de colunas

A função mantém apenas os campos considerados relevantes para o layout tratado da FPG5.

Essa seleção também protege o resultado contra colunas excedentes vindas da extração original.

### 4. Tipagem

Os tipos aplicados são:

| Campo original | Tipo aplicado |
|---|---|
| `ChvReconc.` | `type text` |
| `Nº documento` | `type text` |
| `Divisão` | `type text` |
| `Moeda` | `type text` |
| `CódImposto` | `type text` |
| `Segmento` | `type text` |
| `Cen.lucro` | `type text` |
| `Cont.regs.` | `Int64.Type` |
| `Itm` | `Int64.Type` |
| `Empr.` | `Int64.Type` |
| `Cta.Razão` | `Int64.Type` |
| `Data doc.` | `type date` |
| `Montante` | `type number` |
| `Base do imposto` | `type number` |

A cultura padrão é `pt-BR`, mas pode ser alterada pelo segundo parâmetro da função.

### 5. Cabeçalho em cobrinha

Depois da tipagem, os campos são renomeados para `snake_case`. O renomeio é explícito, e não automático, porque alguns campos do layout FPG5 não possuem separadores naturais suficientes para conversão segura, como `ChvReconc.`.

## Decisão técnica importante

A função mantém o renomeio para `snake_case` somente após seleção e tipagem dos campos originais. Essa ordem foi escolhida porque o layout original contém nomes com pontos, acentos e abreviações específicas do SAP/FPG5.

Fluxo usado:

```text
Tabela bruta
→ promover cabeçalhos
→ filtrar linhas válidas
→ selecionar colunas originais
→ aplicar tipos
→ renomear para snake_case
```

## Saída esperada

A saída final já está preparada para uso em consultas posteriores, com nomes de colunas padronizados:

```text
chv_reconc
cont_regs
n_documento
itm
empr
divisao
cta_razao
data_doc
montante
base_do_imposto
moeda
cod_imposto
segmento
cen_lucro
```

## Status

Função validada pelo usuário em Power Query M e registrada como referência confiável para casos específicos da Cogna relacionados à FPG5.
