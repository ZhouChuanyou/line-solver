classdef Coxian < MarkovianDistribution
    % The coxian statistical distribution
    %
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    methods
        function self = Coxian(varargin)
            % Constructs a Coxian distribution from phase rates and
            % completion probabilities, with entry probability 1 on the
            % first phase
            self@MarkovianDistribution('Coxian',2);
            
            if length(varargin)==2
                mu = varargin{1};
                phi = varargin{2};
                if abs(phi(end)-1)>Distrib.Tol && isfinite(phi(end))
                    error('The completion probability in the last Cox state must be 1.0 but it is %0.1f', phi(end));
                end
                self.setParam(1, 'mu', mu, 'java.lang.Double');
                self.setParam(2, 'phi', phi, 'java.lang.Double');
                self.javaClass = ''; % mapped in JMT to phase-type
                self.javaParClass = ''; % mapped in JMT to phase-type
            elseif length(varargin)==3
                mu1 = varargin{1};
                mu2 = varargin{2};
                phi1 = varargin{3};
                setParam(self, 1, 'lambda0', mu1, 'java.lang.Double');
                setParam(self, 2, 'lambda1', mu2, 'java.lang.Double');
                setParam(self, 3, 'phi0', phi1, 'java.lang.Double'); % completion probability in phase 1
                self.javaClass = 'jmt.engine.random.CoxianDistr';
                self.javaParClass = 'jmt.engine.random.CoxianPar';
            else
                error('Coxian accepts at most 3 parameters.');
            end
        end
    end
    
    methods
        function phases = getNumberOfPhases(self)
            % Return number of phases in the distribution
            if length(self.params) == 2
                phases  = length(self.getParam(1).paramValue);
            else
                phases  = 2;
            end
        end
        
        function ex = getMean(self)
            % Get distribution mean
            if length(self.params) == 2
                mu = self.getMu();
                phi = self.getPhi();
                ex = map_mean({diag(-mu)+diag(mu(1:end-1).*(1-phi(1:end-1)),1),[phi.*mu,zeros(length(mu),length(mu)-1)]});
            else
                % Get distribution mean
                mu1 = self.getParam(1).paramValue;
                mu2 = self.getParam(2).paramValue;
                phi1 = self.getParam(3).paramValue;
                ex = 1/mu1 + (1-phi1)/mu2;
            end
        end
        
        function SCV = getSCV(self)
            % Get distribution squared coefficient of variation (SCV = variance / mean^2)
            if length(self.params) == 2
                mu = self.getMu();
                phi = self.getPhi();
                SCV = map_scv({diag(-mu)+diag(mu(1:end-1).*(1-phi(1:end-1)),1),[phi.*mu,zeros(length(mu),length(mu)-1)]});
            else
                mu1 = self.getParam(1).paramValue;
                mu2 = self.getParam(2).paramValue;
                phi1 = self.getParam(3).paramValue;
                mean = 1/mu1 + (1-phi1)/mu2;
                var = ((2*mu2*(mu1 - mu1*phi1))/(mu1 + mu2 - mu1*phi1) + (2*mu1*mu2*phi1)/(mu1 + mu2 - mu1*phi1))/(mu1*mu1*((mu2*(mu1 - mu1*phi1))/(mu1 + mu2 - mu1*phi1) + (mu1*mu2*phi1)/(mu1 + mu2 - mu1*phi1))) - (1/mu1 - (phi1 - 1)/mu2)*(1/mu1 - (phi1 - 1)/mu2) - (((phi1 - 1)/(mu2*mu2) + (phi1 - 1)/(mu1*mu2))*((2*mu2*(mu1 - mu1*phi1))/(mu1 + mu2 - mu1*phi1) + (2*mu1*mu2*phi1)/(mu1 + mu2 - mu1*phi1)))/((mu2*(mu1 - mu1*phi1))/(mu1 + mu2 - mu1*phi1) + (mu1*mu2*phi1)/(mu1 + mu2 - mu1*phi1));
                SCV = var / mean^2;
            end
        end
        
        function PH = getRepresentation(self)
            % Return the renewal process associated to the distribution
            if length(self.params) == 2
                mu = self.getMu();
                phi = self.getPhi();
                PH = {diag(-mu)+diag(mu(1:end-1).*(1-phi(1:end-1)),1),[phi.*mu,zeros(length(mu),length(mu)-1)]};
            else
                mu1 = self.getParam(1).paramValue;
                mu2 = self.getParam(2).paramValue;
                phi1 = self.getParam(3).paramValue;
                PH={[-mu1,(1-phi1)*mu1;0,-mu2],[phi1*mu1,0;mu2,0]};
            end
        end
        
        function mu = getMu(self)
            % Get vector of rates
            if length(self.params) == 2
                mu = self.getParam(1).paramValue(:);
            else
                mu1 = self.getParam(1).paramValue;
                mu2 = self.getParam(2).paramValue;
                mu = [mu1;mu2];
            end
        end
        
        function phi = getPhi(self)
            % Get vector of completion probabilities
            if length(self.params) == 2
                phi = self.getParam(2).paramValue(:);
            else
                phi1 = self.getParam(3).paramValue;
                phi = [phi1;1.0];
            end
        end
        
    end
    
    methods(Static)
        function cx = fitCentral(MEAN, VAR, SKEW)
            cx = Cox2.fitCentral(MEAN, VAR, SKEW);
            SCV = VAR/MEAN^2;
            if abs(1-map_scv(cx.getRepresentation)/SCV) > 0.01
                cx = Coxian.fitMeanAndSCV(MEAN, SCV);                
            end
        end
        
        function [cx,mu,phi] = fitMeanAndSCV(MEAN, SCV)
            % Fit a Coxian distribution with given mean and squared coefficient of variation (SCV=variance/mean^2)
            if SCV >= 1-Distrib.Tol && SCV <= 1+Distrib.Tol
                n = 1;
                mu = 1/MEAN;
                phi = 1;
            elseif SCV > 0.5+Distrib.Tol && SCV<1-Distrib.Tol
                phi = 0.0;
                n = 2;
                mu = zeros(n,1);
                mu(1) = 2/MEAN/(1+sqrt(1+2*(SCV-1)));
                mu(2) = 2/MEAN/(1-sqrt(1+2*(SCV-1)));
            elseif SCV <= 0.5+Distrib.Tol
                n = ceil(1/SCV);
                lambda = n/MEAN;
                mu = lambda*ones(n,1);
                phi = zeros(n,1);
            else % SCV > 1+Distrib.Tol
                n = 2;
                %transform hyperexp into coxian
                mu = zeros(n,1);
                mu(1) = 2/MEAN;
                mu(2) = mu(1)/( 2*SCV );
                phi = zeros(n,1);
                phi(1) = 1 - mu(2)/mu(1);
                phi(2) = 1;
            end
            phi(n) = 1;
            cx = Coxian(mu,phi);
        end
    end
    
end

