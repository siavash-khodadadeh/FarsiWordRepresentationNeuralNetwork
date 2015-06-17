clear;
clc;
baseAddress = '../alldata';
q = 2;
global featureMapping;
featureMapping = load('featureMapping');
featureMapping = featureMapping.featureMapping;
global allWords;
allWords = load('allWords');
allWords = allWords.allWords;
dataset = load(strcat(baseAddress ,'/','trainset',num2str(q),'.mat'));
lbls = load(strcat(baseAddress ,'/','labels',num2str(q),'.mat'));
windowSize = 7;
testSet = dataset.trainSet;
labels = lbls.labels;
weights = load('weights');
weights = weights.weights;
neuronsStructure = [];
for i = 1:length(weights)
    neuronsStructure = [neuronsStructure,size(weights{i},1)-1];
end
neuronsStructure = [neuronsStructure,size(weights{end},2)];
[numberOfWords,tp,tn,fp,fn] = test(testSet,labels,weights,neuronsStructure,windowSize);
accuracy = (tp+tn)/numberOfWords;
display(accuracy);