module Projecto  where
import System.Environment (getArgs)
import System.Random (getStdGen,randomRs) -- queremos só este 2 metodos
import Data.List (intercalate)
import Text.Printf (printf)
import System.IO (hFlush,stdout)
import Test.QuickCheck
import Types
import Maths
import Net

-- o io le as cenas no terminais comandos
main :: IO ()
main = do

        args <- getArgs  -- pega oque colocamos a frente de ./projecto no terminal

        -- Para testar  :main <primeira String que está
        case args of
            ["--train", ficheiro] -> treinoRede ficheiro -- treino da rede
            ["--predict",ficheiro] -> predictMode ficheiro   -- o predict 
            ["--test"]             -> testMode               -- e o teste
            _                      -> putStrLn "Erro: Comando invalido. Tente --train <fich>, -predict <fich> ou --test"


            {- if (args.length == 2 && args[0].equals("--train")) {
                String ficheiro = args[1];
                trainMode(ficheiro); -- java
                em haskel com  if statments
                main :: IO ()
                main = do
                args <- getArgs 
                if length args == 2 && args !! 0 == "--train"
                    then trainMode (args !! 1)
                    else if length args == 2 && args !! 0 == "--predict"
                        then predictMode (args !! 1)
                    else if length args == 1 && args !! 0 == "--test"
                        then testMode
                        else putStrLn "Erro: Comando invalido."
            -} -- em java mas em haskel fazemos com pattern matching ou assim só que fica bem feio



-- WARNING--- treinar a rede copy paste ":main --train pesos.txt" vai gerar um fichero com os pesos


--Modos de execução  (Funções Impuras - IO)  file 
treinoRede:: String  -> IO () -- 
treinoRede ficheiro = do
    putStrLn $ "Modo treino onn . Guardando em " ++ ficheiro

    -- Pede o sistema para gerar  um gerador de aleatorio numbers --em java new Random ()
    gen <- getStdGen

    --Criar uma lista infinita de números decimais entre  -1.0 e 1.0
    let primeirosPesos = randomRs (-1.0, 1.0) gen

    -- Rede não treinada com 2 entradas -> camada ocultas com 4 neuronios -> camada de saída com 1 output (respota final)
    let dumbNet = buildNetwork 2 [4,1] primeirosPesos

    let inputXor  = [[0,0],[0,1],[1,0],[1,1]]
    let outputXor = [[0],[1],[1],[0]]

    let dataset   = (inputXor, outputXor)

    putStrLn "A treinar a rede.... old on mate"

    let smartNet = training 100000 0.1 dataset dumbNet

    --putStrLn "Treino concluido! Estrutura final da rede:"
    -- print smartNet -- para ver como que que layers e bias ficaram testes
    
    --Guardar a rede no ficheiro
    let cerebroEmTexto = show smartNet
    writeFile ficheiro cerebroEmTexto
    putStrLn $ "Pesos guardados em " ++ ficheiro


    --fazer a previsão real
    let previsoes = map (\interator -> last (forwardPass interator smartNet)) inputXor
    
    
    --calcular o erro final MSE
    let finalError = msePredictions previsoes outputXor

    --formatar os números com 5 casas decimais

    let formatarLista nums = "[" ++ intercalate ", " (map (printf "%.5f") nums) ++ "]" -- o printf serve sõ p
    let formatarPar (p, t)  = "(" ++ formatarLista p ++ ", " ++ formatarLista t ++  ")"

    -- juntar os 4 pares numa só linha

    let paresFormatados = map formatarPar (zip previsoes outputXor)
    putStrLn $ "[" ++ intercalate ", " paresFormatados ++ "]"


    {-- cod para arredondar para 5 casas decimais 0.0001643 -> 0.00016
    arredondar5 :: Double -> Double
    arredondar5 x = fromIntegral (round (x * 100000)) / 100000-} 


    --Imprimir o MSE
    putStrLn $ "MSE: " ++ show finalError


-- :main --predict ficheiro.txt"

predictMode :: String -> IO()
predictMode ficheiro = do
    -- ler o ficheiro da rede esperta e reconstruir
    conteudo <- readFile ficheiro
    let redeTreinada = read conteudo :: Network -- lê para uma rede


    --2 Pedir e ler o Input
    putStr " Input1: "
    hFlush stdout

    input1Str <- getLine
    let input1 = read input1Str :: Double -- lê para um double

    -- pedir e ler o 2 input

    putStr "Input2: "
    hFlush stdout
    input2Str <- getLine
    let input2 = read input2Str :: Double

    -- fazer a previsão da rede esperta

    let inputer = [input1, input2]

    let previsaofinal = last (forwardPass inputer redeTreinada)

    let outputArrendondado = map round previsaofinal :: [Int]

    putStrLn $ "Output: " ++ show outputArrendondado


--propriedades do quickCheck-------------------------------------------

--1 propriedade a estrutura nr de camdas, nr de neuronios e pesos tem de ficar iguais
prop_estrutura :: [Double] -> Bool
prop_estrutura pesosAleatorios = 
            estrutura redeOriginal == estrutura redeTreinada
            where
                pesosValidos = pesosAleatorios ++ [1..20]
                redeOriginal = buildNetwork 2 [4, 1] pesosValidos
                testefalso = ([[0, 0]], [[0]]) 
                redeTreinada = training 1 0.1 testefalso redeOriginal

-- função auxiliar que compara a estura de duas redes
-- Devolve uma lista com o tamanho dos pesos de cada camada
estrutura :: Network -> [[Int]]
estrutura net  = map (\layer -> map length (weights layer )) net


--2 propriedade
--  A camada de saida tem de ter exatamente o mesmo número de elementos que o output final. 1
prop_tamanhoOutput :: [Double] -> Double -> Double -> Bool
prop_tamanhoOutput pesosAleatorios i1 i2 =
    let pesosValidos = pesosAleatorios ++ [1..20]
        rede = buildNetwork 2 [4,1] pesosValidos
        entrada = [i1, i2]
        saida = last (forwardPass entrada rede)
    in length saida == 1

--Proprieadades 3:
-- Erro (MSE)  de uma lista comparada  exatamente com ela própria tem de ser sempre 0.0
pro_mse0 :: [Double] -> Property
pro_mse0 previsao = not (null previsao) ==> mse previsao previsao == 0.0

-----------------------------------------------------------------------------
--quickcheck
-- :main --test

testMode :: IO ()
testMode  = do
    quickCheck prop_estrutura
    quickCheck prop_tamanhoOutput
    quickCheck pro_mse0



