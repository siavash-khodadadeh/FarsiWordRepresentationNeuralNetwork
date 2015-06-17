function [weights,featureChange] = fine_tuning(trainSet,labels, neuronsStructure, learningRate, weights,iterationNumber)
    %Initialization
    V = weights{1};
    W = weights{2};
    
    [row , col ] = size(V);
    [row2, col2] = size(W);
    
    for e = 1:iterationNumber
        
        for i=1:length(trainSet)
            
            y=zeros(col2,1);
            z=zeros(col ,1);
            y_in=zeros(col2,1);
            z_in=zeros(col ,1);
            % feed forward
            
            parfor t=1:col
                z_in(t,1) = transpose(trainSet{i}) * V(1:row-1,t) + V(row,t) ;
                z(t,1) = activationFunction(z_in(t,1));
            end
              
            parfor r=1:col2
                y_in(r,1) = transpose(z)*W(1:row2-1,r) + W(row2,r);
                y(r,1) = activationFunction(y_in(r,1));
            end
            
            % back propagation
            delta3 = [];
            delta2 = [];
            delta1 = [];
            
            parfor t=1:col2
                delta3 = [delta3; (labels{i}(t,1) - y(t,1)) * derivativeOfActivation(y_in(t,1)) ];
            end
            
            z = [z;1];
            dW = z*(learningRate*transpose(delta3));
            
            delta_in2 = W*delta3;
            parfor t=1:col
                delta2 = [delta2; delta_in2(t,1)*derivativeOfActivation(z_in(t,1))];
            end
            
            x = [trainSet{i}; 1];
            dV = x*(learningRate*transpose(delta2));
            
            delta_in1 = V*delta2;
            parfor t=1:row-1
                delta1 = [delta1; delta_in1(t,1)*derivativeOfActivation(trainSet{i}(t,1))];
            end 
            weights{1} = V + dV;
            weights{2} = W + dW;
        end
    end
    featureChange = delta1;
end
   
%     for i =1:length(neuronsStructure)
%         inputOfLayers{i} = zeros(neuronsStructure(i),1);
%         outputOfLayers{i} = zeros(neuronsStructure(i),1);
%         deltas{i} = zeros(neuronsStructure(i),1);
%         deltas_in{i} = zeros(neuronsStructure(i),1);
%     end
%     for i = 1:length(weights)
%         weightChange{i} = zeros(size(weights{i}));
%     end
%    % accuracy = zeros(1,iterationNumber);
%     %Algorithm
%     for w = 1:iterationNumber
% %         if stoppingCondition
% %         accuracy(w) = testMLP(trainSet,labels,neuronsStructure,weights);
% %         fprintf('Iteration: %d\n',w);
%         for i=1:length(trainSet)
%             inputOfLayers{1} = [trainSet{i}];
%             outputOfLayers{1} = [trainSet{i}];
%             % Feed Forward
%             for j = 1:length(weights)
%                input = outputOfLayers{j};
%                input = [input;1];
%                weightsOfLayer = weights{j};
%                inputOfLayers{j+1} = (input'*weightsOfLayer)';
%                outputOfLayers{j+1} = [activationFunction(inputOfLayers{j+1})];
%             end
%
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % Back Propagation
%             deltas{end} = (labels{i} - outputOfLayers{end}).*derivativeOfActivation(inputOfLayers{end});
%             for j = length(weights)+1:-1:2
%                 weightChange{j-1} = calculateWeightsChange(learningRate,deltas{j},outputOfLayers{j-1});
% %                 if j == 2
% %                     break;
% %                 end
%                 w = weights{j-1};
%                 w(end,:) = [];
%                 deltas_in{j-1} = w * deltas{j};
%                 deltas{j-1} = deltas_in{j-1} .* derivativeOfActivation(inputOfLayers{j-1});
%             end
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         weights = updateWeights(weights,weightChange);
%         end
%     end
%     plot(1:iterationNumber,accuracy);d
%    featureChange = deltas{1};
%end

