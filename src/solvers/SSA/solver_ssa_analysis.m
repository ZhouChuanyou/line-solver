function [QN,UN,RN,TN,CN,XN,runtime] = solver_ssa_analysis(qn, options)
% Copyright (c) 2012-2018, Imperial College London
% All rights reserved.

M = qn.nstations;    %number of stations
K = qn.nclasses;    %number of classes

mu = qn.mu;
phi = qn.phi;
S = qn.nservers;
NK = qn.njobs';  % initial population per class
sched = qn.sched;
Tstart = tic;

PH=cell(M,K);
for i=1:M
    for k=1:K
        if isempty(mu{i,k})
            PH{i,k} = [];
        elseif length(mu{i,k})==1
            PH{i,k} = map_exponential(1/mu{i,k});
        else
            D0 = diag(-mu{i,k})+diag(mu{i,k}(1:end-1).*(1-phi{i,k}(1:end-1)),1);
            D1 = zeros(size(D0));
            D1(:,1)=(phi{i,k}.*mu{i,k});
            PH{i,k} = map_normalize({D0,D1});
        end
    end
end

switch options.method
    case 'serial-hashed'
        [pi,SSq,arvRates,depRates] = solver_ssa_hashed(qn, options);   
        XN = NaN*zeros(1,K);
        UN = NaN*zeros(M,K);
        QN = NaN*zeros(M,K);
        RN = NaN*zeros(M,K);
        TN = NaN*zeros(M,K);
        CN = NaN*zeros(1,K);
        for k=1:K
            refsf = qn.stationToStateful(qn.refstat(k));
            XN(k) = pi*arvRates(:,refsf,k);
            for i=1:M
                isf = qn.stationToStateful(i);
                TN(i,k) = pi*depRates(:,isf,k);
                QN(i,k) = pi*SSq(:,(i-1)*K+k);
                switch sched{i}
                    case SchedStrategy.INF
                        UN(i,k) = QN(i,k);
                    otherwise
                        % we use Little's law, otherwise there are issues in
                        % estimating the fraction of time assigned to class k (to
                        % recheck)
                        if ~isempty(PH{i,k})
                            UN(i,k) = pi*arvRates(:,i,k)*map_mean(PH{i,k})/S(i);
                        end
                end
            end
        end
        
        for k=1:K
            for i=1:M
                if TN(i,k)>0
                    RN(i,k) = QN(i,k)./TN(i,k);
                else
                    RN(i,k) = 0;
                end
            end
            CN(k) = NK(k)./XN(k);
        end
        
        QN(isnan(QN))=0;
        CN(isnan(CN))=0;
        RN(isnan(RN))=0;
        UN(isnan(UN))=0;
        XN(isnan(XN))=0;
        TN(isnan(TN))=0;
 
    case {'default','serial'}
        [pi,SSq,arvRates,depRates] = solver_ssa(qn, options);       
        XN = NaN*zeros(1,K);
        UN = NaN*zeros(M,K);
        QN = NaN*zeros(M,K);
        RN = NaN*zeros(M,K);
        TN = NaN*zeros(M,K);
        CN = NaN*zeros(1,K);
        for k=1:K
            refsf = qn.stationToStateful(qn.refstat(k));
            XN(k) = pi*arvRates(:,refsf,k);
            for i=1:M
                isf = qn.stationToStateful(i);
                TN(i,k) = pi*depRates(:,isf,k);
                QN(i,k) = pi*SSq(:,(i-1)*K+k);
                switch sched{i}
                    case SchedStrategy.INF
                        UN(i,k) = QN(i,k);
                    otherwise
                        % we use Little's law, otherwise there are issues in
                        % estimating the fraction of time assigned to class k (to
                        % recheck)
                        if ~isempty(PH{i,k})
                            UN(i,k) = pi*arvRates(:,i,k)*map_mean(PH{i,k})/S(i);
                        end
                end
            end
        end
        
        for k=1:K
            for i=1:M
                if TN(i,k)>0
                    RN(i,k) = QN(i,k)./TN(i,k);
                else
                    RN(i,k) = 0;
                end
            end
            CN(k) = NK(k)./XN(k);
        end
        
        QN(isnan(QN))=0;
        CN(isnan(CN))=0;
        RN(isnan(RN))=0;
        UN(isnan(UN))=0;
        XN(isnan(XN))=0;
        TN(isnan(TN))=0;
 
    case 'parallel'
        laboptions = options;
        spmd
            laboptions.samples = ceil(laboptions.samples / numlabs);
            laboptions.verbose = false;
            if strcmp(options.method, 'parallel')
                [pi,SSq,arvRates,depRates] = solver_ssa(qn, laboptions);
            elseif strcmp(options.method, 'parallel-hashed')
                [pi,SSq,arvRates,depRates] = solver_ssa_hashed(qn, laboptions);
            end
            
            XN = NaN*zeros(1,K);
            UN = NaN*zeros(M,K);
            QN = NaN*zeros(M,K);
            RN = NaN*zeros(M,K);
            TN = NaN*zeros(M,K);
            CN = NaN*zeros(1,K);
            for k=1:K
                refsf = qn.stationToStateful(qn.refstat(k));
                XN(k) = pi*arvRates(:,refsf,k);
                for i=1:M
                    isf = qn.stationToStateful(i);
                    TN(i,k) = pi*depRates(:,isf,k);
                    QN(i,k) = pi*SSq(:,(i-1)*K+k);
                    switch sched{i}
                        case SchedStrategy.INF
                            UN(i,k) = QN(i,k);
                        otherwise
                            % we use Little's law, otherwise there are issues in
                            % estimating the fraction of time assigned to class k (to
                            % recheck)
                            if ~isempty(PH{i,k})
                                UN(i,k) = pi*arvRates(:,i,k)*map_mean(PH{i,k})/S(i);
                            end
                    end
                end
            end
            
            for k=1:K
                for i=1:M
                    if TN(i,k)>0
                        RN(i,k) = QN(i,k)./TN(i,k);
                    else
                        RN(i,k) = 0;
                    end
                end
                CN(k) = NK(k)./XN(k);
            end
            
            QN(isnan(QN))=0;
            CN(isnan(CN))=0;
            RN(isnan(RN))=0;
            UN(isnan(UN))=0;
            XN(isnan(XN))=0;
            TN(isnan(TN))=0;
        end
        
        nLabs = length(QN);
        QNaggr = QN{1}/nLabs;
        UNaggr = UN{1}/nLabs;
        RNaggr = RN{1}/nLabs;
        TNaggr = TN{1}/nLabs;
        CNaggr = CN{1}/nLabs;
        XNaggr = XN{1}/nLabs;        
        for l=2:nLabs % for all labs
            QNaggr = QNaggr + QN{l}/nLabs;
            UNaggr = UNaggr + UN{l}/nLabs;
            RNaggr = RNaggr + RN{l}/nLabs;
            TNaggr = TNaggr + TN{l}/nLabs;
            CNaggr = CNaggr + CN{l}/nLabs;
            XNaggr = XNaggr + XN{l}/nLabs;
        end
        QN = QNaggr;
        UN = UNaggr;
        RN = RNaggr;
        TN = TNaggr;
        CN = CNaggr;
        XN = XNaggr;        
	end  

runtime = toc(Tstart);

if options.verbose > 0
    fprintf(1,'SSA analysis completed in %f sec\n',runtime);
end

end