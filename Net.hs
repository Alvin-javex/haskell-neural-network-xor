module Net where 

import Maths
import Types

--A função BuildNetWork contrói a rede a partir do tamanho da entrada, da lista de tamanhos das camada e de uma lista(Potenciamente infinita) de valores iniciais para os pesos.
buildNetwork :: Int -> [Int] -> [Double] -> Network
-- Int : Número de inputs
--[Int]: Quantos neurónios tem cada camada
-- [Double] : é uma lista infinita de números gerados aleatoriamente para preencher as matrizes dos pesos e dos vetores bias
buildNetwork _ [] _ = []
buildNetwork nInput (nNeuronio : pNeuronio) pesos =
      camadaAtual : buildNetwork nNeuronio (pNeuronio) restoDosPesos
      where
            --quantidade de elementos na camada
            numPesos = nNeuronio * nInput
            -- numero de neuronios na camada
            numBias = nNeuronio
            --quantidade de elementos na camada
            pesoCamada = take numPesos pesos
            -- quantidade de bias na camada
            biasCamada= take numBias (drop numPesos pesos)
            restoDosPesos = (drop (numPesos + numBias) pesos)
            -- construção final da camada
            camadaAtual= Layer (chunksOf nInput pesoCamada) biasCamada

--Exemplo de de uma cada camada , o que nós vamos fazer aqui é criar varias camadas  [Layers] -> que é a network
--   -- CAMADA 1
--   Layer { 
--     weights = [[0.1, 0.2], [0.3, 0.4], [0.5, 0.6], [0.7, 0.8]], 
--     bias = [0.9, 1.0, 1.1, 1.2] 
--   },
  
--   -- CAMADA 2
--   Layer { 
--     weights = [[1.3, 1.4, 1.5, 1.6]], <- o chunks of deixa isso neste estado
--     bias = [1.7] 
--   }


backPropagation :: Double -> [Double] -> [Double] -> Network -> Network
backPropagation taxaAprendizagem input outputesperado net =  reverse redeAtualizada

      where
            -- ver todos outputs
            historico = forwardPass input net
            
            previsaoFinal  = last historico


            --Isso faz a conta da (Previsao - outputesperado) Meio que queremos saber o quanto nós erramos
            deltaSaida =  outputError previsaoFinal outputesperado


            --Como queremos andar para trás o mais facil aqui é usar o reserve assim podemos andar para trás e corrigir os erros
            camadasInversas  = reverse net


            historicoInverso =  reverse historico

            redeAtualizada = backUpdater deltaSaida camadasInversas historicoInverso

            --  uma recursão com layers e outputlayer invertidos para para ser  mais facil

            backUpdater _ [] _ = []                           
            backUpdater deltaAtual (Layer w b :restoCamadas) ( _ : inputCamada : restoHist) =

                        --fazer a matriz transposta e multiplicar pelo vetor de erros
                  let   passarErro = multMatrix (transpose w) deltaAtual
                        
                        --ver a sensibildade dos inputs da camada no primeiro caso é o output da camada anterior vamos aplicar a derivada do sigmoid para saber a sensibidade dos input
                        sensibilidade = map (\x -> sigmoid' x) inputCamada 
                        
                        -- Essa parte aqui 
                        gradientedoPeso  = map (\d -> map (*d) inputCamada) deltaAtual   -- vamos ter vetores dos gradientes para cada neuronio

                        --novosPesos = w - (taxaPrendizagem * gradientedoPeso)
                        novosPesos =  zipWith (\linhaW linhaG -> zipWith (\peso grad -> peso - taxaAprendizagem * grad) linhaW linhaG ) w gradientedoPeso

                        --novos bias  b - (taxaAprendizagem * deltaAtual)
                        novosBias  =  zipWith (\bias delta -> bias - taxaAprendizagem * delta) b deltaAtual
                        
                        --Proximo erro bruto
                        proximoDelta =  zipWith (*) passarErro sensibilidade
                  
                  
                  in (Layer novosPesos novosBias) : backUpdater proximoDelta restoCamadas (inputCamada:restoHist)



forwardPass :: [Double] -> Network -> [[Double]]
forwardPass xs [] = [xs]
forwardPass xs (Layer w b :net)  = xs : forwardPass ativacao net
      where
            passo1 = multMatrix w xs

            passo2 = somaVectorial passo1 b

            ativacao = map sigmoid passo2


training :: Int -> Double ->([[Double]],[[Double]]) -> Network -> Network
--int -- o número de interações para a rede aprender
--Double a taxa de atualização
-- entradas é: [[0,0], [0,1], [1,0], [1,1]] -- são vetores  de vetores de tamanho 2  para resolver o problema do xor
-- saidas é: [[0], [1], [1], [0]] -- aqui temos a entrada

training n taxaAprendizagem (entradas,saidas) net
      |n <= 0 = net                                            -- a rede atualizada dps do back propagation vai ser o novo acc
      |otherwise = foldl (\acc (input, output) -> backPropagation taxaAprendizagem input output acc) net endlessXorforTraining -- aqui a rede vai ser foldada ou seja dobradamente aprendida
      where 
            -- Juntar as entradas e saidas para poder ver o o valor posto e o esperado para podermos usar o backProbagation
            -- exemplozinho [([0,0], [0]), ([0,1], [1])...] fst é o input e snd é o valor esperado 
            xor = zip entradas saidas

            -- uma lista infinita  a repetir esses pares e cortarmos com o take de algo neste caso é o n
            endlessXorforTraining  = take n (cycle xor)  --

