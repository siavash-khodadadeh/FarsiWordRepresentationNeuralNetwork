function inputVector = convertToInputVector(trainSet)
    inputVector = [];
    for i = 1:length(trainSet)
        inputVector = [inputVector;getFeatureVector(trainSet{i})];
    end
end
function featureVector = getFeatureVector(word)
    global featureMapping;
    global allWords;
    if allWords.contains(word) == 1
        featureVector = featureMapping(allWords.indexOf(word)+1,:);
    else
        featureVector = featureMapping(1,:);
    end
    featureVector = featureVector';
end
% function featureVector = getFeatureVector(word)
%     global featureMapping;
%     if isnan(str2double(word)) == 0
%         featureVector = featureMapping.get('$digits');
%         return;
%     end
%     if length(word) <= 1
%         word = [word,'#'];
%     end
%     if strcmp(word,'$eos')
%         featureVector = featureMapping.get('$eos');
%         return;
%     else
%         featureVector = featureMapping.get(word);
%     end
%     if isempty(featureVector)
%         featureVector = featureMapping.get('$notfr');
%     end
%     
% end