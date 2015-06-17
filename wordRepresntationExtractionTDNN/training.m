clear;
clc;
warning off MATLAB:mat2cell:ObsoleteSingleInput;
baseAddress = '../alldata';
wordFeatureVectorSize = 200;
minSupport = 500;
windowSize = 7;
learningRate = 0.1;
notFrequentWords = java.util.TreeSet;
digitsFeatureVector = rand(wordFeatureVectorSize,1);
notFrequentWordsFeatureVector = rand(wordFeatureVectorSize,1);
eosFeatureVector = zeros(wordFeatureVectorSize,1);
mapping = load('mapping.mat');
words = mapping.mapping.keySet;
wordsIterator = words.iterator;
% assign random vectors to all words in documents
global featureMapping;
% featureMapping = load('featureMapping');
% featureMapping = featureMapping.featureMapping;
global allWords;
% allWords = load('allWords');
% allWords = allWords.allWords;
if isempty(featureMapping) == 1 || isempty(allWords) == 1
    fprintf('Assigning random vectors to all words in vocabulary\n');
    featureMapping = [];
    allWords = java.util.ArrayList;
    while wordsIterator.hasNext == 1
        word = wordsIterator.next;
        if isempty(strfind(word,'#')) == 0
            w1 = word(1:end-1);
            if isnan(str2double(w1)) == 0
%                 display(word);
                continue;
            end
        end
        if isnan(str2double(word)) == 0
%             display(word);
        elseif mapping.mapping.get(word) >= minSupport
            allWords.add(word);
            featureMapping(allWords.indexOf(word)+1,:) = 2*rand(wordFeatureVectorSize,1)-1;
        else
            notFrequentWords.add(word);
        end
    end
    allWords.add('$notfr');
    featureMapping(allWords.indexOf('$notfr')+1,:) = notFrequentWordsFeatureVector;
    allWords.add('$digits');
    featureMapping(allWords.indexOf('$digits')+1,:) = digitsFeatureVector;
    allWords.add('$eos');
    featureMapping(allWords.indexOf('$eos')+1,:) = eosFeatureVector;
    
    fprintf('Assining Finished\n')
end
% considering label as |V| neurons
% neuronsStructure = [(windowSize-1) * wordFeatureVectorSize,1000,allWords.size];
% considering label as featureVector
neuronsStructure = [(windowSize-1) * wordFeatureVectorSize,1000,wordFeatureVectorSize];
weights = [];
% load('weights');
if isempty(weights)
    for i = 1:length(neuronsStructure)-1
        weights{i} = rand(neuronsStructure(i)+1,neuronsStructure(i+1))./1000;
    end
end
% parpool ('local',4);
for q = 1:21
    tic;
    trset = load(strcat(baseAddress ,'/','trainset',num2str(q),'.mat'));
    lbls = load(strcat(baseAddress ,'/','labels',num2str(q),'.mat'));
    % timeDelayNetInputNumbers = 5;
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
%             Considering label as gen tagging
%             label = sentenceTagging(j);
%             label = 2 * label - 1;
            label = trainSet{ceil(windowSize/2)};
%             Considering label as |V| size
%             labelIndex = -1;
%             if isnan(str2double(label)) == 0
%                 labelIndex = allWords.indexOf('$digits')+1;
%             end
%             if labelIndex == -1
%                 if length(label) <= 1
%                     label = [label,'#'];
%                 end
%                 if allWords.indexOf(label) >= 0
%                     labelIndex = allWords.indexOf(label)+1;
%                 end
%             end
%             if labelIndex == -1
%                labelIndex = allWords.indexOf('$notfr')+1;
%             end
% 
%     %         label = convertToInputVector(label);
% 
%             label = -ones(allWords.size,1);
%             label(labelIndex) = 1;
%             Considering label as featureVector
            label = mat2cell(label);
            label = convertToInputVector(label);


            trainSet(ceil(windowSize/2)) = [];
            inputVector = convertToInputVector(trainSet);
            inputVector = mat2cell(inputVector);
    %         label = sentenceTagging(j);
            label = mat2cell(label);
%             [weights] = fine_tuning(inputVector,label, neuronsStructure, learningRate, weights,iterationNumber);
            [weights,featureChange] = fine_tuning2(inputVector,label, neuronsStructure, learningRate, weights,iterationNumber);
            updateFeatures(trainSet,inputVector{1},featureChange);
        end 
    end
    toc;
end
% delete(gcp);
% save('featureMapping','featureMapping');
% save('allWords','allWords');
% save('weights','weights');
