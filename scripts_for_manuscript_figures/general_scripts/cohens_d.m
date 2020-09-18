function d = cohens_d(input_values,binary_outcome)
% d = cohens_d(input_values,binary_outcome)
% 
% This is for the two-sample case
% By Phil Kragel

n1 = sum(~isnan(input_values(binary_outcome)) & ~isinf(input_values(binary_outcome)));
n0 = sum(~isnan(input_values(~binary_outcome)) & ~isinf(input_values(~binary_outcome)));

meanpres = mean(input_values(binary_outcome));
    meanabs = mean(input_values(~binary_outcome));
    
    v1 = var(input_values(binary_outcome));
    v0 = var(input_values(~binary_outcome));
    
    pooledsd = sqrt((v1.*(n1-1) + v0.*(n0-1)) ./ (n1 + n0 - 2));
    
    d = (meanpres - meanabs) ./ pooledsd;
