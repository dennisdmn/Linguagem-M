let

    /*
        Script modelo para filtro de tabela por meio de uma lista.
    */

    ListaContasContabeis = {
                            "3110101",
                            "3110102",
                            "3110103",
                            "3110105",
                            "3110106",
                            "3110109",
                            "3110202",
                            "3110203",
                            "3110301"
                        },

    FiltroPorLista = Table.SelectRows(CT2.SelecaoColunas, 
        each List.Contains(ListaContasContabeis,[CT2.CTA]) = true
    )

in

    FiltroPorLista