function [simElem, simNode] = saveClasses(self, simElem, simNode)
% Copyright (c) 2012-2018, Imperial College London
% All rights reserved.

numOfClasses = length(self.model.classes);
for i=1:(numOfClasses)
    currentClass = self.model.classes{i,1};
    userClass = simNode.createElement('userClass');
    userClass.setAttribute('name', currentClass.name);
    userClass.setAttribute('type', currentClass.type);
    userClass.setAttribute('priority', int2str(currentClass.priority));
    if strcmp(currentClass.type, 'closed') % do nothing if open
        userClass.setAttribute('customers', int2str(currentClass.population));
        userClass.setAttribute('referenceSource', currentClass.reference.name);
    elseif strcmp(currentClass.reference.input.sourceClasses{currentClass.index}{3}.name,'Disabled') % open disabled in source
        userClass.setAttribute('referenceSource', 'ClassSwitch');
    else
        userClass.setAttribute('referenceSource', currentClass.reference.name);
    end
    simElem.appendChild(userClass);
end
end