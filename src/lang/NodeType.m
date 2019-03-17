classdef (Sealed) NodeType
% Copyright (c) 2012-2019, Imperial College London
% All rights reserved.

properties (Constant)
    Fork = 7;
%    Dispatcher = 6; 
    Router = 6;
    Cache = 5;
    Logger = 4;
    ClassSwitch = 3;
    Delay = 2;
    Source = 1;
    Queue = 0;
    Sink = -1;
    Join = -2;
end

methods (Static)
    function bool = isStation(nodetype)
        bool = (nodetype == NodeType.Source | nodetype == NodeType.Delay | nodetype == NodeType.Queue | nodetype == NodeType.Join);
    end
    function bool = isStateful(nodetype)
        bool = (nodetype == NodeType.Source | nodetype == NodeType.Delay | nodetype == NodeType.Queue | nodetype == NodeType.Cache | nodetype == NodeType.Join);
    end
end

end