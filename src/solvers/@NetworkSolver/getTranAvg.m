function [QNclass_t, UNclass_t, TNclass_t] = getTranAvg(self,Qt,Ut,Tt)
% [QNCLASS_T, UNCLASS_T, TNCLASS_T] = GETTRANAVG(SELF,QT,UT,TT)

% Return transient average station metrics
%
% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.

if nargin == 1
    [Qt,Ut,Tt] = self.getTranHandles;
end
if nargin == 2
    handles = Qt;
    Qt=handles{1};
    Ut=handles{2};
    %Rt=handlers{3};
    Tt=handles{3};
end

QNclass_t={};
UNclass_t={};
%RNclass_t={};
TNclass_t={};

sn = self.model.getStruct;
minrate = min(sn.rates(isfinite(sn.rates)));
if ~hasTranResults(self)
    if isinf(self.options.timespan(1)) && isinf(self.options.timespan(2))
        self.options.timespan = [0,30/minrate];
        line_warning(mfilename,'Timespan of transient analysis unspecified, setting the timespan option to [0, %d]. Use %s(model,''timespan'',[0,T]) to customize.',self.options.timespan(2),class(self));
    end
    if isinf(self.options.timespan(1))
        line_warning(mfilename,'Start time of transient analysis unspecified, setting the timespan option to [0,%d].',self.options.timespan(2));
        self.options.timespan(1) = 0;
    end
    if isinf(self.options.timespan(2))
        self.options.timespan(2) = 30/minrate;
        line_warning(mfilename,'End time of transient analysis unspecified, setting the timespan option to [%d,%d]. Use %s(model,''timespan'',[0,T]) to customize.',self.options.timespan(1),self.options.timespan(2),class(self));
    end
    runAnalyzer(self);
end

M = sn.nstations;
K = sn.nclasses;
if ~isempty(Qt)
    QNclass_t = cell(M,K);
    UNclass_t = cell(M,K);
    %RNclass_t = cell(M,K);
    TNclass_t = cell(M,K);
    for k=1:K
        for i=1:M
            %%
            if ~Qt{i,k}.disabled && ~isempty(self.result.Tran.Avg.Q)
                ret = self.result.Tran.Avg.Q{i,k};
            else
                ret = NaN;
            end
            metricVal = struct();
            metricVal.handle = {self.model.stations{i}, self.model.classes{k}};
            metricVal.t = ret(:,2);
            metricVal.metric = ret(:,1);
            metricVal.isaggregate = true;
            QNclass_t{i,k} = metricVal;
            
            %%
            if ~Ut{i,k}.disabled && ~isempty(self.result.Tran.Avg.U)
                ret = self.result.Tran.Avg.U{i,k};
            else
                ret = NaN;
            end
            metricVal = struct();
                metricVal.handle = {self.model.stations{i}, self.model.classes{k}};
            metricVal.t = ret(:,2);
            metricVal.metric = ret(:,1);
            metricVal.isaggregate = true;
            UNclass_t{i,k} = metricVal;
            
            %%
            if ~Tt{i,k}.disabled && ~isempty(self.result.Tran.Avg.T)
                ret = self.result.Tran.Avg.T{i,k};
            else
                ret = NaN;
            end
            metricVal = struct();
            metricVal.handle = {self.model.stations{i}, self.model.classes{k}};
            metricVal.t = ret(:,2);
            metricVal.metric = ret(:,1);
            metricVal.isaggregate = true;
            TNclass_t{i,k} = metricVal;
        end
    end
end
end
