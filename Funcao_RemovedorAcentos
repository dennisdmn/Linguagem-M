(Texto as text) =>

/*
ALFABETO UTF-8 RETIRADO DE:
https://www.utf8-chartable.de/unicode-utf8-table.pl

*/
let
    Letras = 
    //  Escolher quais caracteres deseja manter
        {
            " ", 
            "A", 
            "B", 
            "C", 
            "D", 
            "E", 
            "F", 
            "G", 
            "H", 
            "I", 
            "J", 
            "K", 
            "L", 
            "M", 
            "N", 
            "O", 
            "P", 
            "Q", 
            "R", 
            "S", 
            "T", 
            "U", 
            "V", 
            "W", 
            "X", 
            "Y", 
            "Z",
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "(",
            ")",
            "@",
            "/",
            "-",
            "+",
            ".",
            ",",
            ";",
            ":"
        },

    Substituir = 
    //  Escolher quais caracteres substiruir por quais
        {
            {"À","A"},
            {"Á","A"},
            {"Â","A"},
            {"Ã","A"},
            {"Ä","A"},
            {"È","E"},
            {"É","E"},
            {"Ê","E"},
            {"Ë","E"},
            {"Ì","I"},
            {"Í","I"},
            {"Î","I"},
            {"Ò","O"},
            {"Ó","O"},
            {"Ô","O"},
            {"Õ","O"},
            {"Ö","O"},
            {"Ù","U"},
            {"Ú","U"},
            {"Û","U"},
            {"Ü","U"},
            {"Ç","C"},
            {"Ñ","N"},
            {"&","E"},
            {"{","("},
            {"}",")"},
            {"[","("},
            {"]",")"}
        }
in
    Text.Select(
        Text.Combine(
            List.ReplaceMatchingItems(
                Text.ToList(
                    Text.Upper(Texto)
                ), 
                Substituir
            )
        )   
        ,Letras
    )
