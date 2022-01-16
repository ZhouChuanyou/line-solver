classdef activity < BPMN.flowNode
% ACTIVITY abstract class, as part of a Business Process Modeling Notation (BPMN) model. 
%
% Properties:
% property      list of modeler-defined properties (cell of string)
%
% Copyright (c) 2012-2022, Imperial College London 
% All rights reserved.

properties
    property;               % list of modeler-defined properties (cell of string)
    resourceRole;           % resources responsible for performing the activity - IDs (cell of string)
    loopCharacteristics;    % defines if the activity is repeated and loop properties- Type, Testbefore, loopmaximum (cell of string)
end

methods
%public methods, including constructor

    %constructor
    function obj = activity(id, name)
        if(nargin == 0)
            disp('Not enough input arguments'); 
            id = int2str(rand()); 
        elseif(nargin <= 1)
            disp('Not enough input arguments'); 
            name = ['activity_',id];
        end
        obj@BPMN.flowNode(id,name); 
    end
    
    function obj = addProperty(obj, prop)
       if nargin > 1
            if isempty(obj.property)
                obj.property = cell(1);
                obj.property{1} = prop;
            else
                obj.property{end+1,1} = prop;
            end
       end
    end
    
    function obj = addResourceRole(obj, role)
       if nargin > 1
            if isempty(obj.resourceRole)
                obj.resourceRole = cell(1);
                obj.resourceRole{1} = role;
            else
                obj.resourceRole{end+1,1} = role;
            end
       end
    end
    
    function obj = addLoopCharacteristics(obj, type, testbefore, loopmax)
        if nargin > 1
            obj.loopCharacteristics = cell(3);
            obj.loopCharacteristics{1} = type;
            obj.loopCharacteristics{2} = testbefore;
            obj.loopCharacteristics{3} = loopmax;
        end
    end
    
    
    %toString
    function myString = toString(obj)
        myString = toString@BPMN.flowNode(obj);
    end

end
    
end
