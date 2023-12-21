(
    valor as number
)=>

let

  /*
    Script que simula o PROCV Aproximado de um valor númerico numa determinada lista, ou seja,
    o valor mais próximo o possível da variável númerica.
  */

//  x = 8,
    x = valor,

    Aliquotas = {0,4,7,12,17}, 
    Lista = List.Sort(Aliquotas & {x}), 

    Posicao = List.PositionOfAny(Lista,{x}),

    Proximos = 
        {
            try Lista{Posicao - 1} otherwise List.Min(Aliquotas), 
            try Lista{Posicao + 1} otherwise List.Max(Aliquotas)
        },

    out =

        try
            if   Number.Abs(x - Proximos{0}) <= Number.Abs(x - Proximos{1})
            then Proximos{0} 
            else Proximos{1} 
        otherwise 
            0    
            
in
    out
