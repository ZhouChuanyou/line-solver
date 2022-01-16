function line_warning(caller, MSG, varargin)
% LINE_WARNING(CALLER, ERRMSG)

% Copyright (c) 2012-2022, Imperial College London
% All rights reserved.

persistent lastWarning;
persistent suppressedWarnings;
persistent suppressedWarningsTic;
persistent lastWarningTime;

errmsg=sprintf(MSG, varargin{:});
w = warning('QUERY','ALL');
switch w(1).state
    case 'on'
        %warning('[%s] %s',caller,MSG);
        finalmsg = sprintf('Warning [%s]: %s',caller,errmsg);
        try
            if ~strcmp(finalmsg, lastWarning) || (toc(lastWarningTime)-suppressedWarningsTic)>10
                line_printf(finalmsg);
                lastWarning = finalmsg;
                suppressedWarnings = false;
                suppressedWarningsTic = -1;
                lastWarningTime=tic;
            else
                if ~suppressedWarnings
                    line_printf(sprintf('Warning [%s]: %s',caller,'Warning message casted more than once, repetitions will not be printed on screen for 10 seconds.'));
                    suppressedWarnings = true;
                    suppressedWarningsTic = tic;
                end
            end
        catch ME
            switch ME.identifier
                case 'MATLAB:toc:callTicFirstNoInputs'
                    
                    line_printf(finalmsg);
                    lastWarning = finalmsg;
                    suppressedWarnings = false;
                    suppressedWarningsTic = -1;
                    lastWarningTime=tic;
            end
        end
    case 'off'
        %line_printf(sprintf('Warning [%s]: %s',caller,errmsg));
end
end
