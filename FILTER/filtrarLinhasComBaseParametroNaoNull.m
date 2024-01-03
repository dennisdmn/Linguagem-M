let
    ValorParametro = null, // Defina o valor do parâmetro aqui

    // Defina a função personalizada que aceita o parâmetro
    FiltrarPorDocumento = (TipoAlterado, ValorDocumento) =>
        if ValorDocumento = null then
            TipoAlterado
        else
            Table.SelectRows(TipoAlterado, each [documento] = ValorDocumento),

    // Chame a função personalizada com o parâmetro
    Resultado = FiltrarPorDocumento(TipoAlterado, ValorParametro)
in
    Resultado
