function lqsimSolve(filename, maxTime)
% LQSIMSOLVE(FILENAME, MAXTIME)

% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.
if nargin<2 %~exist('maxIter','var')
    system(['lqsim -T 1000000 -x ',filename]);
else
    system(['lqsim -T ',num2str(maxTime),' -x ',filename])
end
end
