function model = LINE2SCRIPT(model, filename)
% MODEL = LINE2SCRIPT(MODEL, FILENAME)

% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.
if nargin>=2 %exist('filename','var')
    fid = fopen(filename,'w'); % discard
    QN2SCRIPT(model, model.getName(), fid);
    fclose(fid);
else
    QN2SCRIPT(model, model.getName(), 1);
end
end
