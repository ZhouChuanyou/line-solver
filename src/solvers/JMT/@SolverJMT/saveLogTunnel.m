function [simDoc, section] = saveLogTunnel(self, simDoc, section, ind)
% [SIMDOC, SECTION] = SAVELOGTUNNEL(SIMDOC, SECTION, NODEIDX)

% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.

sn = self.getStruct;
loggerNodesCP = {'java.lang.String','java.lang.String'};
for i=3:9 loggerNodesCP{i} = 'java.lang.Boolean'; end
loggerNodesCP{10} = 'java.lang.Integer';

loggerNodesNames = {'logfileName','logfilePath','logExecTimestamp', ...
    'logLoggerName','logTimeStamp','logJobID', ...
    'logJobClass','logTimeSameClass','logTimeAnyClass', ...
    'numClasses'};
numOfClasses = sn.nclasses;

% logger specific path does not work in JMT at the moment
if ~strcmpi(sn.varsparam{ind}.filePath(end),filesep)
    currentNode.filePath = [sn.varsparam{ind}.filePath, filesep];
end

loggerNodesValues = {sn.varsparam{ind}.fileName, sn.varsparam{ind}.filePath, ...
    sn.varsparam{ind}.startTime,sn.varsparam{ind}.loggerName, ...
    sn.varsparam{ind}.timestamp,sn.varsparam{ind}.jobID, ...
    sn.varsparam{ind}.jobClass,sn.varsparam{ind}.timeSameClass, ...
    sn.varsparam{ind}.timeAnyClass,int2str(numOfClasses)};

for j=1:length(loggerNodesValues)
    loggerNode = simDoc.createElement('parameter');
    loggerNode.setAttribute('classPath', loggerNodesCP{j});
    loggerNode.setAttribute('name', loggerNodesNames{j});
    valueNode = simDoc.createElement('value');
    valueNode.appendChild(simDoc.createTextNode(loggerNodesValues{j}));
    loggerNode.appendChild(valueNode);
    section.appendChild(loggerNode);
end
end
