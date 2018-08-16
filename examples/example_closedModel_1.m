clear;
model = Network('model');

node{1} = DelayStation(model, 'Delay');
node{2} = QueueingStation(model, 'Queue1', SchedStrategy.FCFS);
jobclass{1} = ClosedClass(model, 'Class1', 1, node{1}, 0);

node{1}.setService(jobclass{1}, Exp.fitMoments(1.0)); % mean = 1
node{2}.setService(jobclass{1}, Exp.fitMoments(1.5)); % mean = 1.5

P{1} = [0.7,0.3;1.0,0];
model.linkNetwork(P);

solver = {};
solver{end+1} = SolverCTMC(model);
solver{end+1} = SolverJMT(model, 'seed',2300, 'verbose',true);
solver{end+1} = SolverSSA(model, 'seed',2300, 'verbose',true);
solver{end+1} = SolverFluid(model);
solver{end+1} = SolverMVA(model);
solver{end+1} = SolverNC(model,'method','exact');
solver{end+1} = SolverAuto(model);

for s=1:length(solver)
    fprintf(1,'SOLVER: %s\n',solver{s}.getName());    
    AvgTable = solver{s}.getAvgTable()
end
