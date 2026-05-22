
# Haskell Multilayer Perceptron (MLP) - XOR Solver
![Haskell](https://img.shields.io/badge/Haskell-5D4F85?style=flat-square&logo=haskell&logoColor=white)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)

A custom-built, feedforward Artificial Neural Network (Multilayer Perceptron) implemented entirely from scratch in pure Haskell. This project demonstrates the application of functional programming paradigms to machine learning concepts, specifically solving the non-linearly separable XOR problem.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Training](#training)
  - [Prediction](#prediction)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [License](#license)

## Overview

This project implements a standard neural network architecture utilizing gradient descent and backpropagation for weight optimization. By leveraging Haskell's strong type system and pure functions, the core mathematical operations (such as the sigmoid activation and mean squared error calculation) are isolated from I/O side effects, resulting in a highly predictable and testable codebase.

## Architecture

The network is configured to solve the XOR logic gate, requiring the following topology:
* **Input Layer:** 2 Neurons
* **Hidden Layer:** 4 Neurons (Sigmoid Activation)
* **Output Layer:** 1 Neuron (Sigmoid Activation)

The network parameters (weights and biases) can be serialized to a text file post-training, allowing for persistent models that do not require retraining upon subsequent executions.

## Prerequisites

To compile and run this project, ensure you have the Glasgow Haskell Compiler (GHC) installed on your system.
* [GHC (Glasgow Haskell Compiler)](https://www.haskell.org/ghc/)

Standard libraries used include `System.Random`, `Test.QuickCheck`, and `Text.Printf`.

## Usage

Compile the project or run it directly using GHCi. The Command Line Interface (CLI) supports three primary modes of operation.

### Training

To train the network with 100,000 iterations and save the resulting weights to a file (e.g., `pesos.txt`):


$ ./projecto --train pesos.txt

## Expected Output:
Plaintext
Modo treino onn . Guardando em pesos.txt
A treinar a rede.... old on mate
Pesos guardados em pesos.txt
[([0.00073], [0.00000]), ([0.99916], [1.00000]), ([0.99900], [1.00000]), ([0.00097], [0.00000])]
MSE: 7.945019742132149e-7

## Prediction
To load a previously trained model and predict the output for user-provided inputs:
$ ./projecto --predict pesos.txt
Input 1: 1
Input 2: 0
Output: [1]

## Testing
The project utilizes Property-Based Testing via the QuickCheck library to ensure mathematical and structural invariants are maintained during execution.
$ ./projecto --test
A executar Teste 1: Estrutura pos-treino...
+++ OK, passed 100 tests.
A executar Teste 2: Tamanho do Output...
+++ OK, passed 100 tests.
A executar Teste 3: MSE de listas iguais...
+++ OK, passed 100 tests.
Tested Properties:

Structural Integrity: Verifies that a backpropagation step strictly mutates weight values without accidentally altering the tensor dimensions (number of layers and neurons).

Output Consistency: Ensures the dimension of the resulting prediction array inherently matches the defined number of output neurons.
MSE Sanity Check: Mathematically validates that the Mean Squared Error of identical prediction and target arrays evaluates exactly to 0.0

## Project Structure
├── Main.hs      # CLI entry point, I/O handling, and QuickCheck properties
├── Types.hs     # Core data types (Network, Layer) with standard derivations
├── Net.hs       # Neural network engine (forward pass, backpropagation, training loop)
└── Maths.hs     # Pure mathematical functions (activation functions, MSE)
