function sampleNodeState = sample(self, node, numSamples)
% TRANNODESTATE = SAMPLE(NODE)

options = self.getOptions;
if nargin>=3 %exist('numSamples','var')
    options.samples = numSamples;
else
    numSamples = options.samples;
end
switch options.method
    case {'default','serial'}
        [~, tranSystemState, tranSync] = self.runAnalyzer(options);
        event = tranSync;
        isf = sn.nodeToStateful(node.index);
        sampleNodeState = struct();
        sampleNodeState.handle = node;
        sampleNodeState.t = tranSystemState{1};
        sampleNodeState.state = tranSystemState{1+isf};
        
        sn = self.getStruct;
        sampleNodeState.event = {};
        for e = 1:length(event)
            for a=1:length(sn.sync{event(e)}.active)
                sampleNodeState.event{end+1} = sn.sync{event(e)}.active{a};
                sampleNodeState.event{end}.t = sampleNodeState.t(e);
            end
            for p=1:length(sn.sync{event(e)}.passive)
                sampleNodeState.event{end+1} = sn.sync{event(e)}.passive{p};
                sampleNodeState.event{end}.t = sampleNodeState.t(e);
            end
        end
        sampleNodeState.isaggregate = false;

    otherwise
        line_error(mfilename,'sample is not available in SolverSSA with the chosen method.');
end
sampleNodeState.t = [0; sampleNodeState.t(2:end)];
end