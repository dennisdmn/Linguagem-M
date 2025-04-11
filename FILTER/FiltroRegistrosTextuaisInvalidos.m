// 📦 Função personalizada para validar e filtrar registros com termos inválidos em qualquer coluna de texto
// Parâmetros:
//   - tabela: tabela de entrada
//   - nomeColuna: nome da coluna onde será aplicada a validação
// Retorno: tabela filtrada com registros inválidos

let
    fnFiltrarTextoInvalido = (tabela as table, nomeColuna as text) as table =>
    let
        // 🧾 Lista de termos que indicam registros inválidos (case-insensitive)
        TermosInvalidos = {
              "LTDA"
            , "LIMITADA"
            , "LTDA."
            , "S\A"            
            , "S.A."
            , "S/A"            
        },

        // 🔍 Aplicação do filtro: nulo ou contém algum termo da lista (insensitive)
        TabelaFiltrada = Table.SelectRows(
            tabela,
            each 
                Record.Field(_, nomeColuna) = null 
                or List.AnyTrue(
                    List.Transform(
                        TermosInvalidos,
                        (termo) =>
                            Text.Contains(
                                Text.Upper(Record.Field(_, nomeColuna)), 
                                Text.Upper(termo)
                            )
                    )
              )
        )
    in
        TabelaFiltrada
in
    fnFiltrarTextoInvalido
