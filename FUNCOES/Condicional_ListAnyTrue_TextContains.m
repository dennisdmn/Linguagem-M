// Exemplo: coluna condicional com List.AnyTrue + Text.Contains
//
// Cenario:
// Classificar uma linha em grupos diferentes conforme a coluna [Assigned to]
// contenha qualquer nome de uma lista.

let
    Fonte = #table(
        type table [Ticket = text, AssignedTo = text],
        {
            {"T001", "John Smith"},
            {"T002", "Mary Johnson"},
            {"T003", "Analyst Team"},
            {"T004", "Jane Doe"},
            {"T005", null}
        }
    ),

    Grupos = [
        Grupo1 = {"John", "Jane", "Sean"},
        Grupo2 = {"Mary", "Pete"}
    ],

    ClassificaResponsavel = (responsavel as nullable text) as text =>
        let
            Texto = if responsavel = null then "" else responsavel,
            ContemAlgum = (lista as list) as logical =>
                List.AnyTrue(
                    List.Transform(
                        lista,
                        (item) => Text.Contains(Texto, item, Comparer.OrdinalIgnoreCase)
                    )
                ),
            Resultado =
                if ContemAlgum(Grupos[Grupo1]) then "Group 1"
                else if ContemAlgum(Grupos[Grupo2]) then "Group 2"
                else "Group 3"
        in
            Resultado,

    Resultado =
        Table.AddColumn(
            Fonte,
            "Assigned Group",
            each ClassificaResponsavel([AssignedTo]),
            type text
        )
in
    Resultado
