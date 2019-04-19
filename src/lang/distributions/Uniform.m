classdef Uniform < ContinuousDistrib
    % The uniform statistical distribution
    %
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    methods
        function self = Uniform(minVal, maxVal)
            % Constructs an uniform distribution with specified minimum and
            % maximum values
            self@ContinuousDistrib('Uniform',2,[minVal,maxVal]);
            setParam(self, 1, 'min', minVal, 'java.lang.Double');
            setParam(self, 2, 'max', maxVal, 'java.lang.Double');
%            self.javaClass = 'jmt.engine.random.Uniform';
%            self.javaParClass = 'jmt.engine.random.UniformPar';
        end
        
        function ex = getMean(self)
            % Get distribution mean
            ex = (self.getParam(2).paramValue+self.getParam(1).paramValue) / 2;
        end
        
        function SCV = getSCV(self)
            % Get distribution squared coefficient of variation (SCV = variance / mean^2)
            var = (self.getParam(2).paramValue-self.getParam(1).paramValue)^2 / 12;
            SCV = var/self.getMean()^2;
        end
        
        function Ft = evalCDF(self,t)
            % Evaluate the cumulative distribution function at t
            minVal = self.getParam(1).paramValue;
            maxVal = self.getParam(2).paramValue;
            if t < minVal
                Ft = 0;
            elseif t > maxVal
                Ft = 0;
            else
                Ft = 1/(maxVal-minVal);
            end
        end
        
        function X = sample(self, n)
            % Get n samples from the distribution
            if ~exist('n','var'), n = 1; end
            minVal = self.getParam(1).paramValue;
            maxVal = self.getParam(2).paramValue;
            X = minVal + (maxVal-minVal)*rand(n,1);
        end
    end
    
end

