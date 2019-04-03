classdef Router < StatefulNode
    % A node to route jobs towards other nodes
    %
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    properties
        cap;
        numberOfServers;
        schedPolicy;
        schedStrategy;
    end
    
    methods
        %Constructor
        % This is a node and not a Station because jobs cannot station
        % inside it
        function self = Router(model, name)
            self@StatefulNode(name);
            
            classes = model.classes;
            self.schedPolicy = SchedStrategyType.NP;
            self.schedStrategy = SchedStrategy.FCFS;
            self.input = Buffer(classes);
            self.output = Dispatcher(classes);
            self.cap = Inf;
            self.schedPolicy = SchedStrategyType.NP;
            self.server = ServiceTunnel();
            self.numberOfServers = 1;
            self.setModel(model);
            self.model.addNode(self);
        end
        
        function setProbRouting(self, class, destination, probability)
            setRouting(self, class, 'Probabilities', destination, probability);
        end
        
        function setScheduling(self, class, strategy)
            self.input.inputJobClasses{1, class.index}{2} = strategy;
        end
        
        function setService(self, class, distribution)
            self.server.serviceProcess{1, class.index}{2} = ServiceStrategy.LI;
            self.server.serviceProcess{1, class.index}{3} = distribution;
        end
        
        function sections = getSections(self)
            sections = {self.input, self.server, self.output};
        end
    end
    
end
