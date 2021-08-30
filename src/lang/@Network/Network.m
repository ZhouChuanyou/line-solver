classdef Network < Model
    % An extended queueing network model.
    %
    % Copyright (c) 2012-2021, Imperial College London
    % All rights reserved.
    
    properties (Access=private)
        doChecks;
        hasState;
        logPath;
        usedFeatures; % structure of booleans listing the used classes
        % it must be accessed via getUsedLangFeatures that updates
        % the Distribution classes dynamically
    end
    
    properties (Hidden)
        sn;
        hasStruct;
    end
    
    properties (Hidden)
        handles;
        sourceidx; % cached value
        sinkidx; % cached value
    end
    
    properties
        classes;
        items;
        stations;
        nodes;
        connections;
    end
    
    methods % get methods
        nodes = getNodes(self)
        sa = getStruct(self, structType, wantState) % get abritrary representation
        used = getUsedLangFeatures(self) % get used features
        ft = getForks(self, rt) % get fork table
        [chainsObj,chainsMatrix] = getChains(self, rt) % get chain table
        [rt,rtNodes,connections,rtNodesByClass,rtNodesByStation] = getRoutingMatrix(self, arvRates) % get routing matrix
        [Q,U,R,T,A] = getAvgHandles(self)
        A = getAvgArvRHandles(self);
        T = getAvgTputHandles(self);
        Q = getAvgQLenHandles(self);
        R = getAvgRespTHandles(self);
        U = getAvgUtilHandles(self);
        [Qt,Ut,Tt] = getTranHandles(self)
        connections = getConnectionMatrix(self);
    end
    
    methods % link, reset, refresh methods
        self = link(self, P)
        self = linkFromNodeRoutingMatrix(self, Pnodes);
        [loggerBefore,loggerAfter] = linkAndLog(self, nodes, classes, P, wantLogger, logPath)
        [loggerBefore,loggerAfter] = linkNetworkAndLog(self, nodes, classes, P, wantLogger, logPath)% obsolete - old name
        sanitize(self);
        self = removeClass(self, jobclass);
        
        reset(self, resetState)
        resetHandles(self)
        resetModel(self, resetState)
        nodes = resetNetwork(self)
        resetStruct(self)
        
        refreshStruct(self, hard);
        [rates, scv, hasRateChanged, hasSCVChanged] = refreshRates(self, statSet, classSet);
        [ph, mu, phi, phases] = refreshServicePhases(self, statSet, classSet);
        proctypes = refreshServiceTypes(self);
        [rt, rtfun, rtnodes] = refreshRoutingMatrix(self, rates);
        [lt] = refreshLST(self, statSet, classSet);
        sync = refreshSync(self);
        classprio = refreshPriorities(self);
        [sched, schedid, schedparam] = refreshScheduling(self);
        [rates, mu, phi, phases] = refreshArrival(self);
        [rates, scv, mu, phi, phases] = refreshService(self, statSet, classSet);
        [chains, visits, rt] = refreshChains(self, propagate)
        [visits, nodevisits] = refreshVisits(self, chains, rt, rtNodes)
        [cap, classcap] = refreshCapacity(self);
        nvars = refreshLocalVars(self);
    end
    
    % PUBLIC METHODS
    methods (Access=public)
        
        %Constructor
        function self = Network(modelName)
            % SELF = NETWORK(MODELNAME)
            self@Model(modelName);
            self.nodes = {};
            self.stations = {};
            self.classes = {};
            self.connections = [];
            initUsedFeatures(self);
            self.sn = [];
            self.hasState = false;
            self.logPath = '';
            self.items = {};
            self.sourceidx = [];
            self.sinkidx = [];
            self.setChecks(true);
            self.hasStruct = false;
        end
        
        setInitialized(self, bool);
        
        function self = setChecks(self, bool)
            self.doChecks = bool;
        end
        
        P = getLinkedRoutingMatrix(self)
        
        function logPath = getLogPath(self)
            % LOGPATH = GETLOGPATH()
            
            logPath = self.logPath;
        end
        
        function setLogPath(self, logPath)
            % SETLOGPATH(LOGPATH)
            
            self.logPath = logPath;
        end
        
        bool = hasInitState(self)
        
        function [M,R] = getSize(self)
            % [M,R] = GETSIZE()
            
            M = self.getNumberOfNodes;
            R = self.getNumberOfClasses;
        end
        
        function bool = hasOpenClasses(self)
            % BOOL = HASOPENCLASSES()
            
            bool = any(isinf(getNumberOfJobs(self)));
        end
        
        function bool = hasClassSwitch(self)
            % BOOL = HASCLASSSWITCH()
            
            bool = any(cellfun(@(c) isa(c,'ClassSwitch'), self.nodes));
        end
        
        function bool = hasJoin(self)
            % BOOL = HASJOIN()
            
            bool = any(cellfun(@(c) isa(c,'Join'), self.nodes));
        end
        
        function bool = hasClosedClasses(self)
            % BOOL = HASCLOSEDCLASSES()
            
            bool = any(isfinite(getNumberOfJobs(self)));
        end
        
        function index = getIndexOpenClasses(self)
            % INDEX = GETINDEXOPENCLASSES()
            
            index = find(isinf(getNumberOfJobs(self)))';
        end
        
        function index = getIndexClosedClasses(self)
            % INDEX = GETINDEXCLOSEDCLASSES()
            
            index = find(isfinite(getNumberOfJobs(self)))';
        end
        
        c = getClassChain(self, className)
        classNames = getClassNames(self)
        
        nodeNames = getNodeNames(self)
        nodeTypes = getNodeTypes(self)
        
        P = initRoutingMatrix(self)
        
        rtTypes = getRoutingStrategies(self)
        ind = getNodeIndex(self, name)
        lldScaling = getLimitedLoadDependence(self)
		lcdScaling = getLimitedClassDependence(self)
        
        function stationIndex = getStationIndex(self, name)
            % STATIONINDEX = GETSTATIONINDEX(NAME)
            
            if isa(name,'Node')
                node = name;
                name = node.getName();
            end
            stationIndex = find(cellfun(@(c) strcmp(c,name),self.getStationNames));
        end
        
        function statefulIndex = getStatefulNodeIndex(self, name)
            % STATEFULINDEX = GETSTATEFULNODEINDEX(NAME)
            
            if isa(name,'Node')
                node = name;
                name = node.getName();
            end
            statefulIndex = find(cellfun(@(c) strcmp(c,name),self.getStatefulNodeNames));
        end
        
        function classIndex = getClassIndex(self, name)
            % CLASSINDEX = GETCLASSINDEX(NAME)
            if isa(name,'JobClass')
                jobclass = name;
                name = jobclass.getName();
            end
            classIndex = find(cellfun(@(c) strcmp(c,name),self.getClassNames));
        end
        
        function stationnames = getStationNames(self)
            % STATIONNAMES = GETSTATIONNAMES()
            
            if self.hasStruct
                stationnames = {self.sn.nodenames{self.sn.isstation}}';
            else
                stationnames = {};
                for i=self.getIndexStations
                    stationnames{end+1,1} = self.nodes{i}.name;
                end
            end
        end
        
        function nodes = getNodeByName(self, name)
            % NODES = GETNODEBYNAME(SELF, NAME)
            idx = findstring(self.getNodeNames,name);
            if idx > 0
                nodes = self.nodes{idx};
            else
                nodes = NaN;
            end
        end
        
        function station = getStationByName(self, name)
            % STATION = GETSTATIONBYNAME(SELF, NAME)
            idx = findstring(self.getStationNames,name);
            if idx > 0
                station = self.stations{idx};
            else
                station = NaN;
            end
        end
        
        function class = getClassByName(self, name)
            % CLASS = GETCLASSBYNAME(SELF, NAME)
            idx = findstring(self.getClassNames,name);
            if idx > 0
                class = self.classes{idx};
            else
                class = NaN;
            end
        end
        
        function nodes = getNodeByIndex(self, idx)
            % NODES = GETNODEBYINDEX(SELF, NAME)
            if idx > 0
                nodes = self.nodes{idx};
            else
                nodes = NaN;
            end
        end
        
        function station = getStationByIndex(self, idx)
            % STATION = GETSTATIONBYINDEX(SELF, NAME)
            if idx > 0
                station = self.stations{idx};
            else
                station = NaN;
            end
        end
        
        function class = getClassByIndex(self, idx)
            % CLASS = GETCLASSBYINDEX(SELF, NAME)
            if idx > 0
                class = self.classes{idx};
            else
                class = NaN;
            end
        end
        
        function [infGen, eventFilt, ev] =  getGenerator(self, varargin)
            line_warning(mfilename,'Results will not be cached. Use SolverCTMC(model,...).getGenerator(...) instead.\n');
            [infGen, eventFilt, ev] = SolverCTMC(self).getGenerator(varargin{:});
        end
        
        function [stateSpace,nodeStateSpace] = getStateSpace(self, varargin)            
            line_warning(mfilename,'Results will not be cached. Use SolverCTMC(model,...).getStateSpace(...) instead.\n');
            [stateSpace,nodeStateSpace] = SolverCTMC(self).getStateSpace(varargin{:});
        end
        
        function summary(self)
            % SUMMARY()
            
            for i=1:self.getNumberOfNodes
                self.nodes{i}.summary();
            end
        end
        
        function [D,Z] = getDemands(self)
            % [D,Z]= GETDEMANDS()
            
            [~,D,~,Z,~,~] = snGetProductFormParams(self.getStruct);
        end
        
        function [lambda,D,N,Z,mu,S]= getProductFormParameters(self)
            % [LAMBDA,D,N,Z,MU,S]= GETPRODUCTFORMPARAMETERS()
            
            % mu also returns max(S) elements after population |N| as this is
            % required by MVALDMX
            
            [lambda,D,N,Z,mu,S] = snGetProductFormParams(self.getStruct);
        end
        
        function statefulnodes = getStatefulNodes(self)
            statefulnodes = {};
            for i=1:self.getNumberOfNodes
                if self.nodes{i}.isStateful
                    statefulnodes{end+1,1} = self.nodes{i};
                end
            end
        end
        
        function statefulnames = getStatefulNodeNames(self)
            % STATEFULNAMES = GETSTATEFULNODENAMES()
            
            statefulnames = {};
            for i=1:self.getNumberOfNodes
                if self.nodes{i}.isStateful
                    statefulnames{end+1,1} = self.nodes{i}.name;
                end
            end
        end
        
        function M = getNumberOfNodes(self)
            % M = GETNUMBEROFNODES()
            
            M = length(self.nodes);
        end
        
        function S = getNumberOfStatefulNodes(self)
            % S = GETNUMBEROFSTATEFULNODES()
            
            S = sum(cellisa(self.nodes,'StatefulNode'));
        end
        
        function M = getNumberOfStations(self)
            % M = GETNUMBEROFSTATIONS()
            
            M = length(self.stations);
        end
        
        function R = getNumberOfClasses(self)
            % R = GETNUMBEROFCLASSES()
            
            R = length(self.classes);
        end
        
        function C = getNumberOfChains(self)
            % C = GETNUMBEROFCHAINS()
            
            sn = self.getStruct;
            C = sn.nchains;
        end
        
        function Dchain = getDemandsChain(self)
            % DCHAIN = GETDEMANDSCHAIN()
            snGetDemandsChain(self.getStruct);
        end
        
        % setUsedFeatures : records that a certain language feature has been used
        function self = setUsedFeatures(self,className)
            % SELF = SETUSEDFEATURES(SELF,CLASSNAME)
            
            self.usedFeatures.setTrue(className);
        end
        
        %% Add the components to the model
        addJobClass(self, customerClass);
        addNode(self, node);
        addLink(self, nodeA, nodeB);
        addLinks(self, nodeList);
        addItemSet(self, itemSet);
        self = disableMetric(self, Y);
        self = enableMetric(self, Y);
        
        node = getSource(self);
        node = getSink(self);
        
        function list = getDummys(self)
            % LIST = GETDUMMYS()
            
            list = find(cellisa(self.nodes, 'Passage'))';
        end
        
        function list = getIndexStations(self)
            % LIST = GETINDEXSTATIONS()
            
            if self.hasStruct
                list = find(self.sn.isstation)';
            else
                % returns the ids of nodes that are stations
                list = find(cellisa(self.nodes, 'Station'))';
            end
        end
        
        function list = getIndexStatefulNodes(self)
            % LIST = GETINDEXSTATEFULNODES()
            
            % returns the ids of nodes that are stations
            list = find(cellisa(self.nodes, 'StatefulNode'))';
        end
        
        index = getIndexSourceStation(self);
        index = getIndexSourceNode(self);
        index = getIndexSinkNode(self);
        
        N = getNumberOfJobs(self);
        refstat = getReferenceStations(self);
        sched = getStationScheduling(self);
        S = getStationServers(self);
        
        jsimwView(self)
        jsimgView(self)
        
        function [ni, nir, sir, kir] = initToMarginal(self)
            % [NI, NIR, SIR, KIR] = INITTOMARGINAL()
            
            [ni, nir, sir, kir] = snInitToMarginal(self.getStruct);
        end
        
        function islld = isLimitedLoadDependent(self)
            sn = self.getStruct;
            if isempty(sn.lldscaling)
                islld = false;
            else
                islld = true;                
            end
        end
        
        function [isvalid] = isStateValid(self)
            % [ISVALID] = ISSTATEVALID()
            
            isvalid = snIsStateValid(self.getStruct);
        end
        
        [initialStateAggr] = getStateAggr(self) % get initial state
        [initialState, priorInitialState] = getState(self) % get initial state
        
        initFromAvgTableQLen(self, AvgTable)
        initFromAvgQLen(self, AvgQLen)
        initDefault(self, nodes)
        initFromMarginal(self, n, options) % n(i,r) : number of jobs of class r in node i
        initFromMarginalAndRunning(self, n, s, options) % n(i,r) : number of jobs of class r in node i
        initFromMarginalAndStarted(self, n, s, options) % n(i,r) : number of jobs of class r in node i
        
        [H,G] = getGraph(self)
        
        function mask = getClassSwitchingMask(self)
            % MASK = GETCLASSSWITCHINGMASK()
            
            mask = self.getStruct.csmask;
        end
        
        function printRoutingMatrix(self)
            % PRINTROUTINGMATRIX()
            
            snPrintRoutingMatrix(self.getStruct);
        end
    end
    
    % Private methods
    methods (Access = 'private')
        
        function out = getModelNameExtension(self)
            % OUT = GETMODELNAMEEXTENSION()
            
            out = [getModelName(self), ['.', self.fileFormat]];
        end
        
        function self = initUsedFeatures(self)
            % SELF = INITUSEDFEATURES()
            
            % The list includes all classes but Model and Hidden or
            % Constant or Abstract or Solvers
            self.usedFeatures = SolverFeatureSet;
        end
    end
    
    methods(Access = protected)
        % Override copyElement method:
        function clone = copyElement(self)
            % CLONE = COPYELEMENT()
            
            % Make a shallow copy of all properties
            clone = copyElement@Copyable(self);
            % Make a deep copy of each handle
            for i=1:length(self.classes)
                clone.classes{i} = self.classes{i}.copy;
            end
            % Make a deep copy of each handle
            for i=1:length(self.nodes)
                clone.nodes{i} = self.nodes{i}.copy;
                if isa(clone.nodes{i},'Station')
                    clone.stations{i} = clone.nodes{i};
                end
                clone.connections = self.connections;
            end
        end
    end
    
    methods % wrappers
        function bool = hasFCFS(self)
            % BOOL = HASFCFS()
            
            bool = snHasFCFS(self.getStruct);
        end
        
        function bool = hasHomogeneousScheduling(self, strategy)
            % BOOL = HASHOMOGENEOUSSCHEDULING(STRATEGY)
            
            bool = snHasHomogeneousScheduling(self.getStruct, strategy);
        end
        
        function bool = hasDPS(self)
            % BOOL = HASDPS()
            
            bool = snHasDPS(self.getStruct);
        end
        
        function bool = hasGPS(self)
            % BOOL = HASGPS()
            
            bool = snHasGPS(self.getStruct);
        end
        
        function bool = hasINF(self)
            % BOOL = HASINF()
            
            bool = snHasINF(self.getStruct);
        end
        
        function bool = hasPS(self)
            % BOOL = HASPS()
            
            bool = snHasPS(self.getStruct);
        end
        
        function bool = hasRAND(self)
            % BOOL = HASRAND()
            
            bool = snHasRAND(self.getStruct);
        end
        
        function bool = hasHOL(self)
            % BOOL = HASHOL()
            
            bool = snHasHOL(self.getStruct);
        end
        
        function bool = hasLCFS(self)
            % BOOL = HASLCFS()
            
            bool = snHasLCFS(self.getStruct);
        end
        
        function bool = hasSEPT(self)
            % BOOL = HASSEPT()
            
            bool = snHasSEPT(self.getStruct);
        end
        
        function bool = hasLEPT(self)
            % BOOL = HASLEPT()
            
            bool = snHasLEPT(self.getStruct);
        end
        
        function bool = hasSJF(self)
            % BOOL = HASSJF()
            
            bool = snHasSJF(self.getStruct);
        end
        
        function bool = hasLJF(self)
            % BOOL = HASLJF()
            
            bool = snHasLJF(self.getStruct);
        end
        
        function bool = hasMultiClassFCFS(self)
            % BOOL = HASMULTICLASSFCFS()
            
            bool = snHasMultiClassFCFS(self.getStruct);
        end
        
        function bool = hasMultiServer(self)
            % BOOL = HASMULTISERVER()
            
            bool = snHasMultiServer(self.getStruct);
        end
        
        function bool = hasSingleChain(self)
            % BOOL = HASSINGLECHAIN()
            
            bool = snHasSingleChain(self.getStruct);
        end
        
        function bool = hasMultiChain(self)
            % BOOL = HASMULTICHAIN()
            
            bool = snHasMultiChain(self.getStruct);
        end
        
        function bool = hasSingleClass(self)
            % BOOL = HASSINGLECLASS()
            
            bool = snHasSingleClass(self.getStruct);
        end
        
        function bool = hasMultiClass(self)
            % BOOL = HASMULTICLASS()
            
            bool = snHasMultiClass(self.getStruct);
        end
        
        function print(self)
            LINE2SCRIPT(self)
        end
    end
    
    methods
        function bool = hasProductFormSolution(self)
            % BOOL = HASPRODUCTFORMSOLUTION()
            
            bool = true;
            % language features
            featUsed = getUsedLangFeatures(self).list;
            if featUsed.Fork, bool = false; end
            if featUsed.Join, bool = false; end
            if featUsed.MMPP2, bool = false; end
            if featUsed.Normal, bool = false; end
            if featUsed.Pareto, bool = false; end
            if featUsed.Weibull, bool = false; end
            if featUsed.Lognormal, bool = false; end
            if featUsed.Replayer, bool = false; end
            if featUsed.Uniform, bool = false; end
            if featUsed.Fork, bool = false; end
            if featUsed.Join, bool = false; end
            if featUsed.SchedStrategy_LCFS, bool = false; end % must be LCFS-PR
            if featUsed.SchedStrategy_SJF, bool = false; end
            if featUsed.SchedStrategy_LJF, bool = false; end
            if featUsed.SchedStrategy_DPS, bool = false; end
            if featUsed.SchedStrategy_GPS, bool = false; end
            if featUsed.SchedStrategy_SEPT, bool = false; end
            if featUsed.SchedStrategy_LEPT, bool = false; end
            if featUsed.SchedStrategy_HOL, bool = false; end
            % modelling features
            if self.hasMultiClassFCFS, bool = false; end
        end
        
        function plot(self)     
            % PLOT()
            [~,H] = self.getGraph;
            H.Nodes.Name=strrep(H.Nodes.Name,'_','\_');                        
            h=plot(H,'EdgeLabel',H.Edges.Weight,'Layout','Layered');
            highlight(h,self.getNodeTypes==3,'NodeColor','r'); % class-switch nodes
        end
    end
    
    methods (Static)
        function model = tandemPs(lambda,D)
            % MODEL = TANDEMPS(LAMBDA,D)
            
            model = Network.tandemPsInf(lambda,D,[]);
        end
        
        function model = tandemPsInf(lambda,D,Z)
            % MODEL = TANDEMPSINF(LAMBDA,D,Z)
            
            if nargin<3%~exist('Z','var')
                Z = [];
            end
            M  = size(D,1);
            Mz = size(Z,1);
            strategy = {};
            for i=1:Mz
                strategy{i} = SchedStrategy.INF;
            end
            for i=1:M
                strategy{Mz+i} = SchedStrategy.PS;
            end
            model = Network.tandem(lambda,[Z;D],strategy);
        end
        
        function model = tandemFcfs(lambda,D)
            % MODEL = TANDEMFCFS(LAMBDA,D)
            
            model = Network.tandemFcfsInf(lambda,D,[]);
        end
        
        function model = tandemFcfsInf(lambda,D,Z)
            % MODEL = TANDEMFCFSINF(LAMBDA,D,Z)
            
            if nargin<3%~exist('Z','var')
                Z = [];
            end
            M  = size(D,1);
            Mz = size(Z,1);
            strategy = {};
            for i=1:Mz
                strategy{i} = SchedStrategy.INF;
            end
            for i=1:M
                strategy{Mz+i} = SchedStrategy.FCFS;
            end
            model = Network.tandem(lambda,[Z;D],strategy);
        end
        
        function model = tandem(lambda,S,strategy)
            % MODEL = TANDEM(LAMBDA,S,STRATEGY)
            
            % S(i,r) - mean service time of class r at station i
            % lambda(r) - number of jobs of class r
            % station(i) - scheduling strategy at station i
            model = Network('Model');
            [M,R] = size(S);
            node{1} = Source(model, 'Source');
            for i=1:M
                switch SchedStrategy.toId(strategy{i})
                    case SchedStrategy.ID_INF
                        node{end+1} = DelayStation(model, ['Station',num2str(i)]);
                    otherwise
                        node{end+1} = Queue(model, ['Station',num2str(i)], strategy{i});
                end
            end
            node{end+1} = Sink(model, 'Sink');
            P = cellzeros(R,R,M+2,M+2);
            for r=1:R
                jobclass{r} = OpenClass(model, ['Class',num2str(r)], 0);
                P{r,r} = circul(length(node)); P{r}(end,:) = 0;
            end
            for r=1:R
                node{1}.setArrival(jobclass{r}, Exp.fitMean(1/lambda(r)));
                for i=1:M
                    node{1+i}.setService(jobclass{r}, Exp.fitMean(S(i,r)));
                end
            end
            model.link(P);
        end
        
        function model = productForm(N,D,Z)
            if nargin<3
                Z = [];
            end
            model = Network.cyclicPsInf(N,D,Z);
        end
        
        function model = cyclicPs(N,D)
            % MODEL = CYCLICPS(N,D)
            
            model = Network.cyclicPsInf(N,D,[]);
        end
        
        function model = cyclicPsInf(N,D,Z)
            % MODEL = CYCLICPSINF(N,D,Z)
            if nargin<3
                Z = [];
            end
            M  = size(D,1);
            Mz = size(Z,1);
            strategy = cell(M+Mz,1);
            for i=1:Mz
                strategy{i} = SchedStrategy.INF;
            end
            for i=1:M
                strategy{Mz+i} = SchedStrategy.PS;
            end
            model = Network.cyclic(N,[Z;D],strategy);
        end
        
        function model = cyclicFcfs(N,D)
            % MODEL = CYCLICFCFS(N,D)
            
            model = Network.cyclicFcfsInf(N,D,[]);
        end
        
        function model = cyclicFcfsInf(N,D,Z)
            % MODEL = CYCLICFCFSINF(N,D,Z)
            
            if nargin<3%~exist('Z','var')
                Z = [];
            end
            M  = size(D,1);
            Mz = size(Z,1);
            strategy = {};
            for i=1:Mz
                strategy{i} = SchedStrategy.INF;
            end
            for i=1:M
                strategy{Mz+i} = SchedStrategy.FCFS;
            end
            model = Network.cyclic(N,[Z;D],strategy);
        end
        
        function model = cyclic(N,D,strategy)
            % MODEL = CYCLIC(N,D,STRATEGY)
            
            % L(i,r) - demand of class r at station i
            % N(r) - number of jobs of class r
            % strategy(i) - scheduling strategy at station i
            model = Network('Model');
            [M,R] = size(D);
            node = cell(M,1);
            nQ = 0; nD = 0;
            for i=1:M
                switch SchedStrategy.toId(strategy{i})
                    case SchedStrategy.ID_INF
                        nD = nD + 1;
                        node{i} = DelayStation(model, ['Delay',num2str(nD)]);
                    otherwise
                        nQ = nQ + 1;
                        node{i} = Queue(model, ['Queue',num2str(nQ)], strategy{i});
                end
            end
            P = cellzeros(R,M);
            jobclass = cell(R,1);
            for r=1:R
                jobclass{r} = ClosedClass(model, ['Class',num2str(r)], N(r), node{1}, 0);
                P{r,r} = circul(M);
            end
            for i=1:M
                for r=1:R
                    node{i}.setService(jobclass{r}, Exp.fitMean(D(i,r)));
                end
            end
            model.link(P);
        end
        
        function P = serialRouting(varargin)
            % P = SERIALROUTING(VARARGIN)
            
            if length(varargin)==1
                varargin = varargin{1};
            end
            model = varargin{1}.model;
            P = zeros(model.getNumberOfNodes);
            for i=1:length(varargin)-1
                P(varargin{i},varargin{i+1})=1;
            end
            if ~isa(varargin{end},'Sink')
                P(varargin{end},varargin{1})=1;
            end
            P = P ./ repmat(sum(P,2),1,length(P));
            P(isnan(P)) = 0;
        end
        
        function printInfGen(Q,SS)
            % PRINTINFGEN(Q,SS)
            SolverCTMC.printInfGen(Q,SS);
        end
        
        function printEventFilt(sync,D,SS,myevents)
            % PRINTEVENTFILT(SYNC,D,SS,MYEVENTS)
            SolverCTMC.printEventFilt(sync,D,SS,myevents);
        end
        
        function ret = exportNetworkStruct(sn, language)
            % @todo unfinished
            if nargin<2
                language='json';
            end
            ret = javaObject('java.util.HashMap');
            switch language
                case {'json'}
                    sn.rtfun = func2str(sn.rtfun);
                    for i=1:size(sn.lst,1)
                        for r=1:length(sn.lst{i})
                            if ~isempty(sn.lst{i}{r})
                                sn.lst{i}{r}=func2str(sn.lst{i}{r});
                            end
                        end
                    end
                    ret = jsonencode(sn);
                case {'java'}
                    fieldNames = fields(sn);
                    for f=1:length(fieldNames)
                        switch fieldNames{f}
                            case 'sync'
                                %noop
                            otherwise
                                field = sn.(fieldNames{f});
                                
                        end
                        ret.put(fieldNames{f},exportJava(field));
                    end
            end            
        end        
    end
end
