require 'date'
require 'time'

require_relative 'distribuir_com_variancia'

class Horario

    attr_accessor :mes, :ano, :periodos, :feriados
    

    def initialize(ano, mes, periodos, feriados = [])        
        @ano = ano
        @mes = mes        
        @periodos = periodos        
        @feriados = feriados
        @dias_no_mes = Date.new(ano, mes, -1).day
        @inicio_do_mes = Date.new(ano, mes, 1)
        @final_do_mes = Date.new(ano, mes, @dias_no_mes)
        @dias_uteis = contar_dias_uteis      
    end

    def gerar_programacao(total_horas, variancia, minutos)
        programacao =  {}
        arredondamento = 60 / minutos
        num_periodos = periodos.length
        puts "Num Periodos: #{num_periodos}"
        total_periodos = num_periodos * @dias_uteis
        puts "Total Periodos: #{num_periodos}"
        var_duracao = dividir_com_variancia(total_horas, total_periodos, variancia, arredondamento)
        puts "Duração total: #{var_duracao.sum}"

        puts var_duracao.to_s
        i = 0        
        (@inicio_do_mes..@final_do_mes).each do |dia|            
            programacao[dia] ||= []
            next if [6, 0].include?(dia.wday) || feriados.include?(dia)
            periodos.each do |intervalo|
                programacao[dia] << gerar_horario(intervalo, dia.day, var_duracao[i], minutos)                
                i += 1
            end
        end 
        programacao
    end

    private

        def dividir_com_variancia(valor_total, num_partes, variancia, arredondamento)
            distribuir = DistribuirComVariancia.new(valor_total, num_partes, variancia, arredondamento)
            distribuir.gerar_distribuicao()
        end

        def contar_dias_uteis()
            total = 0
            data_atual = @inicio_do_mes
            while data_atual <= @final_do_mes
                unless [6,0].include?(data_atual.wday) || feriados.include?(data_atual)
                    total += 1
                end
                data_atual += 1
            end
            total
        end

        def get_seg_inicial_final(intervalo, dia)
            tempo_inicial = Time.parse("#{@ano}-#{@mes}-#{dia} #{intervalo.first}").to_i
            tempo_final = Time.parse("#{@ano}-#{@mes}-#{dia} #{intervalo.last}").to_i
            [tempo_inicial, tempo_final]
        end

        def tempo_para_segundo(tempo)
            tempo.to_i
        end

        def segundo_para_tempo(segundos)
            Time.at(segundos).strftime("%H:%M")            
        end

        def gerar_horario(intervalo, dia, duracao_em_horas, minutos)            
            tempo_inicial, tempo_final = get_seg_inicial_final(intervalo, dia)
            segundo_inicial = tempo_para_segundo(tempo_inicial)
            segundo_final = tempo_para_segundo(tempo_final)
            intervalo_segundos = segundo_final - segundo_inicial
            duracao_segundos = (duracao_em_horas * 3600).round
            margem_restante_segundos = (intervalo_segundos - duracao_segundos)
            deslocamento_segundos = (rand * (margem_restante_segundos) / (minutos * 60)).round * (minutos * 60)
            resultado_tempo_inicial = segundo_para_tempo(segundo_inicial + deslocamento_segundos)
            resultado_tempo_final = segundo_para_tempo(segundo_inicial + deslocamento_segundos + duracao_segundos)
            [resultado_tempo_inicial, resultado_tempo_final]
        end
    end