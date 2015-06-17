function [weights] = fine_tuning(trainSet,labels, neuronsStructure, learningRate, weights,iterationNumber)
    %Initialization
    for i =1:length(neuronsStructure)
        inputOfLayers{i} = zeros(neuronsStructure(i),1);
        outputOfLayers{i} = zeros(neuronsStructure(i),1);
        deltas{i} = zeros(neuronsStructure(i),1);
        deltas_in{i} = zeros(neuronsStructure(i),1);
    end
    for i = 1:length(weights)
        weightChange{i} = zeros(size(weights{i}));
    end
    accuracy = zeros(1,iterationNumber);
    %Algorithm
    for w = 1:iterationNumber
%         if stoppingCondition
%         accuracy(w) = testMLP(trainSet,labels,neuronsStructure,weights);
%         fprintf('Iteration: %d\n',w);
        for i=1:length(trainSet)
            inputOfLayers{1} = [trainSet{i}];
            outputOfLayers{1} = [trainSet{i}];
            % Feed Forward
            for j = 1:length(weights)
               input = outputOfLayers{j};
               input = [input;1];
               weightsOfLayer = weights{j};
               inputOfLayers{j+1} = (input'*weightsOfLayer)';
               outputOfLayers{j+1} = [activationFunction(inputOfLayers{j+1})];
            end
            % Back Propagation
            deltas{end} = (labels{i} - outputOfLayers{end}).*derivativeOfActivation(inputOfLayers{end});
            for j = length(weights)+1:-1:2
                weightChange{j-1} = calculateWeightsChange(learningRate,deltas{j},outputOfLayers{j-1});
                if j == 2
                    break;
                end
                w = weights{j-1};
                w(end,:) = [];
                deltas_in{j-1} = w * deltas{j};
                deltas{j-1} = deltas_in{j-1} .* derivativeOfActivation(inputOfLayers{j-1});
            end
        weights = updateWeights(weights,weightChange);
        end
    end
%     plot(1:iterationNumber,accuracy);d
%     featureChange = deltas{1};

end

