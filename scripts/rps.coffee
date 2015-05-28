# ----------------------------------------------
# EXAMPLE TO SHOW UNTRAINED VS. TRAINED NETWORKS
# ----------------------------------------------

module.exports = () ->
  # for getting input (utility, ignore)
  prompt = require 'prompt'
  prompt.start()
  prompt.message = '> Choose '
  prompt.delimiter = ' '

  # initialize the library
  synaptic = require 'synaptic'
  
  # define the parameters
  iterations = [1, 10, 100, 1000, 10000]
  hiddenLayerSize = 5
  learningRate = 0.3

  # setup
  console.log 'setting up [' + iterations.length + '] perceptrons with 1 input neuron and 1 output neuron.'

  networks = {}
  networks[n] = new synaptic.Architect.Perceptron(1, hiddenLayerSize, 1) for n in [0...iterations.length]

  # train the networks
  console.log 'training networks'
  for i in [0...iterations.length]
    console.log '\ntraining network [' + i + '] for [' + iterations[i] + '] iterations'

    network = networks[i]
    numIterations = iterations[i]
    trainer = new synaptic.Trainer network

    trainingSet = [
      # --------------------------------------
      #         DEFINE THE TRAINING SET
      # (where 0: rock, 0.5: paper, 1: scissors)
      # --------------------------------------
      {
        # rock => paper
        input: [0]
        output: [0.5]
      }
      {
        # paper => scissors
        input: [0.5]
        output: [1]
      }
      {
        # scissors => rock
        input: [1]
        output: [0]
      }
    ]

    trainer.train trainingSet,
      rate: learningRate # learning rate
      iterations: numIterations # maximum number of iterations
      error: 0.005 # minimum error (remember, error TOO low results in [overfitting]
      shuffle: true # shuffle training set after each iteration, since [order doesn't matter]
      log: 1000 # log the status every [x] iterations
      cost: synaptic.Trainer.cost.MSE # use mean squared error cost to encourage convex cost

  # test the network
  console.log '\n\nTRAINING COMPLETE. TESTING NETWORK:'

  choices = {
    'r': 0
    'p': 0.5
    's': 1
  }

  responses = { # Math.floor(result * 3) for one of these
    0: 'rock'
    1: 'paper'
    2: 'scissors'
  }

  getResult = (num) ->
    return responses[Math.floor(num[0] * 3)]

  test = () ->
    prompt.get '(r/p/s)', (err, result) ->
      if err
        return console.log err

      result = result['(r/p/s)']
      input = [choices[result.substring(0, 1)]]

      console.log '\nINPUT: [' + getResult(input) + ']'
      for n in [0...iterations.length]
        res = networks[n].activate input
        console.log 'NETWORK [' + n + '] ([' + iterations[n] + '] iterations) => [' + res + '] (' + getResult(res) + ')'

      console.log '\n\n'
      test()

  test()
