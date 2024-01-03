let
    Fonte = Sql.Database("localhost", "adventureworksdw2016", [Query="

        SELECT * FROM DimEmployee

    "]),
    
    /*  QtdLinhas é um parâmetro com valor inteiro para restrigir o nº de linhas com
        o intuito de facilitar o upload do modelo para o Power BI Service.
    */ 
    PrimeirasLinhasMantidas = if QtdLinhas = null then Fonte else Table.FirstN(Fonte,10)

in

    PrimeirasLinhasMantidas
