(
    tabela as table,
    coluna_pivotada as list
)=>

let
    /*
        Script alternativo para não perder performance na substituição da classificação crescente
        ou decrescente antes de utilizar a pivotagem de uma determinada coluna com a criação de uma lista.

        Obs.:   Com a criação de uma etapa/variável antes da pivotagem e incluindo-a em um dos argumentos
                da "Table.Pivot" o ganho de performance, dependendo da qtde de dados é RELEVANTE.
    */

    Fonte = tabela,
    
    /* 
        Cria uma lista distintas em ordem crescente dos meses e 
        transforma cada registro da lista em texto para cabeçalhos da pivotangem.
    */
    FuturasColunas = 
        List.Buffer(
            List.Transform(
                List.Sort(
                    List.Distinct(coluna_pivotada)
                ), each Text.From(_)
            )
        ),

    /* 
        Efetua a pivotagem das linhas NUM_MESES em colunas aplicando a operação de soma
        nos registros da ex-coluna QTD.
    */
    ColunaPivo = 
        Table.Pivot(
            Table.TransformColumnTypes(Fonte, {{"MES_NUM", type text}}, "pt-BR"),
            FuturasColunas,
            "MES_NUM",
            "QTD",
            List.Max
        )

in
    
    ColunaPivo
