classdef Queue < Station
    % A service station with queueing
    %
    % Copyright (c) 2012-2022, Imperial College London
    % All rights reserved.
    
    properties
        schedPolicy;
        schedStrategy;
        schedStrategyPar;
        serviceProcess;
    end
    
    methods
        %Constructor
        function self = Queue(model, name, schedStrategy)
            % SELF = QUEUE(MODEL, NAME, SCHEDSTRATEGY)
            
            self@Station(name);
            
            classes = model.classes;
            self.input = Buffer(classes);
            self.output = Dispatcher(classes);
            self.schedPolicy = SchedStrategyType.PR;
            self.schedStrategy = SchedStrategy.ID_PS;
            self.serviceProcess = {};
            self.server = Server(classes);
            self.numberOfServers = 1;
            self.schedStrategyPar = zeros(1,length(model.classes));
            self.setModel(model);
            self.model.addNode(self);
            self.dropRule = [];
            
            if nargin>=3 %exist('schedStrategy','var')
                self.schedStrategy = schedStrategy;
                switch SchedStrategy.toId(self.schedStrategy)
                    case {SchedStrategy.ID_PS, SchedStrategy.ID_DPS,SchedStrategy.ID_GPS}
                        self.schedPolicy = SchedStrategyType.PR;
                        self.server = SharedServer(classes);
                    case SchedStrategy.ID_LCFSPR
                        self.schedPolicy = SchedStrategyType.PR;
                        self.server = PreemptiveServer(classes);                        
                    case {SchedStrategy.ID_FCFS, SchedStrategy.ID_LCFS, SchedStrategy.ID_SIRO, SchedStrategy.ID_SEPT, SchedStrategy.ID_LEPT, SchedStrategy.ID_SJF, SchedStrategy.ID_LJF}
                        self.schedPolicy = SchedStrategyType.NP;
                        self.server = Server(classes);
                    case SchedStrategy.ID_INF
                        self.schedPolicy = SchedStrategyType.NP;
                        self.server = InfiniteServer(classes);
                        self.numberOfServers = Inf;
                    case SchedStrategy.ID_HOL
                        self.schedPolicy = SchedStrategyType.NP;
                        self.server = Server(classes);
                    otherwise
                        line_error(mfilename,sprintf('The specified scheduling strategy (%s) is unsupported.',schedStrategy));
                end
            end
        end
                
        function setLoadDependence(self, alpha)
            switch SchedStrategy.toId(self.schedStrategy)
                case {SchedStrategy.ID_PS, SchedStrategy.ID_FCFS}
                    setLimitedLoadDependence(self, alpha);                    
                otherwise
                    line_error(mfilename,'Load-dependence supported only for processor sharing (PS) and first-come first-serve (FCFS) stations.');
            end
        end
        
        function setClassDependence(self, beta)            
            switch SchedStrategy.toId(self.schedStrategy)
                case {SchedStrategy.ID_PS, SchedStrategy.ID_FCFS}
                    setLimitedClassDependence(self, beta);                    
                otherwise
                    line_error(mfilename,'Class-dependence supported only for processor sharing (PS) and first-come first-serve (FCFS) stations.');
            end
        end
        
        function setNumberOfServers(self, value)
            % SETNUMBEROFSERVERS(VALUE)
            switch SchedStrategy.toId(self.schedStrategy)
                case SchedStrategy.ID_INF
                    %line_warning(mfilename,'A request to change the number of servers in an infinite server node has been ignored.');
                    %ignore
                otherwise
                    self.setNumServers(value);
            end
        end
        
        function setNumServers(self, value)
            % SETNUMSERVERS(VALUE)
            
            switch SchedStrategy.toId(self.schedStrategy)
                case {SchedStrategy.ID_DPS, SchedStrategy.ID_GPS}
                    if value ~= 1
                        line_error(mfilename,sprintf('Cannot use multi-server stations with %s scheduling.', self.schedStrategy));
                    end
                otherwise
                    self.numberOfServers = value;
            end
        end
        
        function self = setStrategyParam(self, class, weight)
            % SELF = SETSTRATEGYPARAM(CLASS, WEIGHT)
            
            self.schedStrategyPar(class.index) = weight;
        end
        
        function distribution = getService(self, class)
            % DISTRIBUTION = GETSERVICE(CLASS)
            
            % return the service distribution assigned to the given class
            if nargin<2 %~exist('class','var')
                for s = 1:length(self.model.classes)
                    distribution{s} = self.server.serviceProcess{1, self.model.classes{s}}{3};
                end
            else
                try
                    distribution = self.server.serviceProcess{1, class.index}{3};
                catch ME
                    distribution = [];
                    line_warning(mfilename,'No distribution is available for the specified class');
                end
            end
        end
        
        function distrib = getServiceProcess(self, oclass)
            distrib = self.getService{oclass};
        end
        
        
        function setService(self, class, distribution, weight)
            % SETSERVICE(CLASS, DISTRIBUTION, WEIGHT)
            if nargin<4 %~exist('weight','var')
                weight=1.0;
            end
            if distribution.isImmediate()
                distribution = Immediate.getInstance();
            end
            server = self.server; % by reference
            c = class.index;
            if length(server.serviceProcess) >= c && ~isempty(server.serviceProcess{1,c}) % if the distribution was already configured                   
                    % this is a forced state reset in case for example the number of phases changes
                    % appears to run faster without checks, probably due to
                    % isa being slow
                    %oldDistribution = server.serviceProcess{1, c}{3};
                    %isOldMarkovian = isa(oldDistribution,'MarkovianDistribution');
                    %isNewMarkovian = isa(distribution,'MarkovianDistribution');
                    %if distribution.getNumParams ~= oldDistribution.getNumParams 
                    % %|| (isOldMarkovian && ~isNewMarkovian) || (~isOldMarkovian && isNewMarkovian) || (isOldMarkovian && isNewMarkovian && distribution.getNumberOfPhases ~= oldDistribution.getNumberOfPhases)
                        self.model.setInitialized(false); % this is a better way to invalidate to avoid that sequential calls to setService all trigger an initDefault
                        self.state=[]; % reset the state vector
                    %end
            else % if first configuration
                if length(self.classCap) < c
                    self.classCap((length(self.classCap)+1):c) = Inf;
                end
                self.input.inputJobClasses{c} = {class, self.schedPolicy, DropStrategy.WaitingQueue};
                self.setStrategyParam(class, weight);
                self.dropRule(c) = DropStrategy.ID_WAITQ;
                server.serviceProcess{1, c}{2} = ServiceStrategy.LI;                                       
            end
            server.serviceProcess{1, c}{3} = distribution;
            self.serviceProcess{c} = distribution;            
        end
        
        function sections = getSections(self)
            % SECTIONS = GETSECTIONS()
            
            sections = {self.input, self.server, self.output};
        end
        
        %        function distrib = getServiceProcess(self, oclass)
        %            distrib = self.serviceProcess{oclass};
        %        end
        
    end
end
