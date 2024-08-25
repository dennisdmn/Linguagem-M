( tabela as table ) => 
let

    // Passo 1: Definir a tabela de origem
    Fonte = tabela,
    
    // Passo 2: Verificar se as colunas "A" e "B" existem
    ColunasExistentes = Table.ColumnNames(Fonte),

    ColunasNecessarias = 
        {
              "COD_ATIVO"
            , "ITEM_PAI"
            , "DESCRICAO"
            , "SERIAL_NUMBER" 		
            , "STATUS_ATIVOS" 		
            , "STATUS_VOKE" 			
            , "GRUPO_ATIVO" 			
            , "COD_CLIENTE" 			
            , "NOME_CLIENTE" 			
            , "NUM_PV" 				
            , "ATIVO_SUPORTE" 		
            , "CONTR_FAT" 			
            , "COD_EMPRESA" 			
            , "COD_DEPTO" 			
            , "UTILIZACAO" 			
            , "TIPO" 					
            , "NUM_PRIMARIO" 			
            , "NF" 					
            , "CLIENTE_CONTR" 		
            , "GRP_ECONOMICO" 		
            , "BOARD_GE" 				
            , "RAZAO_SOCIAL" 			
            , "ULT_FATURA" 			
            , "PRIMARIO_FATURA_1" 	
            , "COD_FATURA" 			
            , "REMANEJAMENTO" 		
            , "TIPOS_REMANEJAMENTO" 	
            , "TIPOS_ATIVACAO"		
            , "CONTR_NOME"
        },

    ColunasPresentes = List.Intersect({ColunasExistentes, ColunasNecessarias}),
    
    // Passo 3: Se as colunas existirem, substituir "null" por "N/D"
    Resultado = 
        if  List.Count(ColunasPresentes) > 0 then
            Table.ReplaceValue(
                Fonte, 
                null, 
                "N/D", 
                Replacer.ReplaceValue, 
                ColunasPresentes
            )
        
        else Fonte

in

    Resultado
