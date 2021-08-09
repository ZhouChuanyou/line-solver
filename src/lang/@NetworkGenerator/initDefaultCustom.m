function model = initDefaultCustom(model, nodes)
% This function sets a random initial state for a QN model
% generated by NetworkGenerator. NOTE: This is copied directly from
% LINE's own version, with a slight modification to generate
% only one initial state rather than enumerate all possible states

    qn = model.getStruct(false);
    N = qn.njobs';
    if nargin < 2
        nodes = 1:model.getNumberOfNodes;
    end
    for i=nodes
        if qn.isstation(i)
            n0 = zeros(1,length(N));
            s0 = zeros(1,length(N));
            s = qn.nservers(qn.nodeToStation(i)); % allocate
            for r=find(isfinite(N))' % for all closed classes
                if qn.nodeToStation(i) == qn.refstat(r)
                    n0(r) = N(r);
                end
                s0(r) = min(n0(r),s);
                s = s - s0(r);
            end
            state_i = fromMarginalAndStarted(qn,i,n0(:)',s0(:)');
            switch qn.nodetype(i)
                case NodeType.Cache
                    state_i = [state_i, 1:qn.nvars(i)];
            end
            switch qn.routing(i)
                case RoutingStrategy.ID_RROBIN
                    % start from first connected queue
                    state_i = [state_i, find(qn.rt(i,:),1)];
            end
            if isempty(state_i)
                error('Default initialization failed on station %d.',i);
            else
                model.nodes{i}.setState(state_i);
                prior_state_i = zeros(1,size(state_i,1)); prior_state_i(1) = 1;
                model.nodes{i}.setStatePrior(prior_state_i);
            end
        elseif qn.isstateful(i) % not a station
            switch class(model.nodes{i})
                case 'Cache'
                    state_i = zeros(1,model.getNumberOfClasses);
                    state_i = [state_i, 1:sum(model.nodes{i}.itemLevelCap)];
                    model.nodes{i}.setState(state_i);
                case 'Router'
                    model.nodes{i}.setState([1]);
                otherwise
                    model.nodes{i}.setState([]);
            end
            %error('Default initialization not available on stateful node %d.',i);
        end
    end
end

function space = fromMarginalAndStarted(qn, ind, n, s, options)
    % SPACE = FROMMARGINALANDSTARTED(QN, IND, N, S, OPTIONS)

    % Copyright (c) 2012-2020, Imperial College London
    % All rights reserved.

    if ~exist('options','var')
        options.force = true;
    end
    if isa(qn,'Network')
        qn = qn.getStruct();
    end
    % generate one initial state such that the marginal queue-lengths are as in vector n
    % n(r): number of jobs at the station in class r
    % s(r): jobs of class r that are running
    R = qn.nclasses;
    S = qn.nservers;

    % ind: node index
    ist = qn.nodeToStation(ind);
    %isf = qn.nodeToStateful(ind);

    K = zeros(1,R);
    for r=1:R
        if isempty(qn.proc{ist}{r})
            K(r) = 0;
        else
            K(r) = length(qn.proc{ist}{r}{1});
        end
    end
    state = [];
    space = [];
    if any(n>qn.classcap(ist,:))
        exceeded = n>qn.classcap(ist,:);
        for r=find(exceeded)
            if ~isempty(qn.proc) && ~isempty(qn.proc{ist,r}) && any(any(isnan(qn.proc{ist,r}{1})))
                warning('State vector at station %d (n=%s) exceeds the class capacity (classcap=%s). Some service classes are disabled.\n',ist,mat2str(n(ist,:)),mat2str(qn.classcap(ist,:)));
            else
                warning('State vector at station %d (n=%s) exceeds the class capacity (classcap=%s).\n',ist,mat2str(n(ist,:)),mat2str(qn.classcap(ist,:)));
            end
        end
        return
    end
    if (qn.nservers(ist)>0 && sum(s) > qn.nservers(ist))
        return
    end
    % generate local-state space
    switch qn.nodetype(ind)
        case {NodeType.Queue, NodeType.Delay, NodeType.Source}
            switch qn.sched{ist}
                case SchedStrategy.EXT
                    for r=1:R
                        init = State.spaceClosedSingle(K(r),0);
                        if isinf(qn.njobs(r))
                            if ~isempty(qn.proc) && ~isempty(qn.proc{ist,r}) && any(any(isnan(qn.proc{ist,r}{1})))
                                init(1) = 0; % class is not processed at this source
                            else
                                % init the job generation
                                init(1) = 1;
                            end
                        end
                        state = State.decorate(state,init);
                    end
                    space = State.decorate(space,state);
                    space = [Inf*ones(size(space,1),1),space];
                case {SchedStrategy.INF, SchedStrategy.PS, SchedStrategy.DPS, SchedStrategy.GPS}
                    % in these policies we only track the jobs in the servers
                    for r=1:R
                        init = State.spaceClosedSingle(K(r),0);
                        init(1) = n(r);
                        state = State.decorate(state,init);
                    end
                    space = State.decorate(space,state);
                case {SchedStrategy.SIRO, SchedStrategy.LEPT, SchedStrategy.SEPT}
                    % in these policies we track an un-ordered buffer and
                    % the jobs in the servers
                    % build list of job classes in the node, with repetition
                    if sum(n) <= S(ist)
                        for r=1:R
                            init = State.spaceClosedSingle(K(r),0);
                            init(1) = n(r);
                            state = State.decorate(state,init);
                        end
                        space = State.decorate(space,[zeros(size(state,1),R),state]);
                    else
                        %            si = multichoosecon(n,S(i)); % jobs of class r that are running
                        si = s;
                        mi_buf = repmat(n,size(si,1),1) - si; % jobs of class r in buffer
                        for k=1:size(si,1)
                            % determine number of classes r jobs running in phase j
                            kstate=[];
                            for r=1:R
                                init = State.spaceClosedSingle(K(r),0);
                                init(1) = si(k,r);
                                kstate = State.decorate(kstate,init);
                            end
                            state = [repmat(mi_buf(k,:),size(kstate,1),1), kstate];
                            space = [space; state];
                        end
                    end
                case {SchedStrategy.FCFS, SchedStrategy.HOL, SchedStrategy.LCFS}
                    if sum(n) == 0
                        space = zeros(1,1+sum(K));
                        return
                    end
                    
                    allJobs = [];
                    for r=1:R
                        allJobs = [allJobs, r*ones(1, n(r))];
                    end
                    
                    runningJobs = allJobs(:, 1:sum(s));
                    jobsInBuffer = allJobs(:, sum(s)+1:end);
                    % perm = randperm(length(jobsInBuffer));
                    jobsInBuffer = jobsInBuffer(randperm(length(jobsInBuffer)));
                    if isempty(jobsInBuffer)
                        jobsInBuffer = 0;
                    end
                    
                    svc = [];
                    for r=1:R
                        temp = zeros(1, K(r));
                        temp(1) = sum(runningJobs==r);
                        svc = [svc, temp];
                    end
                    
                    space = [jobsInBuffer, svc];
                    
                case {SchedStrategy.SJF, SchedStrategy.LJF}
                    % in these policies the state space includes continuous
                    % random variables for the service times
                    % in these policies we only track the jobs in the servers

                    for r=1:R
                        init = State.spaceClosedSingle(K(r),0);
                        init(1) = n(r);
                        state = State.decorate(state,init);
                    end
                    space = State.decorate(space,state);
                    % this is not casted as an error since this function is
                    % IS

                    % called to initial models with SJF and LJF
                    warning('The scheduling policy does not admit a discrete state space.\n');
            end
        case NodeType.Cache
            switch qn.sched{ist}
                case SchedStrategy.INF
                    % in this policies we only track the jobs in the servers
                    for r=1:R
                        init = State.spaceClosedSingle(K(r),n(r));
                        state = State.decorate(state,init);
                    end
                    space = State.decorate(space,state);
            end
        case NodeType.Join
            space = 0;
    end
    space = unique(space,'rows'); % do not comment, required to sort empty state as first
    space = space(end:-1:1,:); % this ensures that states where jobs start in phase 1 are first, which is used eg in SSA
end