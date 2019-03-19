classdef StatefulClassSwitcher < ClassSwitcher
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    methods
        %Constructor
        function self = StatefulClassSwitcher(classes, name)
            self = self@ClassSwitcher(classes, name);
            self.csFun = @(r, s, state, statep) StatefulClassSwitcher.classHolderFun(r, s, state, statep); % do nothing by default
        end        
    end
    
    methods (Static)
        function prob = classHolderFun(r, s, state, statep) 
            if ~isempty(state)
                % probability of switching from r to s given state
                if r == s
                    prob = 1;
                else
                    prob = 0;
                end
            else % if state == [] then return 1 if r->s is feasible
                if r == s
                    prob = 1;
                else
                    prob = 0;
                end
            end
        end
    end
end