module Types where

data Layer = Layer { weights :: [[Double]], bias :: [Double] } deriving (Show,Read) -- cria um novo tipo raiz camada
--Network: Uma rede neuronal, composta por várias camadas
type Network = [Layer]

data DataSet = DataSet {inputs :: [[Double]],targets :: [[Double]]} deriving Show