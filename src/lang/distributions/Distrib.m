classdef Distrib < Copyable
    % Distrib is an abstract class for statistical distributions.
    %
    % Copyright (c) 2012-2019, Imperial College London
    % All rights reserved.
    
    properties
        name
        params
        javaClass
        javaParClass
        support; % support interval
    end
    
    properties (Constant)
        Tol = 1e-3; % Tolerance for distribution fitting
        Inf = 1e10; % Generic representation of infinity
        InfTime = 1e10; % Conventional value associated to an infinite time
        InfRate = 1e10; % Conventional value associated to an infinite rate
    end
    
    methods %(Abstract)
        
        function X = sample(self)
            % X = SAMPLE()
            % Get n samples from the distribution
            error('An abstract method was invoked. The function needs to be overridden by a subclass.');
        end
        
        function MEAN = getMean(self)
            % MEAN = GETMEAN()
            % Get distribution mean
            error('An abstract method was invoked. The function needs to be overridden by a subclass.');
        end
        
        function SCV = getSCV(self)
            % SCV = GETSCV()
            % Get distribution squared coefficient of variation (SCV = variance / mean^2)
            error('An abstract method was invoked. The function needs to be overridden by a subclass.');
        end
        
        function VAR = getVariance(self)
            % VAR = GETVARIANCE()
            % Get distribution variance
            VAR = self.getSCV()*self.getMean()^2;
        end
        
        function SKEW = getSkewness(self)
            % SKEW = GETSKEWNESS()
            % Get distribution skewness
            error('An abstract method was invoked. The function needs to be overridden by a subclass.');
        end
        
        function Ft = evalCDF(self,t)
            % FT = EVALCDF(SELF,T)
            % Evaluate the cumulative distribution function at t
            error('An abstract method was invoked. The function needs to be overridden by a subclass.');
        end
        
        function L = evalLaplaceTransform(self, s)
            % L = EVALLAPLACETRANSFORM(S)
            % Evaluate the Laplace transform of the distribution function at t
            error('An abstract method was invoked. The function needs to be overridden by a subclass.');
            
        end
    end
    
    methods (Hidden)
        function self = Distrib(name, numParam, support)
            % SELF = DISTRIB(NAME, NUMPARAM, SUPPORT)
            % Construct a distribution from name, number of parameters, and
            % range
            self.name = name;
            self.support = support;
            self.setNumParams(numParam);
        end
    end
    
    methods
        function nParam = setNumParams(self, numParam)
            % NPARAM = SETNUMPARAMS(NUMPARAM)
            % Initializes the parameters
            self.params = cell(1,numParam);
            for i=1:numParam
                self.params{i}=struct('paramName','','paramValue',NaN,'paramClass','');
            end
        end
        
        function nParam = getNumParams(self)
            % NPARAM = GETNUMPARAMS()
            % Returns the number of parameters needed to specify the distribution
            nParam = length(self.params);
        end
        
        function setParam(self, id, name, value, typeClass)
            % SETPARAM(ID, NAME, VALUE, TYPECLASS)
            % Set a distribution parameter given id, name, value, Java
            % class type (for JMT translation)
            self.params{id}.paramName=name;
            self.params{id}.paramValue=value;
            self.params{id}.paramClass=typeClass;
        end
        
        function param = getParam(self,id)
            % PARAM = GETPARAM(SELF,ID)
            % Return the parameter associated to the given id
            param = self.params{id};
        end
        
        function bool = isDisabled(self)
            % BOOL = ISDISABLED()
            % Check if the distribution is equivalent to a Disabled
            % distribution
            %bool = cellfun(@(c) isnan(c.paramValue), self.params)
            bool = isnan(self.getMean()) || isa(self,'Disabled');
        end
        
        function bool = isImmediate(self)
            % BOOL = ISIMMEDIATE()
            % Check if the distribution is equivalent to an Immediate
            % distribution
            bool = self.getMean() == 0 || isa(self,'Immediate');
        end
        
        function bool = isContinuous(self)
            % BOOL = ISCONTINUOUS()
            % Check if the distribution is discrete
            bool = isa(self,'ContinuousDistrib');
        end
        
        function bool = isDiscrete(self)
            % BOOL = ISDISCRETE()
            % Check if the distribution is discrete
            bool = isa(self,'DiscreteDistrib');
        end
        
        function delta = evalCDFInterval(self,t0,t1)
            % DELTA = EVALCDFINTERVAL(SELF,T0,T1)
            % Evaluate the probability mass between t0 and t1 (t1>t0)
            if t1>=t0
                Ft1 = self.evalCDF(t1);
                Ft0 = self.evalCDF(t0);
                delta = Ft1 - Ft0;
            else
                error('CDF interval incorrectly specified (t1<t0)');
            end
        end
    end
end
