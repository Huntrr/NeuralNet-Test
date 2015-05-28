# ----------------------
# Sample XOR gate solver
# ----------------------

module.exports = () ->
  # initialize the library
  synaptic = require 'synaptic'

  # create the layers
  console.log 'creating the layers'
  inputLayer = new synaptic.Layer 2 # the input layer has 2 neurons (2 binary inputs)
  hiddenLayer = new synaptic.Layer 3 # the hidden layer can have an arbitrary number of inputs
  outputLayer = new synaptic.Layer 1 # only one output

  # connect the layers
  console.log 'connecting the layers'
  inputLayer.project hiddenLayer
  hiddenLayer.project outputLayer

  # setup the network
  console.log 'creating the network'
  network = new synaptic.Network {
    input: inputLayer
    hidden: [hiddenLayer]
    output: outputLayer
  }

  # train the network
  learningRate = 0.3 # learning rate of the network, how "fast" we'll change weights
  iterations = 20000 # how many iterations we should run of training

  console.log 'training network with learning rate [' + learningRate + '], over ' + iterations + ' iterations'
  for i in [0...iterations]
    # input: [0,0] => expected output: [0]
    network.activate [0,0] # activate the network with [0,0] at the input layer
    network.propagate learningRate, [0] # employ backpropagation to train the network towards an output of 0 for this input

    # input: [0,1] => expected output: [1]
    network.activate [0,1]
    network.propagate learningRate, [1]

    # input: [1,0] => expected output: [1]
    network.activate [1,0]
    network.propagate learningRate, [1]

    # input: [1,1] => expected output: [0]
    network.activate [1,1]
    network.propagate learningRate, [0]

  # now that the network is trained, we can test it
  console.log '\nTESTING NETWORK:'
  console.log 'input: [0,0] => output: ' + network.activate([0,0]) + ' (exp: [0])'
  console.log 'input: [0,1] => output: ' + network.activate([0,1]) + ' (exp: [1])'
  console.log 'input: [1,0] => output: ' + network.activate([1,0]) + ' (exp: [1])'
  console.log 'input: [1,1] => output: ' + network.activate([1,1]) + ' (exp: [0])'
