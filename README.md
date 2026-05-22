Markdown
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

```bash
$ ./projecto --train pesos.txt
