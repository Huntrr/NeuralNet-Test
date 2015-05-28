# -----------------------------------------------
# ALLOWS FOR MODELLING OF ANY SERIES OF VARIABLES
# -----------------------------------------------

# construct function for setting arbitrary number of layers
construct = (constructor, args) ->
  F = ->
    constructor.apply this, args

  F.prototype = constructor.prototype
  return new F()

# actual functions
module.exports = () ->
  # for getting input (utility, ignore)
  prompt = require 'prompt'
  prompt.start()
  prompt.message = '> INPUT '
  prompt.delimiter = '|'

  # initialize the library
  synaptic = require 'synaptic'
  
  # define the structure
  numberOfInputs = 2 # number of input neurons
  numberOfOutputs = 1 # numbers of output neurons

  numberOfHiddenLayers = 2 # number of hidden layers
  hiddenLayerSize = 5 # number of neurons in each hidden layer

  # setup
  console.log 'creating [perceptron] with [' + numberOfInputs + '] input neuron(s), 
               [' + numberOfOutputs + '] output neuron(s), and [' + numberOfHiddenLayers + '] 
               hidden layers with [' + hiddenLayerSize + '] neuron(s) each'

  args = []
  args.push numberOfInputs
  for n in [0...numberOfHiddenLayers]
    args.push hiddenLayerSize
  args.push numberOfOutputs

  network = construct synaptic.Architect.Perceptron, args
  # This is a DEEP MULTILAYER PERCEPTRON (with multiple hidden layers) so it
  # can be more accurate, but it requires more training

  # train the network
  trainer = new synaptic.Trainer network

  console.log 'setting up training set\n'
  trainingSet = [
    # --------------------------------------------
    #             DEFINE THE TRAINING SET
    # (all inputs and outputs must be 0 <= x <= 1)
    # --------------------------------------------
    {
      input: [0,0]
      output: [0]
    }
    {
      input: [1,0]
      output: [1]
    }
    {
      input: [0,1]
      output: [1]
    }
    {
      input: [1,1]
      output: [0]
    }
  ]

  trainer.train trainingSet,
    rate: 0.1 # learning rate
    iterations: 1000000 # maximum number of iterations
    error: 0.005 # minimum error (remember, error TOO low results in [overfitting]
    shuffle: true # shuffle training set after each iteration, since [order doesn't matter]
    log: 1000 # log the status every [x] iterations
    cost: synaptic.Trainer.cost.MSE # use mean squared error cost to encourage convex cost

  # test the network
  console.log '\nTRAINING COMPLETE. TESTING NETWORK:'

  test = () ->
    prompt.get [0...numberOfInputs].map((x) -> x.toString()), (err, result) ->
      if err
        return console.log err

      input = []
      for i in [0...numberOfInputs]
        input.push result[i.toString()]

      console.log 'INPUT: [' + input + '] => OUTPUT: [' + network.activate(input) + ']'
      test()

  test()
