function [self]=setGraph(self,lqnGraph,taskGraph)
% Copyright (c) 2012-2018, Imperial College London
% All rights reserved.
self.lqnGraph = lqnGraph;
if nargin>2
    self.taskGraph = taskGraph;
end
end

