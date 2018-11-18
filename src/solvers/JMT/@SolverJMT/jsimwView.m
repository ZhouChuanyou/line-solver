function jwatView(self, options)
% Copyright (c) 2012-2018, Imperial College London
% All rights reserved.

if ~self.supports(self.model)
    warning('This model is not supported by the %s solver. Quitting.',mfilename);
    runtime = toc(T0);
    return
end
options=self.options;
if options.samples< 5e3
    warning('JMT requires at least 5000 samples for each metric. Setting the samples to 5000.\n');
    options.samples = 5e3;
end
self.seed = options.seed;
self.maxSamples = options.samples;
writeJSIM(self);
cmd = ['java --illegal-access=permit -cp "',self.getJMTJarPath(),filesep,'JMT.jar" jmt.commandline.Jmt jsimw "',self.getFilePath(),'jsimg',filesep, self.getFileName(), '.jsimg" -seed ',num2str(options.seed)];
%            if options.verbose
fprintf(1,'JMT Model: %s\n',[self.getFilePath(),'jsimg',filesep, self.getFileName(), '.jsimg']);
%            end
rt = java.lang.Runtime.getRuntime();
rt.exec(cmd);
%system(cmd);
end