function model = gallery_hyphyp1_reentrant
model = Network('Hyper/Hyper/1-Reentrant');
%% Block 1: nodes
source = Source(model, 'Source');
queue = Queue(model, 'Queue', SchedStrategy.FCFS);
queue.setNumberOfServers(2);
sink = Sink(model, 'Sink');
%% Block 2: classes
oclass1 = OpenClass(model, 'Class1');
oclass2 = OpenClass(model, 'Class2');
source.setArrival(oclass1, HyperExp.fitMeanAndSCV(1,64));
source.setArrival(oclass2, Disabled());
queue.setService(oclass1, HyperExp.fitMeanAndSCV(0.5,4));
queue.setService(oclass2, Exp(3));
%% Block 3: topology
P = model.initRoutingMatrix;
P{oclass1,oclass1}(source,queue)=1;
P{oclass1,oclass2}(queue,queue)=1;
P{oclass2,oclass2}(queue,sink)=1;
model.link(P);
end