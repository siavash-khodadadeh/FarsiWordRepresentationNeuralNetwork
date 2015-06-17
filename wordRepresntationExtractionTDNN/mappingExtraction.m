function [mapping] = mappingExtraction( baseAddress,fileCounterStart,fileCounterEnd)
    mapping = java.util.TreeMap;
    mappingNumbers = [];
    for i = fileCounterStart:fileCounterEnd
        fprintf('loading data part %d\n',i);
        data = load(strcat(baseAddress,'/','trainset',num2str(i),'.mat'));
%         lables = load(strcat('labels',num2str(i),'.mat'));
        theNumberOfSentences = length(data.trainSet);
        for j = 1:theNumberOfSentences
            fprintf('trainset%d %0.3f percent completed\n',i,j/theNumberOfSentences*100)
            sentence = data.trainSet{j};
%             tagging = labels.labels{j};
            for k = 1:length(sentence)
                word = sentence{k};
                if length(word) <= 1
                    word = [word,'#'];
                end
%                 word = java.lang.String(word);
                if mapping.containsKey(word) ~= 1
                    mapping.put(word,1);
                else
                    mapping.put(word,mapping.get(word)+1);
                end
            end
           
        end
    end
    
end