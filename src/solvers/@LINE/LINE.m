classdef LINE
    %A solver that selects the solution method based on the model characteristics.

    %Copyright (c) 2012-2022, Imperial College London
    %All rights reserved.

    properties
        CANDIDATE_MVA = 1;
        CANDIDATE_NC = 2;
        CANDIDATE_MAM = 3;
        CANDIDATE_FLUID = 4;
        CANDIDATE_JMT = 5;
        CANDIDATE_SSA = 6;
        CANDIDATE_CTMC = 7;
        %
        CANDIDATE_LQNS = 1;
        CANDIDATE_LN_NC = 2;
        CANDIDATE_LN_MVA = 3;
        CANDIDATE_LN_MAM = 4;
    end

    properties
        candidates; % feasible solvers
        solvers;
        model;
        options;
        name;
    end

    methods
        %Constructor
        function self = LINE(model, varargin)
            %SELF = LINE(MODEL, VARARGIN)
            self.options = Solver.parseOptions(varargin, Solver.defaultOptions);
            self.model = model;
            self.name = 'LINE';
            if self.options.verbose
                line_printf('Running LINE version %s',model.getVersion);
            end
            %solvers sorted from fastest to slowest
            self.solvers = {};
            switch class(model)
                case 'Network'
                    self.solvers{1,self.CANDIDATE_MAM} = SolverMAM(model,self.options);
                    self.solvers{1,self.CANDIDATE_MVA} = SolverMVA(model,self.options);
                    self.solvers{1,self.CANDIDATE_NC} = SolverNC(model,self.options);
                    self.solvers{1,self.CANDIDATE_FLUID} = SolverFluid(model,self.options);
                    self.solvers{1,self.CANDIDATE_JMT} = SolverJMT(model,self.options);
                    self.solvers{1,self.CANDIDATE_SSA} = SolverSSA(model,self.options);
                    self.solvers{1,self.CANDIDATE_CTMC} = SolverCTMC(model,self.options);
                    boolSolver = [];
                    for s=1:length(self.solvers)
                        boolSolver(s) = self.solvers{s}.supports(self.model);
                        self.solvers{s}.setOptions(self.options);
                    end
                    self.candidates = {self.solvers{find(boolSolver)}}; %#ok<FNDSB> 
                case 'LayeredNetwork'
                    self.solvers{1,self.CANDIDATE_LQNS} = SolverLQNS(model,self.options);
                    self.solvers{1,self.CANDIDATE_LN_NC} = SolverLN(model,@(m) SolverNC(m),self.options);
                    self.solvers{1,self.CANDIDATE_LN_MVA} = SolverLN(model,@(m) SolverMVA(m),self.options);
                    %self.solvers{1,self.CANDIDATE_LN_MAM} = SolverLN(model,@(m) SolverMAM(m));
                    %boolSolver = [];
                    %for s=1:length(self.solvers)
                    %    boolSolver(s) = self.solvers{s}.supports(self.model);
                    %    self.solvers{s}.setOptions(self.options);
                    %end
                    self.candidates = self.solvers;
            end
            %turn off warnings temporarily
            wstatus = warning('query');
            warning off;
            warning(wstatus);
        end

        function sn = getStruct(self)
            % QN = GETSTRUCT()

            % Get data structure summarizing the model
            sn = self.model.getStruct(true);
        end

        function out = getName(self)
            % OUT = GETNAME()
            % Get solver name
            out = self.name;
        end

    end

    methods
        
        function varargout = delegate(self, method, nretout, varargin)
            model = self.model;

            switch class(model)
                case 'Network'
                    % first try with chosen solver, if the method is not available
                    %     or fails keep going with the other candidates
                    chosenSolver = chooseSolver(self);
                    if chosenSolver.supports(self.model)
                        proposedSolvers = {chosenSolver, self.candidates{:}};
                    else
                        proposedSolvers = self.candidates;
                    end
                    for s=1:length(proposedSolvers)
                        try
                            switch nretout
                                case 1
                                    varargout{1} = proposedSolvers{s}.(method)(varargin);
                                case 2
                                    [r1,r2] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                case 3
                                    [r1,r2,r3] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                case 4
                                    [r1,r2,r3,r4] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                    varargout{4} = r4;
                                case 5
                                    [r1,r2,r3,r4,r5] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                    varargout{4} = r4;
                                    varargout{5} = r5;
                                case 6
                                    [r1,r2,r3,r4,r5,r6] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                    varargout{4} = r4;
                                    varargout{5} = r5;
                                    varargout{6} = r6;
                            end
                            return
                        catch me                            
                            line_printf('Switching solver to %s.',proposedSolvers{s}.getName);
                        end
                    end
                case 'LayeredNetwork'
                    % first try with chosen solver, if the method is not available
                    %     or fails keep going with the other candidates
                    chosenSolver = chooseSolver(self);
                    if chosenSolver.supports(self.model)
                        proposedSolvers = {chosenSolver, self.getAvgChainTable};
                    else
                        proposedSolvers = self.candidates;
                    end
                    for s=1:length(proposedSolvers)
                        try
                            switch nretout
                                case 1
                                    varargout{1} = proposedSolvers{s}.(method)(varargin);
                                case 2
                                    [r1,r2] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                case 3
                                    [r1,r2,r3] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                case 4
                                    [r1,r2,r3,r4] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                    varargout{4} = r4;
                                case 5
                                    [r1,r2,r3,r4,r5] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                    varargout{4} = r4;
                                    varargout{5} = r5;
                                case 6
                                    [r1,r2,r3,r4,r5,r6] = proposedSolvers{s}.(method)(varargin);
                                    varargout{1} = r1;
                                    varargout{2} = r2;
                                    varargout{3} = r3;
                                    varargout{4} = r4;
                                    varargout{5} = r5;
                                    varargout{6} = r6;
                            end
                            return
                        catch
                            line_printf('Switching solver %s.',proposedSolvers{s}.getName);
                        end
                    end
            end
        end

        function AvgChainTable = getAvgChainTable(self)
            % [AVGCHAINTABLE] = GETAVGCHAINTABLE(self)
            AvgChainTable = self.delegate('getAvgChainTable', 1);
        end

        function AvgQlenTable = getAvgQLenTable(self)
            AvgQlenTable = self.delegate('getAvgQLenTable', 1);
        end

        function AvgTputTable = getAvgTputTable(self)
            AvgTputTable = self.delegate('getAvgTputTable', 1);
        end

        function AvgRespTTable = getAvgRespTTable(self)
            AvgRespTTable = self.delegate('getAvgRespTTable', 1);
        end

        function AvgUtilTable = getAvgUtilTable(self)
            AvgUtilTable = self.delegate('getAvgUtilTable', 1);
        end

        function AvgSysTable = getAvgSysTable(self)
            % [AVGSYSTABLE] = GETAVGSYSTABLE(self)
            AvgSysTable = self.delegate('getAvgSysTable', 1);
        end

        function AvgNodeTable = getAvgNodeTable(self)
            % [AVGNODETABLE] = GETAVGNODETABLE(self)
            AvgNodeTable = self.delegate('getAvgNodeTable', 1);
        end

        function AvgTable = getAvgTable(self)
            % [AVGTABLE] = GETAVGTABLE(self)
            AvgTable = self.delegate('getAvgTable', 1);
        end

        function [QN,UN,RN,TN,AN,WN] = getAvg(self,Q,U,R,T)
            %[QN,UN,RN,TN] = GETAVG(SELF,Q,U,R,T)

            if nargin>1
                [QN,UN,RN,TN,AN,WN] = self.delegate('getAvg', 6, Q,U,R,T);
            else
                [QN,UN,RN,TN,AN,WN] = self.delegate('getAvg', 6);
            end
        end

        function [QNc,UNc,RNc,TNc] = getAvgChain(self,Q,U,R,T)
            %[QNC,UNC,RNC,TNC] = GETAVGCHAIN(SELF,Q,U,R,T)

            if nargin>1
                [QNc,UNc,RNc,TNc] = self.delegate('getAvgChain', 4, Q,U,R,T);
            else
                [QNc,UNc,RNc,TNc] = self.delegate('getAvgChain', 4);
            end
        end

        function [CNc,XNc] = getAvgSys(self,R,T)
            %[CNC,XNC] = GETAVGSYS(SELF,R,T)

            if nargin>1
                [CNc,XNc] = self.delegate('getAvgSys', 2, R,T);
            else
                [CNc,XNc] = self.delegate('getAvgSys', 2);
            end
        end

        function [QNt,UNt,TNt] = getTranAvg(self,Qt,Ut,Tt)
            % [QNT,UNT,TNT] = GETTRANAVG(SELF,QT,UT,TT)

            if nargin>1
                [QNt,UNt,TNt] = self.delegate('getTranAvg', 3, Qt,Ut,Tt);
            else
                [QNt,UNt,TNt] = self.delegate('getTranAvg', 3);
            end
        end

        function [QN,UN,RN,TN,AN,WN] = getAvgNode(self,Q,U,R,T,A)               
            if nargin>1
                [QN,UN,RN,TN,AN,WN] = self.delegate('getAvgNode', 6, Q,U,R,T,A);
            else
                [QN,UN,RN,TN,AN,WN] = self.delegate('getAvgNode', 6);
            end
        end
        
        function [AN] = getAvgArvRChain(self,A)
            if nargin>1
                AN = self.delegate('getAvgArvRChain', 1, A);
            else
                AN = self.delegate('getAvgArvRChain', 1);
            end
        end
        
        function [QN] = getAvgQLenChain(self,Q)
            if nargin>1
                QN = self.delegate('getAvgQLenChain', 1, Q);
            else
                QN = self.delegate('getAvgQLenChain', 1);
            end
        end
        
        function [UN] = getAvgUtilChain(self,U)
            if nargin>1
                UN = self.delegate('getAvgUtilChain', 1, U);
            else
                UN = self.delegate('getAvgUtilChain', 1);
            end
        end
        
        function [RN] = getAvgRespTChain(self,R)
            if nargin>1
                RN = self.delegate('getAvgRespTChain', 1, R);
            else
                RN = self.delegate('getAvgRespTChain', 1);
            end
        end
        
        function [TN] = getAvgTputChain(self,T)
            if nargin>1
                TN = self.delegate('getAvgTputChain', 1, T);
            else
                TN = self.delegate('getAvgTputChain', 1);
            end
        end
        
        function [RN] = getAvgSysRespT(self,R)
            if nargin>1
                RN = self.delegate('getAvgSysRespT', 1, R);
            else
                RN = self.delegate('getAvgSysRespT', 1);
            end
        end
        
        function [TN] = getAvgSysTput(self,T)
            if nargin>1
                TN = self.delegate('getAvgSysTput', 1, T);
            else
                TN = self.delegate('getAvgSysTput', 1);
            end
        end        
        
        % AI-based choose solvers
        function solver = chooseSolverAI(self)
            % SOLVER = CHOOSESOLVERAI()
            %
            % This function takes as input a QN model defined in LINE and returns
            % a Solver object with the predicted method loaded
            model = self.model;
            sn = model.getStruct;
            dataVector = zeros(1, 15);

            % Station and scheduling information
            dataVector(1) = sum(sn.schedid == SchedStrategy.ID_FCFS); % Num FCFS queues
            dataVector(2) = sum(sn.schedid == SchedStrategy.ID_PS); % Num PS queues
            dataVector(3) = sum(sn.schedid == SchedStrategy.ID_INF); % Num delays
            dataVector(4) = sn.nnodes - sn.nstations; % Num CS nodes
            dataVector(5) = sum(sn.nservers(~isinf(sn.nservers))); % Num queue servers

            % Job information
            dataVector(6) = sn.nchains; % Num chains
            dataVector(7) = sn.nclosedjobs; % Number of jobs in the system

            % Service process information
            numexp = 0;
            numhyperexp = 0;
            numerlang = 0;

            for i = 1 : model.getNumberOfStations
                for j = 1 : model.getNumberOfClasses
                    switch model.stations{i}.serviceProcess{j}.name
                        case 'Exponential'
                            numexp = numexp + 1;
                        case 'HyperExp'
                            numhyperexp = numhyperexp + 1;
                        case 'Erlang'
                            numerlang = numerlang + 1;
                    end
                end
            end

            dataVector(8:10) = [numexp numhyperexp numerlang]; % Num of each distribution type
            dataVector(11) = mean(sn.rates, 'all', 'omitnan'); % Avg service rate
            dataVector(12) = mean(sn.scv, 'all', 'omitnan'); % Avg SCV
            dataVector(13) = mean(sn.phases, 'all', 'omitnan'); % Avg phases

            % Misc
            dataVector(14) = sum(sn.nodetype == NodeType.Queue) == 1; % If only 1 Queue, special for nc.mmint
            dataVector(15) = model.hasProductFormSolution; % Check if model has product form solution

            %Add derived features
            dataVector = [dataVector dataVector(:, 1:3) ./ sum(dataVector(:, 1:3), 2)]; % Percent FCFS, PS, Delay
            dataVector = [dataVector logical(dataVector(:, 4))]; % Has CS or not
            dataVector = [dataVector dataVector(:, 5) ./ sum(dataVector(:, 1:2), 2)]; % Avg svrs per Queue
            dataVector = [dataVector dataVector(:, 7) ./ dataVector(:, 6)]; % Num jobs per chain
            dataVector = [dataVector dataVector(:, 8:10) ./ sum(dataVector(:, 8:10), 2)]; % Percent distributions

            load('classifier.mat', 'classifier', 'methodNames', 'selected');
            if isa(classifier, 'cell')
                chosenMethod = predictEnsemble(classifier, dataVector(selected(1:length(dataVector))));
            else
                chosenMethod = predict(classifier, dataVector(selected(1:length(dataVector))));
            end

            solver = Solver.load(methodNames(chosenMethod), model);
        end

        % chooseSolver: choses a solver from static properties of the model
        function solver = chooseSolver(self)
            % SOLVER = CHOOSESOLVER()

            model = self.model;
            switch class(model)
                case 'Network'
                    if model.hasProductFormSolution
                        if model.hasSingleChain
                            %ncoptions = SolverNC.defaultOptions;
                            solver = self.solvers{self.CANDIDATE_NC};
                        else % MultiChain
                            if model.hasHomogeneousScheduling(SchedStrategy.INF)
                                solver = self.solvers{self.CANDIDATE_MVA};
                            elseif model.hasMultiServer
                                if sum(model.getNumberOfJobs) / sum(model.getNumberOfChains) > 30 % likely fluid regime
                                    solver = self.solvers{self.CANDIDATE_FLUID};
                                elseif sum(model.getNumberOfJobs) / sum(model.getNumberOfChains) > 10 % mid/heavy load
                                    solver = self.solvers{self.CANDIDATE_MVA};
                                elseif sum(model.getNumberOfJobs) < 5 % light load
                                    solver = self.solvers{self.CANDIDATE_NC};
                                else
                                    solver = self.solvers{self.CANDIDATE_MVA};
                                end
                            else % product-form, no infinite servers
                                solver = self.solvers{self.CANDIDATE_NC};
                            end
                        end
                    else
                        solver = chooseSolverAI(self);
                        %solver = self.solvers{self.CANDIDATE_MVA};
                    end
                case 'LayeredNetwork'
                    hasCacheTasks = false;
                    for t=1:length(self.model.tasks)
                        if isa(self.model.tasks{t},'CacheTask')
                            solver = self.solvers{self.CANDIDATE_LN_NC};
                            return
                        end
                    end
                    solver = self.solvers{self.CANDIDATE_LQNS};
            end
        end
    end
end