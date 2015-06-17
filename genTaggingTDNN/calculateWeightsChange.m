function output = calculateWeightsChange(learningRate,deltasOfLayer,outputOfPreviousLayers)
    outputOfPreviousLayers = [outputOfPreviousLayers;1];
    output = outputOfPreviousLayers * (deltasOfLayer');
    output = learningRate * output;
end