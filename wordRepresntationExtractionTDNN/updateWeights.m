function [weights] = updateWeights(weights,weightChange)
    for i = 1:length(weights)
        weights{i} = weights{i} + weightChange{i};
    end
end