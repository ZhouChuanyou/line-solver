function [lG,G] = pfqn_ncld(L,N,Z,mu,varargin)
% [LGN] = PFQN_NCLD(L,N,Z,VARARGIN)

options = Solver.parseOptions(varargin, SolverNC.defaultOptions);
% backup initial parameters

X=[]; Q=[];
mu = mu(:,1:sum(N));
% first remove empty classes
nnzClasses = find(N);
L = L(:,nnzClasses);
N = N(:,nnzClasses);
Z = Z(:,nnzClasses);

% then scale demands in [0,1], importat that stays before the other
% simplications in case both D and Z are all very small or very large in a
% given class, in which case the may look to filter but not if all of them
% are at the same scale
R = length(N);
scalevec = ones(1,R);
for r=1:R
    scalevec(r) = max([L(:,r);Z(:,r)]);
end
L = L ./ repmat(scalevec,size(L,1),1);
Z = Z ./ scalevec;

% remove stations with no demand
Lsum = sum(L,2);
Lmax = max(L,[],2);
demStations = find((Lmax./Lsum)>Distrib.Zero);
L = L(demStations,:);
mu = mu(demStations,:);

% if there is a class with jobs but with L and Z all zero
if any(N((sum(L,1) + sum(Z,1)) == 0)>0)
    line_warning(mfilename,'The model has no positive demands in any class.');
    if isempty(Z) || sum(Z(:))<options.tol
        lG = 0;
    else
        lG = - sum(factln(N)) + sum(N.*log(sum(Z,1))) + N*log(scalevec)';
    end
    return
end

% update M and R
[M,R]=size(L);

% return immediately if the model is a degenerate case
if isempty(L) || sum(L(:))<options.tol % all demands are zero
    if isempty(Z) || sum(Z(:))<options.tol
        lG = 0;
    else
        lG = - sum(factln(N)) + sum(N.*log(sum(Z,1))) + N*log(scalevec)';
    end
    return
elseif M==1 && (isempty(Z) || sum(Z(:))<options.tol) % single node and no think time
    lG = factln(sum(N)) - sum(factln(N)) + sum(N.*log(sum(L,1))) + N*log(scalevec)' - sum(log(mu(1:sum(N))));
    return
end

% determine contribution from jobs that permanently loop at delay
zeroDemandClasses = find(sum(L,1)<options.tol); % all jobs in delay
nonzeroDemandClasses = setdiff(1:R, zeroDemandClasses);

if isempty(sum(Z,1)) || all(sum(Z(:,zeroDemandClasses),1)<options.tol)
    lGzdem = 0;
    Nz = 0;
else
    if isempty(zeroDemandClasses) % for old MATLAB release compatibility
        lGzdem = 0;
        Nz = 0;
    else
        Nz = N(zeroDemandClasses);
        lGzdem = - sum(factln(Nz)) + sum(Nz.*log(sum(Z(:,zeroDemandClasses),1))) + Nz*log(scalevec(zeroDemandClasses))';
    end
end
L = L(:,nonzeroDemandClasses);
N = N(nonzeroDemandClasses);
Z = Z(:,nonzeroDemandClasses);
scalevecz = scalevec(nonzeroDemandClasses);
% compute G for classes No with non-zero demand
[lGnnzdem] = compute_norm_const_ld(L, N, Z, mu, options);
% scale back to original demands
lG = lGnnzdem + lGzdem + N*log(scalevecz)';
G = exp(lG);
end

function [lG] = compute_norm_const_ld(L,N,Z,mu,options)
% LG = COMPUTE_NORM_CONST_LD(L,N,Z,OPTIONS)
[~,R] = size(L);
D = size(Z,1); % number of delays
Lz = [L;Z];
muz = [mu; repmat(1:size(mu,2),D,1)];
switch options.method
    case {'default','exact'}
        if R==1
            [lG] = pfqn_gldsingle(Lz, N, muz, options);
        else
            [~,lG] = pfqn_gld(Lz, N, muz, options);
        end
    case 'rd'
        [lG] = pfqn_rd(L, N, Z, mu, options);
    case {'nrp','nr.probit'}
        [lG] = pfqn_nrp(L, N, Z, mu, options);
    case {'nrl','nr.logit'}
        [lG] = pfqn_nrl(L, N, Z, mu, options);
    otherwise
        line_error(mfilename,sprintf('Unrecognized method for solving load-dependent models: %s',options.method));
end
return
end