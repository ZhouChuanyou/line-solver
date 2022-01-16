function [Qfull, Ufull, Rfull, Tfull, Cfull, Xfull, t, Qfull_t, Ufull_t, Tfull_t, lastSolution] = solver_fluid_analyzer(sn, options)
% [QFULL, UFULL, RFULL, TFULL, CFULL, XFULL, T, QFULL_T, UFULL_T, TFULL_T, LASTSOLUTION] = SOLVER_FLUID_ANALYZER(QN, OPTIONS)

% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.

Cfull=[]; Xfull=[];

M = sn.nstations;
K = sn.nclasses;
S = sn.nservers;
SCV = sn.scv;
schedid = sn.schedid;
phases = sn.phases;
rates0 = sn.rates;

if isempty(options.init_sol)
    options.init_sol = solver_fluid_initsol(sn, options);
end

outer_iters = 1;
outer_runtime = tic;
[Qfull, Ufull, Rfull, Tfull, ymean, Qfull_t, Ufull_t, Tfull_t, ~, t] = solver_fluid_analyzer_inner(sn, options);
outer_runtime = toc(outer_runtime);
phases_last = phases;

% This parameter determines if the approximation uses the SCV of arrival
% and service times at FCFS nodes or not
useSCV = false;

%%

switch options.method
    case {'default','stateindep'}
        % approximate FCFS nodes as state-independent stations
		if any(schedid==SchedStrategy.ID_FCFS) 
            rates = rates0;
            iter = 0;
            eta_1 = zeros(1,M);
            eta = Inf*ones(1,M);
            tol = 1e-2;
            
            while max(abs(1-eta./eta_1)) > tol && iter <= options.iter_max
                iter = iter + 1;
                eta_1 = eta;
                eta= zeros(1,M);
                cs = ones(M,1);
                for i=1:M
                    B(i) = min(sum(Qfull(i,:)),S(i)); % number of busy servers
                end
                for i=1:M
                    sd = rates0(i,:)>0;
                    Ufull(i,sd) = Tfull(i,sd) ./ rates0(i,sd);
                    switch sn.schedid(i)
                        case SchedStrategy.ID_FCFS
                            sd = rates0(i,:)>0;
                            %if range(rates0(i,sd))>0 % check if non-product-form
                            rho(i) = sum(Ufull(i,sd))/S(i); % true utilization of each server
                            if ~useSCV
                                [~,eta(i)]=qsys_mm1(sum(rates0(i,sd)),sum(rates0(i,sd))/rho(i));% dimensionally a utilization, (diffusion approximation, Kobayashi JACM)
                            else
                                %                                     ca(i) = 0;
                                %                                     for j=1:M
                                %                                         for r=1:K
                                %                                             if rates0(j,r)>0
                                %                                                 for s=1:K
                                %                                                     if rates0(i,s)>0
                                %                                                         pji_rs = sn.rt((j-1)*sn.nclasses + r, (i-1)*sn.nclasses + s);
                                %                                                         ca(i) = ca(i) + (SCV(j,r))*Tfull(j,r)*pji_rs/sum(Tfull(i,sd));
                                %                                                     end
                                %                                                 end
                                %                                             end
                                %                                         end
                                %                                     end
                                ca(i) = 1;
                                cs(i) = (SCV(i,sd)*Tfull(i,sd)')/sum(Tfull(i,sd));
                                eta(i) = exp(-2*(1-rho(i))/(cs(i)+ca(i)*rho(i)));  % dimensionally a utilization, (diffusion approximation, Kobayashi JACM)
                            end
                            %end
                    end
                end
                
                for i=1:M
                    switch sn.schedid(i)
                        case SchedStrategy.ID_FCFS
                            sd = rates0(i,:)>0;
                            %if range(rates0(i,sd))>0 % check if non-product-form
                            for k=1:K
                                if sum(Qfull(i,:)) < S(i)
                                    if Ufull(i,k) > 0
                                        rates(i,k) = rates0(i,k);
                                    end
                                else
                                    if rates(i,k) > 0
                                        rates(i,k) = sum(Tfull(i,rates(i,:)>0))/(eta(i)*S(i));
                                    end
                                end
                            end
                            %end
                    end
                end
                rates(isnan(rates))=0;
                
                if useSCV
                    for i=1:M
                        switch sn.schedid(i)
                            case SchedStrategy.ID_FCFS
                                for k=1:K
                                    if rates(i,k)>0
                                        %[cx] = APH.fitMeanAndSCV(1/rates(i,k), SCV(i,k));
                                        [cx,muik,phiik] = Coxian.fitMeanAndSCV(1/rates(i,k), SCV(i,k));
                                        %[~,muik,phiik] = Coxian.fitMeanAndSCV(map_mean(PH{i}{k}), 1); % replace with an exponential
                                        % we now handle the case that due to either numerical issues
                                        % or different relationship between scv and mean the size of
                                        % the phase-type representation has changed
                                        %muik = cx.getMu;
                                        %phiik = cx.getPhi;
                                        phases(i,k) = length(muik);
                                        if phases(i,k) ~= phases_last(i,k) % if number of phases changed
                                            % before we update sn we adjust the initial state
                                            isf = sn.stationToStateful(i);
                                            [~, nir, sir] = State.toMarginal(sn, i, sn.state{isf}, options);
                                        end
                                        %if any(muik > 0.01+ sn.mu{i,k} * rates(i,k) / rates0(i,k))
                                        %    keyboard
                                        %end
                                        sn.proc{i}{k} = cx.getRepresentation;
                                        sn.mu{i,k} = muik;
                                        sn.phi{i}{k} = phiik;
                                        sn.phases = phases;
                                        if phases(i,k) ~= phases_last(i,k)
                                            isf = sn.stationToStateful(i);
                                            % we now initialize the new service process
                                            sn.state{isf} = State.fromMarginalAndStarted(sn, i, nir, sir, options);
                                            sn.state{isf} = sn.state{isf}(1,:); % pick one as the marginals won't change
                                        end
                                    end
                                end
                        end
                    end
                    
                    options.init_sol = ymean{end}(:);
                    if norm(phases_last-phases)>0 % If there is a change of phases reset
                        options.init_sol = solver_fluid_initsol(sn);
                    end
                end
                sn.phases = phases;
                [Qfull, Ufull, ~, Tfull, ymean, ~, ~, ~, ~, ~, inner_iters, inner_runtime] = solver_fluid_analyzer_inner(sn, options);
                phases_last = phases;
                outer_iters = outer_iters + inner_iters;
                outer_runtime = outer_runtime + inner_runtime;
            end % FCFS iteration ends here
            % The FCFS iteration reinitializes at the solution of the last
            % iterative step. We now have converged in the substitution of the
            % model parameters and we rerun everything from the true initial point
            % so that we get the correct transient.
            options.init_sol = solver_fluid_initsol(sn, options);
            [Qfull, Ufull, Rfull, Tfull, ymean, Qfull_t, Ufull_t, Tfull_t, ~, t] = solver_fluid_analyzer_inner(sn, options);
        end
    case 'statedep'
        % do nothing, a single iteration is sufficient
end

if t(1) == 0
    t(1) = 1e-8;
end

for i=1:M
    for k=1:K
        %Qfull_t{i,k} = cumsum(Qfull_t{i,k}.*[0;diff(t)])./t;
        %Ufull_t{i,k} = cumsum(Ufull_t{i,k}.*[0;diff(t)])./t;        
    end
end

Ufull0 = Ufull;
for i=1:M
    sd = find(Qfull(i,:)>0);
    Ufull(i,Qfull(i,:)==0)=0;
    switch sn.schedid(i)
        case SchedStrategy.ID_INF
            for k=sd
                Ufull(i,k) = Qfull(i,k);
                Ufull_t{i,k} = Qfull_t{i,k};
                Tfull_t{i,k}  = Ufull_t{i,k}*sn.rates(i,k);
            end
        case SchedStrategy.ID_DPS
            w = sn.schedparam(i,:);
            wcorr = w(:)*Qfull(i,:)/(w(sd)*Qfull(i,sd)');
            for k=sd
                % correct for the real rates, instead of the diffusion
                % approximation rates
                Ufull(i,k) = min([1,Qfull(i,k)/S(i),sum(Ufull0(i,sd)) * (Tfull(i,k)./(rates0(i,k)))/sum(Tfull(i,sd)./(rates0(i,sd)))]);
                Tfull_t{i,k}  = Ufull_t{i,k}*sn.rates(i,k)*sn.nservers(i); % not sure if this is needed
            end            
        otherwise
            for k=sd
                % correct for the real rates, instead of the diffusion
                % approximation rates
                Ufull(i,k) = min([1,Qfull(i,k)/S(i),sum(Ufull0(i,sd)) * (Tfull(i,k)./rates0(i,k))/sum(Tfull(i,sd)./rates0(i,sd))]);
                Tfull_t{i,k}  = Ufull_t{i,k}*sn.rates(i,k)*sn.nservers(i);
            end
    end
end
Ufull(isnan(Ufull))=0;

for i=1:M
    sd = find(Qfull(i,:)>0);
    Rfull(i,Qfull(i,:)==0)=0;
    for k=sd
        switch sn.schedid(i)
            case SchedStrategy.ID_INF
                % no-op
            otherwise
                Rfull(i,k) = Qfull(i,k) / Tfull(i,k);
        end
    end
end
Rfull(isnan(Rfull))=0;

for k=1:K
    if sn.refstat(k)>0 % ignore artificial classes
        Xfull(k) = Tfull(sn.refstat(k),k);
        Cfull(k) = sn.njobs(k) ./ Xfull(k);
    end
end

lastSolution.odeStateVec = ymean{end};
lastSolution.sn = sn;
end
