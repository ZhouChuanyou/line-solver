classdef PMIF
% Copyright (c) 2012-2019, Imperial College London
% All rights reserved.

properties
    servers;
    workUnitServers; 
    closedWorkloads; 
    demandServiceRequests;
    workUnitServiceRequests;
    timeServiceRequests;
end

methods
%public methods, including constructor

    %constructor
    function obj = PMIF(servers, workUnitServers, closedWorkloads, ...
                    demandServiceRequests, workUnitServiceRequests, timeServiceRequests)
        if(nargin > 0)
            obj.servers = servers;
            obj.workUnitServers = workUnitServers;
            obj.closedWorkloads = closedWorkloads;
            obj.demandServiceRequests = demandServiceRequests;
            obj.workUnitServiceRequests = workUnitServiceRequests;
            obj.timeServiceRequests = timeServiceRequests;
        end
    end
    

end
    
end