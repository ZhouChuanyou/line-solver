classdef workUnitServiceRequest
% Copyright (c) 2012-2019, Imperial College London
% All rights reserved.

properties
    workloadName;   %string
    serverID;       %string
    numberVisits;   %int
    transits;
end

methods
%public methods, including constructor

    %constructor
    function obj = workUnitServiceRequest(workloadName, serverID, numberVisits)
        if(nargin > 0)
            obj.workloadName = workloadName;
            obj.serverID = serverID;
            obj.numberVisits = numberVisits;
        end
    end
    
    function obj = addTransit(obj, dest, prob)
        if isempty(obj.transits)
            obj.transits = cell(1,2);
            obj.transits{1,1} = dest;
            obj.transits{1,2} = prob;
        else
           obj.transits{end+1,1} = dest; 
           obj.transits{end,2} = prob;
        end
    end

end
    
end