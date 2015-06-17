function updateFeatures(trainSet,inputVector,featureChange)
    global featureMapping;
    featureWordSize = length(inputVector) / length(trainSet);
    for i = 1:length(trainSet)
        updateVector(trainSet{i},inputVector((i-1)*featureWordSize+1:i*featureWordSize),featureChange((i-1)*featureWordSize+1:i*featureWordSize));
    end
end

function updateVector(word,inputVector,featureChange)
    global featureMapping;
    global allWords;
    if strcmp(word,'$eos')
        return;
    end
    newVector = inputVector+featureChange;
    if isnan(str2double(word)) == 0
        featureMapping(allWords.indexOf('$digits')+1,:) = newVector;
        return;
    end
    if length(word) <= 1
        word = [word,'#'];
    end
    if allWords.indexOf(word) >= 0
        featureMapping(allWords.indexOf(word)+1,:) = newVector;
        return;
    end
    featureMapping(allWords.indexOf('$notfr')+1,:) = newVector;
end