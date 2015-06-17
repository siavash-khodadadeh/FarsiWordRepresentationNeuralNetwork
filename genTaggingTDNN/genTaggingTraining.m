clear;
clc;
warning off MATLAB:mat2cell:ObsoleteSingleInput;
baseAddress = '../alldata';
wordFeatureVectorSize = 200;
% minSupport = 500;
windowSize = 7;
learningRate = 0.1;
notFrequentWords = java.util.TreeSet;
digitsFeatureVector = rand(wordFeatureVectorSize,1);
notFrequentWordsFeatureVector = rand(wordFeatureVectorSize,1);
eosFeatureVector = zeros(wordFeatureVectorSize,1);

global featureMapping;
featureMapping = load('featureMapping');
featureMapping = featureMapping.featureMapping;
global allWords;
allWords = load('allWords');
allWords = allWords.allWords;

neuronsStructure = [(windowSize) * wordFeatureVectorSize,1000,1];
weights = [];
% load('weights');
if isempty(weights)
    for i = 1:length(neuronsStructure)-1
        weights{i} = rand(neuronsStructure(i)+1,neuronsStructure(i+1))./1000;
    end
end
for q = 1:21
    tic;
    trset = load(strcat(baseAddress ,'/','trainset',num2str(q),'.mat'));
    lbls = load(strcat(baseAddress ,'/','labels',num2str(q),'.mat'));

    for i = 1:length(trset.trainSet)
        fprintf('%0.2f percent completed\n',(100*i/length(trset.trainSet)));
        sentence = trset.trainSet{i};
        sentenceTagging =  lbls.labels{i};
        for j = 1:floor(windowSize/2)
            sentence = cat(2,'$eos',sentence);
            sentenceTagging = cat(2,0,sentenceTagging);
            sentence = cat(2,sentence,'$eos');
            sentenceTagging = cat(2,sentenceTagging,0);
        end
        iterationNumber = 1;
        for j = 1+floor(windowSize/2):length(sentence)-floor(windowSize/2)
            trainSet = sentence(j-floor(windowSize/2):j+floor(windowSize/2));
            label = sentenceTagging(j);
            label = 2 * label - 1;
            inputVector = convertToInputVector(trainSet);
            inputVector = mat2cell(inputVector);
            label = mat2cell(label);
            [weights] = fine_tuning(inputVector,label, neuronsStructure, learningRate, weights,iterationNumber);

        end 
    end
    toc;
end
% save('featureMapping','featureMapping');
% save('allWords','allWords');
% save('weights','weights');
