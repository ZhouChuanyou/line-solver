classdef Event < Copyable
    % A generic event occurring in a model.
    %
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    % event major classification
    
    properties
        node;
        event;
        class;
        prob;
        state;
        t;
    end
    
    methods
        function self = Event(event, node, class, prob, state, ts)
            % SELF = EVENT(EVENT, NODE, CLASS, PROB, STATE, TIMESTAMP)
            
            self.node = node;
            self.event = event;
            self.class = class;
            if ~exist('prob','var')
                prob = NaN;
            end
            self.prob = prob;
            if ~exist('state','var')
                state = []; % local state of the node
            end
            self.state = state;
            
            if ~exist('ts','var')
                ts = NaN; % timestamp
            end
            self.t = ts;
        end
        
        function print(self)
            % PRINT()
            
            if isnan(self.t)
                fprintf(1,'(%s: node: %d, class: %d)\n',EventType.toText(self.event),self.node,self.class);
            else
                fprintf(1,'(%s: node: %d, class: %d, time: %d)\n',EventType.toText(self.event),self.node,self.class,self.t);
            end
        end
    end
    
    
end
