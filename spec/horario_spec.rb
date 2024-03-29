require_relative '../lib/horario.rb'

(ano, mes, periodos, feriados = [])
(soma_total, num_partes, variancia, usar_inteiros = false)
horarios_testes = [
    {
        ano: 2024, 
        mes: 02, 
        periodos:[["17:45","22:00"]], 
        feriados: [12, 13, 14], 
        soma_total: 80, 
        variancia: 1, 
        minutos: 5
    }
]


RSpec.describe Horario do

    def criar_horario(teste)
        ano = teste[:ano]
        mes = teste[:mes]
        periodos = teste[:periodos]
        feriados = teste[:feriados]
        soma_total = teste[:soma_total]
        variancia = teste[:variancia]
        minutos = teste[:minutos]
        horario = Horario.new(ano, mes, periodos, feriados)
        programacao = horario.gerar_programacao(soma_total, variancia, minutos)
        programacao
    end

    describe '#Inicio' do
        it 'testa a criação da classe' do
            puts "\n\n"
            horarios_testes.each do |teste|
                programacao = criar_horario(teste)
                programacao.each do |dia, freq|
                    # puts "Dia: #{dia.to_s} => Freq: #{freq.to_s}"
                    puts "#{dia.day}/#{dia.month}/#{dia.year},#{freq.join(",")}"
                end                
            end
        end
    end
end