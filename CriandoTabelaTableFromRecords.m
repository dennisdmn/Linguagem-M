let
    /*
        
    */

    FeriadosFixos = Table.FromRecords(
                {
                    [Tipo = "Confraternização Universal",               AnoMes = "0101"],
                    [Tipo = "Tiradentes",                               AnoMes = "0421"],
                    [Tipo = "Dia do Trabalhador",                       AnoMes = "0501"],
                    [Tipo = "Dia da Pátria (Independência do Brasil)",  AnoMes = "0907"],
                    [Tipo = "Nossa Senhora Aparecida",                  AnoMes = "1012"],
                    [Tipo = "Finados",                                  AnoMes = "1102"],
                    [Tipo = "Proclamação da República",                 AnoMes = "1115"],
                    [Tipo = "Natal",                                    AnoMes = "1225"]
                }
            )

in
    FeriadosFixos