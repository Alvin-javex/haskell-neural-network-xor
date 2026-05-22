module Maths where



-- |Divide uma lista em grupos de tamanho n.
-- Exemplo: chunksOf 2 [1,2,3,4,5] == [[1,2],[3,4],[5]]
chunksOf :: Int -> [a] -> [[a]]
chunksOf n _ | n <= 0 = [[]]
chunksOf _ [] = [[]]
chunksOf n xs = aux n xs
            where aux _ [] = []
                  aux n xs = take n xs : aux n (drop n xs)

-- | Transpõe uma matriz (troca linhas por colunas).
-- Exemplo: transpose [[1,2],[3,4],[5,6]] == [[1,3,5],[2,4,6]]
transpose :: [[a]]-> [[a]]
transpose xs= [[x !!i | x<- xs]| i<- [0 .. length ( head xs)-1]]



-- | Multiplica uma matriz por um vetor: y[i] = sum(W[i][j]* x[j]).
-- Exemplo: multMatrix [[1,0],[0,1]] [3,4] == [3,4]
multMatrix :: [[Double]] -> [Double] -> [Double]
multMatrix [] _ = []
multMatrix  (x:xs) y =  test x y : multMatrix xs y
--Essa  é a função auxiliar  ela meio que ela recebe 2 vetores  e faz a multiplicação de vetores
test :: (Num a) => [a] -> [a] -> a
test  [] [] = 0
test (x:xs) (y:ys) = (x * y) + test xs ys

-- | Soma ponto-a-ponto de dois vetores.
-- Exemplo: somaVectorial [1,2] [3,4] == [4,6]
somaVectorial :: [Double] -> [Double] -> [Double]
somaVectorial xs ys = zipWith  (+) xs ys

-- | Função de ativação sigmoid.
-- Exemplo: sigmoid 0 == 0.5
sigmoid :: Double -> Double 
sigmoid x = 1/ (1+ exp(-x))

-- | Derivada da sigmoid (em termos da saída, não da entrada).
-- Exemplo: sigmoid’ 0.5 == 0.25
sigmoid' :: Double -> Double
sigmoid'(x)= (x)*(1-x)



--Exemplo: outputError [0.9] [1.0] == [-0.1]
outputError :: [Double]->[Double]->[Double]
outputError xs ys
      |length xs /= length ys = error "Tamanhos de listas diferentes"
      |otherwise = zipWith (-) xs ys

-- | Erro quadrático médio entre previsão e alvo.
-- Exemplo: mse [1.0] [0.0] == 1.0
mse ::[Double] -> [Double] -> Double
mse prevs targets
      |length prevs /= length targets = error "Tamanhos de listas diferentes"
      |otherwise = (sum (map (^2) erro))/ fromIntegral n
      where 
            erro = outputError prevs targets
            n = length prevs

-- | MSE médio sobre um conjunto de previsões e o que é suposto ter
msePredictions :: [[Double]] -> [[Double]] -> Double
msePredictions (x:xs) (y:ys)=
      sum mseTotal / fromIntegral (length mseTotal)
      where 
            mseTotal = zipWith mse (x:xs) (y:ys)

