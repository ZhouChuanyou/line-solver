function networks = refreshLayers(self)
% NETWORKS = REFRESHLAYERS()

% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.

self.updateEnsemble(false);
networks = self.ensemble;
end
