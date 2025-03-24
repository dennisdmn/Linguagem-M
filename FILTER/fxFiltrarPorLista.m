// fxFiltrarPorListaGenerica
// Filtra uma tabela com base em uma lista de valores, usando uma coluna definida dinamicamente

fxFiltrarPorListaGenerica = 
  (
        Tabela as table
      , ListaValores as list
      , ColunaNome as text
  ) as table =>
let
    TabelaFiltrada = Table.SelectRows(
        Tabela,
        each List.Contains( ListaValores, Record.Field( _, ColunaNome ) )
    )
in
    TabelaFiltrada
