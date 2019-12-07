classdef SolverEnv < EnsembleSolver
    % Solver for models immersed in a random environment.
    %
    % Copyright (c) 2012-2020, Imperial College London
    % All rights reserved.
    
    
    properties
        env; % user-supplied representation of each stage transition
        envObj;
        resetFromMarginal;
    end
    
    methods
        function self = SolverEnv(renv, solverFactory, options)
            % SELF = SOLVERENV(ENV,SOLVERFACTORY,OPTIONS)
            self@EnsembleSolver(renv,mfilename,options);
            self.envObj = renv;
            models = renv.getEnsemble;
            env = renv.getEnv;
            self.env = env;
            for e=1:length(self.env)
                self.setSolver(solverFactory(models{e}),e);
            end

            for e=1:length(self.env)
                for h=1:length(self.env)
                    self.resetFromMarginal{e,h} = renv.resetFun{e,h};
                end
            end
            
            for e=1:length(self.env)
                for h=1:length(self.env)
                    if isa(self.env{e,h},'Disabled')
                        self.env{e,h} = Exp(0);
                    elseif ~isa(self.env{e,h},'MarkovianDistribution')
                        error('The distribution of the environment transition from stage %d to %d is not supported by the %s solver.',e,h,self.getName);
                    end
                end
            end
            
            for e=1:length(self.ensemble)
                if ~self.solvers{e}.supports(self.ensemble{e})
                    error('Model in the environment stage %d is not supported by the %s solver.',e,self.getName);
                end
            end
        end
        
        function bool = converged(self, it) % convergence test at iteration it
            % BOOL = CONVERGED(IT) % CONVERGENCE TEST AT ITERATION IT
            
            bool = false;
            E = self.getNumberOfModels;
            if it>1
                mapes = zeros(1,E);
                for e=1:E
                    for i=1:size(self.results{it,e}.Tran.Avg.Q,1)
                        for j=1:size(self.results{it,e}.Tran.Avg.Q,2)
                            % error is calculated only on entry value (t=0)
                            mapes(e) = max(mapes(e), mape(self.results{it,e}.Tran.Avg.Q{i,j}.metric(1), self.results{it-1,e}.Tran.Avg.Q{i,j}.metric(1)));
                        end
                    end
                end
                if max(mapes) < self.options.iter_tol
                    bool = true;
                end
                if self.options.verbose
                    fprintf(1,'Iteration %3d, max abs. perc. error: %f\n',it,max(mapes));
                end
            else
                if self.options.verbose
                    fprintf(1,'Iteration %3d, max abs. perc. error: %f\n',it,Inf);
                end
            end
        end
        
        
        function init(self)
            % INIT()            
            options = self.options;            
            if isfield(options,'seed')
                Solver.resetRandomGeneratorSeed(options.seed);
            end            
            self.envObj.init();
        end
        
        function pre(self, it)
            % PRE(IT)
            
            if it==1
                for e=self.list()
                    if isinf(self.getSolver(e).options.timespan(2))
                        [QN,~,~,~] = self.getSolver(e).getAvg();
                    else
                        [QNt,~,~] = self.getSolver(e).getTranAvg();                        
                        QN = cellfun(@(q) q.metric(end), QNt);
                    end
                    self.ensemble{e}.initFromMarginal(QN);
                end
            end
        end
        
        % solves model in stage e
        function [results_e, runtime] = analyze(self, it, e)
            % [RESULTS_E, RUNTIME] = ANALYZE(IT, E)
            
            results_e = struct();
            results_e.('Tran') = struct();
            results_e.Tran.('Avg') = [];
            T0 = tic;
            runtime = toc(T0);
            %% initialize
            [Qt,Ut,Tt] = self.ensemble{e}.getTranHandles;
            %[results_e.Avg.Q, results_e.Avg.U, results_e.Avg.R, results_e.Avg.T] = self.solvers{e}.getAvg();       
            [QNt,UNt,TNt] = self.solvers{e}.getTranAvg(Qt,Ut,Tt);
            results_e.Tran.Avg.Q = QNt; %cellfun(@(c) c.metric, QNt,'UniformOutput',false);
            results_e.Tran.Avg.U = UNt; %cellfun(@(c) c.metric, UNt,'UniformOutput',false);
            results_e.Tran.Avg.T = TNt; %cellfun(@(c) c.metric, TNt,'UniformOutput',false);
            %[results_e.Tran.Avg.Q, results_e.Tran.Avg.U, results_e.Tran.Avg.T] = self.solvers{e}.getTranAvg(Qt,Ut,Tt);
        end
        
        function post(self, it)
            % POST(IT)
            
            E = self.getNumberOfModels;
            for e=1:E
                for h = 1:E
                    Qexit{e,h} = zeros(size(self.results{it,e}.Tran.Avg.Q));
                    for i=1:size(self.results{it,e}.Tran.Avg.Q,1)
                        for r=1:size(self.results{it,e}.Tran.Avg.Q,2)
                            w{e,h} = [0, map_cdf(self.envObj.proc{e,h}, self.results{it,e}.Tran.Avg.Q{i,r}.t(2:end)) - map_cdf(self.envObj.proc{e,h}, self.results{it,e}.Tran.Avg.Q{i,r}.t(1:end-1))]';
                            if ~isnan(w{e,h})
                                Qexit{e,h}(i,r) = self.results{it,e}.Tran.Avg.Q{i,r}.metric'*w{e,h}/sum(w{e,h});
                            else
                                Qexit{e,h}(i,r) = 0;
                            end
                        end
                    end
                end
            end 
            
            Qentry = cell(1,E); % average entry queue-length
            for e = 1:E
                Qentry{e} = zeros(size(Qexit{e}));
                for h=1:E
                    % probability of coming from h to e \times resetFun(Qexit from h to e 
                    if self.envObj.probOrig(h,e) > 0                    
                        Qentry{e} = Qentry{e} + self.envObj.probOrig(h,e) * self.resetFromMarginal{h,e}(Qexit{h,e});
                    end
                end
                self.solvers{e}.reset();
                self.ensemble{e}.initFromMarginal(Qentry{e});
            end
        end
        
        function finish(self)
            % FINISH()
            
            it = size(self.results,1); % use last iteration
            E = self.getNumberOfModels;
            for e=1:E
                QExit{e}=[];
                UExit{e}=[];
                TExit{e}=[];
                for i=1:size(self.results{it,e}.Tran.Avg.Q,1)
                    for r=1:size(self.results{it,e}.Tran.Avg.Q,2)
                        w{e} = [0, map_cdf(self.envObj.holdTime{e}, self.results{it,e}.Tran.Avg.Q{i,r}.t(2:end)) - map_cdf(self.envObj.holdTime{e}, self.results{it,e}.Tran.Avg.Q{i,r}.t(1:end-1))]';
                        QExit{e}(i,r) = self.results{it,e}.Tran.Avg.Q{i,r}.metric'*w{e}/sum(w{e});
                        UExit{e}(i,r) = self.results{it,e}.Tran.Avg.U{i,r}.metric'*w{e}/sum(w{e});
                        TExit{e}(i,r) = self.results{it,e}.Tran.Avg.T{i,r}.metric'*w{e}/sum(w{e});
                    end
                end
                %                 for h = 1:E
                %                     QE{e,h} = zeros(size(self.results{it,e}.Tran.Avg.Q));
                %                     for i=1:size(self.results{it,e}.Tran.Avg.Q,1)
                %                         for r=1:size(self.results{it,e}.Tran.Avg.Q,2)
                %                             w{e,h} = [0, map_cdf(self.envObj.proc{e,h}, self.results{it,e}.Tran.Avg.Q{i,r}(2:end,2)) - map_cdf(self.envObj.proc{e,h}, self.results{it,e}.Tran.Avg.Q{i,r}(1:end-1,2))]';
                %                             if ~isnan(w{e,h})
                %                                 QE{e,h}(i,r) = self.results{it,e}.Tran.Avg.Q{i,r}(:,1)'*w{e,h}/sum(w{e,h});
                %                             else
                %                                 QE{e,h}(i,r) = 0;
                %                             end
                %                         end
                %                     end
                %                 end
            end
            
            Qval=0*QExit{e};
            Uval=0*UExit{e};
            Tval=0*TExit{e};
            for e=1:E
                Qval = Qval + self.envObj.probEnv(e) * QExit{e}; % to check
                Uval = Uval + self.envObj.probEnv(e) * UExit{e}; % to check
                Tval = Tval + self.envObj.probEnv(e) * TExit{e}; % to check
            end
            self.result.Avg.Q = Qval;
            %    self.result.Avg.R = R;
            %    self.result.Avg.X = X;
            self.result.Avg.U = Uval;
            self.result.Avg.T = Tval;
            %    self.result.Avg.C = C;
            %self.result.runtime = runtime;
        end
        
        function name = getName(self)
            % NAME = GETNAME()
            
            name = mfilename;
        end
        
        function [QNclass, UNclass, TNclass] = getAvg(self)
            % [QNCLASS, UNCLASS, TNCLASS] = GETAVG()
            
            if isempty(self.result) || (isfield(self.options,'force') && self.options.force)
                self.run();
                if isempty(self.result)
                    QNclass=[];
                    UNclass=[];
                    TNclass=[];
                    return
                end
            end
            QNclass = self.result.Avg.Q;
            UNclass = self.result.Avg.U;
            TNclass = self.result.Avg.T;
        end
        
        function [AvgTable,QT,UT,TT] = getAvgTable(self,keepDisabled)
            % [AVGTABLE,QT,UT,TT] = GETAVGTABLE(SELF,KEEPDISABLED)            
            % Return table of average station metrics

            if ~exist('keepDisabled','var')
                keepDisabled = false;
            end
            
            [QN,UN,TN] = self.getAvg();
            M = size(QN,1);
            K = size(QN,2);
            Q = self.result.Avg.Q;
            U = self.result.Avg.U;
            T = self.result.Avg.T;
            if isempty(QN)
                AvgTable = Table();
                QT = Table();
                UT = Table();
                TT = Table();
            elseif ~keepDisabled
                Qval = []; Uval = []; Tval = [];
                Class = {};
                Station = {};
                for i=1:M
                    for k=1:K
                        if any(sum([QN(i,k),UN(i,k),TN(i,k)])>0)
                            Class{end+1,1} = self.model.ensemble{1}.classes{k}.name;
                            Station{end+1,1} = self.model.ensemble{1}.stations{i}.name;
                            Qval(end+1) = QN(i,k);
                            Uval(end+1) = UN(i,k);
                            Tval(end+1) = TN(i,k);
                        end
                    end
                end
                QLen = Qval(:); % we need to save first in a variable named like the column
                QT = Table(Station,Class,QLen);
                Util = Uval(:); % we need to save first in a variable named like the column
                UT = Table(Station,Class,Util);
                Tput = Tval(:); % we need to save first in a variable named like the column
                TT = Table(Station,Class,Tput);
                AvgTable = Table(Station,Class,QLen,Util,Tput);
            else
                Qval = zeros(M,K); Uval = zeros(M,K);
                Class = cell(K*M,1);
                Station = cell(K*M,1);
                for i=1:M
                    for k=1:K
                        Class{(i-1)*K+k} = Q{i,k}.class.name;
                        Station{(i-1)*K+k} = Q{i,k}.station.name;
                        Qval((i-1)*K+k) = QN(i,k);
                        Uval((i-1)*K+k) = UN(i,k);
                        Tval((i-1)*K+k) = TN(i,k);
                    end
                end
                QLen = Qval(:); % we need to save first in a variable named like the column
                QT = Table(Station,Class,QLen);
                Util = Uval(:); % we need to save first in a variable named like the column
                UT = Table(Station,Class,Util);
                Tput = Tval(:); % we need to save first in a variable named like the column
                TT = Table(Station,Class,Tput);
                AvgTable = Table(Station,Class,QLen,Util,Tput);
            end
        end        
    end
    
    methods (Static)
        function [bool, featSupported] = supports(model)
            % [BOOL, FEATSUPPORTED] = SUPPORTS(MODEL)
            
            featUsed = model.getUsedLangFeatures();
            
            featSupported = SolverFeatureSet;
            
            % Nodes
            featSupported.setTrue('ClassSwitch');
            featSupported.setTrue('DelayStation');
            featSupported.setTrue('Queue');
            featSupported.setTrue('Sink');
            featSupported.setTrue('Source');
            
            % Distributions
            featSupported.setTrue('Coxian');
            featSupported.setTrue('Cox2');
            featSupported.setTrue('Erlang');
            featSupported.setTrue('Exponential');
            featSupported.setTrue('HyperExp');
            
            % Sections
            featSupported.setTrue('StatelessClassSwitcher'); % Section
            featSupported.setTrue('InfiniteServer'); % Section
            featSupported.setTrue('SharedServer'); % Section
            featSupported.setTrue('Buffer'); % Section
            featSupported.setTrue('Dispatcher'); % Section
            featSupported.setTrue('Server'); % Section (Non-preemptive)
            featSupported.setTrue('JobSink'); % Section
            featSupported.setTrue('RandomSource'); % Section
            featSupported.setTrue('ServiceTunnel'); % Section
            
            % Scheduling strategy
            featSupported.setTrue('SchedStrategy_INF');
            featSupported.setTrue('SchedStrategy_PS');
            featSupported.setTrue('RoutingStrategy_PROB');
            featSupported.setTrue('RoutingStrategy_RAND');
            featSupported.setTrue('RoutingStrategy_RR'); % with SolverJMT
            
            % Customer Classes
            featSupported.setTrue('ClosedClass');
            featSupported.setTrue('OpenClass');
            
            bool = SolverFeatureSet.supports(featSupported, featUsed);
        end
    end
end

