class DistribuirComVariancia

    attr_accessor :soma_total, :num_partes, :variancia, :usar_inteiros

    
    def initialize(soma_total, num_partes, variancia, usar_inteiros = false)
        @soma_total = soma_total
        @num_partes = num_partes
        @variancia = variancia.abs
        @usar_inteiros = usar_inteiros
    end

    def get_min()
        min = (Float(soma_total / num_partes) - variancia)
        (usar_inteiros)? min.floor : min
    end

    def get_max()
        max = (Float(soma_total / num_partes) + variancia)
        (usar_inteiros)? max.ceil : max

    end

    def gerar_distribuicao(arredondamento = 60)        
        min_valor = get_min
        max_valor = get_max
        partes = Array.new(num_partes) {min_valor}
        valor_remanecente = soma_total - partes.sum        
        while valor_remanecente > 0 do            
            extra = Float((rand * (variancia) * arredondamento).round) / arredondamento
            extra = (usar_inteiros) ? extra.round : extra            
            extra = (valor_remanecente < variancia)? valor_remanecente : extra            
            id_parte = rand(num_partes)
            if ((partes[id_parte] + extra) <= max_valor) && ((valor_remanecente - extra) >= 0)                
                partes[id_parte] += extra
                valor_remanecente -= extra
            end
        end        
        partes
    end
end