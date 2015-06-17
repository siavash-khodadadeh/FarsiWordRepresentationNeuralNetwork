function readData(fileAddress,numberToSave,baseAddressToSave)
%     sentenceStart = 0;
    characters = [];
    flags = [];
    shouldSave = 0;
    labels = [];
    trainSetCounter = 0;
    lineCounter = 0;
    fileCounter = 1;
    [fid,err] = fopen(fileAddress);
    if ~isempty(err)
        display(err);
        return;
    end
    line = fgets(fid);
    while line ~= -1
        lineCounter = lineCounter + 1;
        if rem(lineCounter,numberToSave) == 0
            shouldSave = 1;
        end
        line = strtrim(line);
        flag = 0;
        secondPart = line;
        if strfind(line,'GEN')
            flag = 1;
        end
        for i = 1:4
            [firstPart,secondPart] = strtok(secondPart);
        end
        if strfind(secondPart,' ')
            [secondPart,temp] = strtok(secondPart);
        end
        word = secondPart;
        if strcmp(word,'#') == logical(true) || strcmp(word,'.') == logical(true) || strcmp(word,'?') == logical(true) || strcmp(word,'!') == logical(true)
%             sentenceStart = 1 - sentenceStart;
            if isempty(characters) == 0
                trainSetCounter = trainSetCounter + 1;
                trainSet{trainSetCounter} = characters;
                labels{trainSetCounter} = flags;
                characters = [];
                flags = [];
                fprintf('Sentece Number: %d\nLine: %d\n',trainSetCounter,lineCounter);
                if shouldSave == 1
                    fprintf('saving data up to this point\n');
                    save(strcat(baseAddressToSave,'/','trainset',num2str(fileCounter)),'trainSet');
                    save(strcat(baseAddressToSave,'/','labels',num2str(fileCounter)),'labels');
                    fileCounter = fileCounter + 1;
                    trainSet = [];
                    labels = [];
                    trainSetCounter = 0;
                    shouldSave = 0;
                end
            end
        else
            characters{end+1} = word;
            flags = [flags,flag];
%             if isempty(mapping) == 1 || max(ismember(mapping,word)) ~= 1
%                 mapping{end+1} = word;
%                 mappingNumbers{end+1} = 1;
%             else
%                 mappingNumbers{find(ismember(mapping,word) == 1)} = mappingNumbers{find(ismember(mapping,word) == 1)}+1;
%             end
        end
        
        flag = 0;
        line = fgets(fid);
    end
    if isempty(characters) == 0
        trainSetCounter = trainSetCounter + 1;
        trainSet{trainSetCounter} = characters;
        labels{trainSetCounter} = flags;
        characters = [];
        flags = [];
    end
    fprintf('Sentece Number: %d\nLine: %d\n',trainSetCounter,lineCounter);
    fprintf('saving data up to this point\n');
    save(strcat(baseAddressToSave,'/','trainset',num2str(fileCounter)),'trainSet');
    save(strcat(baseAddressToSave,'/','labels',num2str(fileCounter)),'labels');
    fileCounter = fileCounter + 1;
    trainSet = [];
    labels = [];
    trainSetCounter = 0;
    shouldSave = 0;
    
end