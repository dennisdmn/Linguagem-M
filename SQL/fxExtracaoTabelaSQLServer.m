(
    NomeServidor as text,
    NomeBancoDados as text,
    NomeTabelaSQL as text,
    NomeColunaDataTabelaSQL as text
)=>

let

    /*
        Linguagem M - Script estruturada para conexão a base de dados em servidor SQL Server. 
    */

    NomeServidor = "LOCALHOST",
    NomeBancoDados = "ContosoRetailDW",
    NomeTabelaSQL = "dCalendario",
    // Variável com o nome da coluna de data usada no código SQL.    
    NomeColunaDataTabelaSQL = "AnoMes",  
    // Variável externa a este script para escolha da data inicial.
    DataInicial = Date.ToText(vDataIni, "yyyyMMdd"),
    // Variável externa a este script para escolha da data final.
    DataFinal = Date.ToText(vDataFim, "yyyyMMdd"),
    // Variável que utiliza parâmetro externo ao script para a seleção das primeiras linhas em caso de projeto não finalizado. 
    Finalizado = pEmDesenvolvimento,

    // Comando SQL para extração de dados no SQL Server.
    ComandoSQL = "
    
        SELECT "& (if Finalizado = "SIM" then " TOP 10 " else " ") &"
            *
        FROM "& NomeTabelaSQL &"
        WHERE 
                "& NomeColunaDataTabelaSQL &" >= "& DataInicial &"
            AND "& NomeColunaDataTabelaSQL &" <= " & DataFinal & "  
            
    ",   

    // Aplicação do comando SQL. 
    Fonte = Sql.Database(
        NomeServidor, 
        NomeBancoDados, 
        [
            // Chamando o código SQL da variável: ComandoSQL.
            Query=ComandoSQL, 
            CommandTimeout=#duration(0, 2, 0, 0)
        ]
    ),
    
    // Alterou-se para texto, pois se fizesse direto para date daria erro.
    TipoAlteradoTexto = Table.TransformColumnTypes(Fonte,
        {
            {NomeColunaDataTabelaSQL, type text}
        }
    ),

    TipoAlteradoDate = Table.TransformColumnTypes(TipoAlteradoTexto,
        {
            {NomeColunaDataTabelaSQL, type date}
        }
    ),

    // Bufferização dos dados carregados.
    BufferTable = Table.Buffer(TipoAlteradoDate)

in

    BufferTable
