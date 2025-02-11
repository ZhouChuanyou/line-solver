function [Q,U,R,T,C,X,lG,runtime] = solver_mvald_analyzer(sn, options)
% [Q,U,R,T,C,X,RUNTIME] = SOLVER_MVALD_ANALYZER(SN, OPTIONS)

% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.

Tstart = tic;
switch options.method
    case {'exact','mva'}
        if ~isempty(sn.cdscaling)
            line_error(mfilename,'Exact class-dependent solver not available in MVA.');
        end        
        [Q,U,R,T,C,X,lG] = solver_mvald(sn, options);
    case {'default','amva','qd','aql','qdaql'}
        [Q,U,R,T,C,X,lG] = solver_amva(sn, options);
    otherwise
        line_error(mfilename,sprintf('The %s method is not supported by the load-dependent MVA solver.',options.method));
end

runtime = toc(Tstart);

if options.verbose
    %    line_printf('\nMVA load-dependent analysis completed. Runtime: %f seconds.\n',runtime);
end
return
end
