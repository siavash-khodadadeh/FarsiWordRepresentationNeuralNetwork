function output = derivativeOfActivation(input)
    fx = activationFunction(input);
%     output = fx .* (1-fx);
    output = 0.5 * (1+fx).*(1-fx);
end