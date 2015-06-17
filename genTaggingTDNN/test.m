function [numberOfWords,tp,tn,fp,fn] = test(testSet,labels,weights,neuronsStructure,windowSize)
    tp = 0;tn = 0;fp = 0;fn = 0;
%     correctSentences = 0;
    correctWords = 0;
    output = [];
%     numberOfTestSentences = length(testSet); 
    numberOfTestSentences = 100;
    numberOfWords = 0;
    for i =1:length(neuronsStructure)
        inputOfLayers{i} = zeros(neuronsStructure(i),1);
        outputOfLayers{i} = zeros(neuronsStructure(i),1);
    end
    for i=1:numberOfTestSentences
        fprintf('%0.2f percent completed\n',i/numberOfTestSentences*100);
        sentence = testSet{i};
        sentenceTagging =  labels{i};
        for w = 1:floor(windowSize/2)
            sentence = cat(2,'$eos',sentence);
%             sentenceTagging = cat(2,0,sentenceTagging);
            sentence = cat(2,sentence,'$eos');
%             sentenceTagging = cat(2,sentenceTagging,0);
        end
        for j = 1+floor(windowSize/2):length(sentence)-floor(windowSize/2)
            inputs = sentence(j-floor(windowSize/2):j+floor(windowSize/2));
            inputs = convertToInputVector(inputs);
%             Considering label as gen tagging
            inputOfLayers{1} = [inputs];
            outputOfLayers{1} = [inputs];
            % Feed Forward
            for k = 1:length(weights)
                input = outputOfLayers{k};
                input = [input;1];
                weightsOfLayer = weights{k};
                inputOfLayers{k+1} = (input'*weightsOfLayer)';
                outputOfLayers{k+1} = [activationFunction(inputOfLayers{k+1})];
            end
            output = [output;outputOfLayers{end}];
        end
        output(output<=0) = 0;
        output(output>0) = 1;
%         if output' == sentenceTagging
%              correctSentences = correctSentences + 1;
%         end
%         output = zeros(length(output),1);
        numberOfWords = numberOfWords + length(output);
        tp = tp + sum((output' == sentenceTagging).*(sentenceTagging == 1));
        tn = tn + sum((output' == sentenceTagging).*(sentenceTagging == 0));
        fp = fp + sum((output' ~= sentenceTagging).*(sentenceTagging == 0));
        fn = fn + sum((output' ~= sentenceTagging).*(sentenceTagging == 1));
        output = [];
    end
%     accuracy = correctSentences / numberOfTestSentences;
%     wordAccuracy = correctWords/numberOfWords;
    
end