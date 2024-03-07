require_relative '../lib/distribuir_com_variancia'


RSpec.describe DistribuirComVariancia do

    data_testes = [
        {total: 80, num: 20, variancia: 2, usar_inteiros: true},
        {total: 50, num: 20, variancia: 2},
        {total: 100, num: 20, variancia: 5},
        {total: 10, num: 1, variancia: 5, usar_inteiros: true},        
        {total: 10, num: 5, variancia: 2},
        {total: 160, num: 42, variancia: 2, usar_inteiros: true},
    ]

    repeticao = 1

    def criar_distribuicao(data_teste)
        total = data_teste[:total]
        num = data_teste[:num]
        variancia = data_teste[:variancia]
        usar_inteiros = data_teste[:usar_inteiros]
        DistribuirComVariancia.new(total,num,variancia, usar_inteiros)
    end

    describe '#Inicio' do
        it 'testar a criação da classe' do
            data_testes.each do |data_teste|                
                (1..repeticao).each do
                    distribuir = criar_distribuicao(data_teste)
                    expect(distribuir.soma_total).to eq(data_teste[:total])
                end
            end
        end

        it 'testar soma da geração da distribuição' do
            data_testes.each do |data_teste|
                (1..repeticao).each do
                    distribuir = criar_distribuicao(data_teste)
                    d = distribuir.gerar_distribuicao()                
                    expect(d.sum.round).to eq(distribuir.soma_total)                    
                end
            end
        end

        it 'testar o min valor ' do             
            data_testes.each do |data_teste|
                (1..repeticao).each do
                    distribuir = criar_distribuicao(data_teste)
                    min = distribuir.get_min            
                    d = distribuir.gerar_distribuicao()            
                    expect(d.min).to be >= min
                end
            end
        end

        it 'testar o max valor' do             
            data_testes.each do |data_teste|
                (1..repeticao).each do
                    distribuir = criar_distribuicao(data_teste)
                    max = distribuir.get_max
                    d = distribuir.gerar_distribuicao()            
                    expect(d.max).to be <= max
                end
            end
        end

    end

end
