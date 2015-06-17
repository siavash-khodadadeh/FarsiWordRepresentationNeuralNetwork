clear;
clc;
N = 10;
load('featureMapping.mat');
load('allWords.mat');
s = input('Please Enter Your Word Index: ');
% word = 'متن';
word = allWords.get(s);
a = featureMapping(s+1,:);
a = featureMapping(29,:)-featureMapping(58,:)-featureMapping(1037,:);
a = -a;
distances = [];
for i = 1:allWords.size
    if strcmp(allWords.get(i-1),word)==1
        distances = [distances;1000];
        continue;
    end
    b = featureMapping(i,:);
    distances =  [distances;sum((a-b).^2)];
%     distances =  [distances;abs(sum(a.*b))];
end
display(word);
[val,indices] = sort(distances);
for i = 1:N
    index = indices(i);
    index = index - 1;
    nearestWord = allWords.get(index);
    display(index);
    display(nearestWord);
%     display(val);
end
