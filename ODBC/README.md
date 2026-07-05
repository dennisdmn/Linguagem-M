# ODBC

Receitas de Power Query M para conexoes via ODBC.

## Access para dBASE/DBF e Power Query

Arquivos:

- [`Access_dBASE_PowerQuery.m`](./Access_dBASE_PowerQuery.m)

Conteudo migrado do manual `Manual_Access_dBASE_PowerQuery.pdf`, que estava no Google Drive.

## Objetivo

Exportar uma tabela ou consulta do Microsoft Access para `.dbf`, configurar o DSN ODBC `dBASE Files` e importar o arquivo no Power Query do Excel M365.

## Quando usar

Use este fluxo quando:

- voce tem uma base `.accdb` no Access;
- precisa consumir os dados no Excel/Power Query;
- a rota via exportacao `.dbf` e DSN ODBC e mais simples ou mais compativel no ambiente;
- os drivers ODBC de dBASE estao disponiveis no Windows.

## Passo a passo

### 1. Exportar DBF no Access

1. Abra o arquivo `.accdb` no Microsoft Access.
2. Selecione a tabela ou consulta desejada.
3. Va em `Dados Externos` > `Mais` > `Arquivo dBASE`.
4. Escolha uma pasta de destino, por exemplo `C:\DBASE`.
5. Salve com um nome simples, por exemplo `MinhaTabela.dbf`.
6. Se houver escolha de versao, use dBASE IV/5.0 quando compativel.

### 2. Configurar o DSN ODBC

1. Abra o Administrador de Fontes de Dados ODBC do Windows.
2. Use a versao 32 ou 64 bits conforme o bitness do Office instalado.
3. Em `DSN de Usuario` ou `DSN de Sistema`, selecione `dBASE Files`.
4. Clique em `Configurar`.
5. Desmarque `Usar Diretorio Atual`.
6. Selecione a pasta onde estao os `.dbf`, por exemplo `C:\DBASE`.
7. Confirme e feche o administrador ODBC.

### 3. Importar no Power Query

No Excel:

1. Va em `Dados` > `Obter Dados` > `De Outras Fontes` > `ODBC`.
2. Escolha o DSN `dBASE Files`.
3. No Navegador, selecione a tabela correspondente ao arquivo `.dbf`.
4. Clique em `Transformar Dados`.

## Exemplo M

```m
let
    Fonte = Odbc.Query(
        "dsn=dBASE Files",
        "SELECT * FROM MinhaTabela"
    ),

    Tipos = Table.TransformColumnTypes(
        Fonte,
        {
            {"Data", type date},
            {"Quantidade", Int64.Type}
        }
    )
in
    Tipos
```

## Boas praticas

- Use nomes de campos curtos, preferencialmente ate 10 caracteres.
- Evite acentos, espacos e caracteres especiais nos nomes de campos.
- Mantenha o bitness do Office e do driver ODBC alinhados: tudo 32 bits ou tudo 64 bits.
- Padronize uma pasta para os arquivos `.dbf`, como `C:\DBASE`.
- Depois de exportar ou alterar arquivos `.dbf`, atualize a pre-visualizacao no Navegador ou reabra o Excel.
- Sempre revise tipos de dados apos a importacao, principalmente datas e numeros.

## Observacoes

- O nome usado no `SELECT` normalmente corresponde ao nome do arquivo `.dbf` sem a extensao.
- Se o ambiente permitir, avalie tambem conectar diretamente ao Access ou usar outro formato intermediario mais moderno. Este fluxo e util quando a compatibilidade com dBASE/ODBC e o caminho mais pratico.
