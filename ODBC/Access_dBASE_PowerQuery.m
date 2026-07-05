// Access -> dBASE/DBF -> Power Query via ODBC
//
// Pre-requisito:
// Configurar o DSN ODBC "dBASE Files" apontando para a pasta onde os
// arquivos .dbf foram exportados pelo Microsoft Access.
//
// Ajuste o nome da tabela no SELECT conforme o nome do arquivo .dbf
// sem a extensao. Ex.: MinhaTabela.dbf -> SELECT * FROM MinhaTabela

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
