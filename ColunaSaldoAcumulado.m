let
     /*
          Coluna de soma acumulada por meio dos parâmetros: conta e data.
     */     
     Fonte = Excel.CurrentWorkbook(){[Name = "Movimentos"]}[Content], 
     
     TipoAlterado = Table.TransformColumnTypes(
          Fonte, 
          {
               {"ContaID", Int64.Type}, 
               {"DATA", type datetime}, 
               {"MovimentoValor", Int64.Type}
          }
     ), 
     
     Buffer = Table.Buffer(TipoAlterado), 

     // Classificacao das linhas para o cálculo acumulado ficar correto.     
     LinhasClassificadas = Table.Sort(
          Buffer, 
          {
               {"ContaID", Order.Ascending}, 
               {"DATA", Order.Ascending}
          }
     ), 
     
     ColunaIndice = Table.AddIndexColumn(
          LinhasClassificadas, 
          "Linha", 
          1, 
          1
     ), 
     
     LinhasAgrupadasMinIndice = Table.Group(
          ColunaIndice, 
          {"ContaID"}, 
          {
               {"LinhaMin", each List.Min([Linha]), type number}
          }
     ), 
     
     ConsultasMescladas = Table.NestedJoin(
          ColunaIndice, 
          {"ContaID"}, 
          LinhasAgrupadasMinIndice, 
          {"ContaID"}, 
          "Linhas Agrupadas", 
          JoinKind.LeftOuter
     ), 
     
     LinhasAgrupadasExpandido = Table.ExpandTableColumn(
          ConsultasMescladas, 
          "Linhas Agrupadas", 
          {"LinhaMin"}, 
          {"LinhaMin"}
     ), 
     
     ColunaSaldoAcumulado = Table.AddColumn(
          LinhasAgrupadasExpandido, 
          "Soma", 
          each List.Sum(
               List.Range(
                    LinhasAgrupadasExpandido[MovimentoValor], 
                    [LinhaMin] - 1, 
                    [Linha] - [LinhaMin] + 1
               )
          ), 
          type number
     ), 
     
     SelecaoColunas = Table.SelectColumns(
          ColunaSaldoAcumulado, 
          {"Linha", "ContaID", "DATA", "MovimentoValor", "Soma"}
     )

in

     SelecaoColunas