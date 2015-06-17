function output = activationFunction(input)
%     output = 1./(1 + exp(-input));
    output = 2./(1 + exp(-input)) - 1;
end