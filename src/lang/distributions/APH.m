classdef APH < MarkovianDistribution
    % An astract class for acyclic phase-type distributions
    %
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    methods
        function self = APH(alpha, T)
            % Abstract class constructor
            self@MarkovianDistribution('APH', 2);
            self.setParam(1, 'alpha', alpha, 'java.lang.Double');
            self.setParam(2, 'T', T, 'java.lang.Double');
        end
    end
    
    methods
        function alpha = getInitProb(self)
            % Get vector of initial probabilities
            alpha = self.getParam(1).paramValue(:);
            alpha = reshape(alpha,1,length(alpha));
        end
        
        function T = getGenerator(self)
            % Get generator
            T = self.getParam(2).paramValue;
        end
        
        function X = sample(self, n)
            % Get n samples from the distribution
            if ~exist('n','var'), n = 1; end
            X = map_sample(self.getRepresentation,n);
        end
    end
    
    methods
        function update(self,varargin)
            % Update parameters to match the first n central moments
            % (n<=4)
            MEAN = varargin{1};
            SCV = varargin{2}/MEAN^2;
            SKEW = varargin{3};
            if length(varargin) > 3
                warning('Warning: update in %s distributions can only handle 3 moments, ignoring higher-order moments.',class(self));
            end
            e1 = MEAN;
            e2 = (1+SCV)*e1^2;
            e3 = -(2*e1^3-3*e1*e2-SKEW*(e2-e1^2)^(3/2));
            [alpha,T] = APHFrom3Moments([e1,e2,e3]);
            self.setParam(1, 'alpha', alpha, 'java.lang.Double');
            self.setParam(2, 'T', T, 'java.lang.Double');
        end
        
        function updateMean(self,MEAN)
            % Update parameters to match the given mean
            APH = self.getRepresentation;
            APH = map_scale(APH,MEAN);
            self.setParam(1, 'alpha', map_pie(APH), 'java.lang.Double');
            self.setParam(2, 'T', APH{1}, 'java.lang.Double');
        end
        
        function updateMeanAndSCV(self, MEAN, VAR)
            % Fit phase-type distribution with given mean and squared coefficient of
            % variation (SCV=variance/mean^2)
            e1 = MEAN;
            SCV = VAR / MEAN^2;
            e2 = (1+SCV)*e1^2;
            [alpha,T] = APHFrom2Moments([e1,e2]);
            self.setParam(1, 'alpha', alpha, 'java.lang.Double');
            self.setParam(2, 'T', T, 'java.lang.Double');
        end
        
        function APH = getRepresentation(self)
            % Return the renewal process associated to the distribution
            T = self.getGenerator;
            APH = {T,-T*ones(length(T),1)*self.getInitProb};
        end
        
    end
    
    methods (Static)
        function ex = fitCentral(MEAN, VAR, SKEW)
            % Fit the distribution from first three central moments (mean,
            % variance, skewness)
            ex = APH(1.0, [1]);
            ex.update(MEAN, VAR, SKEW);
        end
        
        function ex = fitMeanAndSCV(MEAN, SCV)
            % Fit the distribution from first three central moments (mean,
            % variance, skewness)
            ex = APH(1.0, [1]);
            ex.updateMeanAndSCV(MEAN, SCV);
        end
    end
    
end