function [simDoc, section] = saveModeNames(self, simDoc, section, ind)
% [SIMDOC, SECTION] = SAVEMODENAMES(SIMDOC, SECTION, NODEIDX)

% Copyright (c) 2012-2021, Imperial College London
% All rights reserved.

modeNamesNode = simDoc.createElement('parameter');
modeNamesNode.setAttribute('classPath', 'java.lang.String');
modeNamesNode.setAttribute('name', 'modeNames');
modeNamesNode.setAttribute('array', 'true');

sn = self.getStruct;
numOfModes = sn.nmodes(ind);
for m=1:numOfModes
    
    subModeNameNode = simDoc.createElement('subParameter');
    subModeNameNode.setAttribute('classPath', 'java.lang.String');
    subModeNameNode.setAttribute('name', 'modeName');
    
    valueNode = simDoc.createElement('value');
    valueNode.appendChild(simDoc.createTextNode(sn.modenames{ind}{m}));
    
    subModeNameNode.appendChild(valueNode);
    modeNamesNode.appendChild(subModeNameNode);
end

section.appendChild(modeNamesNode);
end
