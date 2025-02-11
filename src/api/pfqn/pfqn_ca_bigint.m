function [G,lG]=pfqn_ca_bigint(Din,Nin,Zin)
% [GN,LGN]=PFQN_CA_BIGINT(L,N,Z)

% PFQN_CA Exact solution of closed product-form queueing networks by the
% convolution algorithm
%
% [Gn,lGn]=pfqn_ca(L,N,Z)
% Input:
% L : MxR demand matrix. L(i,r) is the demand of class-r at queue i
% N : 1xR population vector. N(r) is the number of jobs in class r
% Z : 1xR think time vector. Z(r) is the total think time of class r
%
% Output:
% Gn : estimated normalizing constat
%
% References:
% J. P. Buzen. Computational algorithms for closed queueing networks with
% exponential servers. Comm. of the ACM, 16(9):527�531, 1973.
%
% H. Kobayashi, M. Reiser. Queueing Networks with Multiple Closed Chains:
% Theory and Computational Algorithms, IBM J. Res. Dev., 19(3), 283--294,
% 1975.
try
    import DataStructures.*; %#ok<SIMPT>
    import QueueingNet.*; %#ok<SIMPT>
    import DataStructures.*; %#ok<SIMPT>
    import Utilities.*; %#ok<SIMPT>
catch
    javaaddpath(which('pfqn_nclib.jar'));
    import DataStructures.*; %#ok<SIMPT>
    import QueueingNet.*; %#ok<SIMPT>
    import DataStructures.*; %#ok<SIMPT>
    import Utilities.*; %#ok<SIMPT>
end


Din=Din(sum(Din,2)>Distrib.Zero,:);
% rescale
numdigits = max(arrayfun(@(e) numel(num2str(e)), [Din(:);Zin(:)]));
scaleexp = min(numdigits,8);  % java.lang.Integer takes max 10 digits
scale = 10^(scaleexp);
Din = round(Din*scale); 
Zin = round(sum(Zin*scale,1));

[M,R]=size(Din);
[~,I]=sort(sum(Din,1),'descend');
Din = Din(:,I);
Nin = Nin(1,I);
Zin = Zin(:,I);

N = javaArray('java.lang.Integer',R);
for r=1:R
    N(r) = java.lang.Integer(Nin(r));
end

mult = javaArray('java.lang.Integer',M);
for i=1:M
    mult(i) = java.lang.Integer(1);
end

Z= javaArray('java.lang.Integer',R);
for r=1:R
    Z(r) = java.lang.Integer(Zin(r));
end

D = javaArray('java.lang.Integer',M,R);
for i=1:M
    for r=1:R
        D(i,r) = java.lang.Integer(Din(i,r));
    end
end

qnm = QNModel(M,R);
qnm.N = PopulationVector(N);
qnm.Z = EnhancedVector(Z);
qnm.multiplicities = MultiplicitiesVector(mult);
qnm.D = D;
comom = ConvolutionSolver(qnm);
comom.computeNormalisingConstant();
G = qnm.getNormalisingConstant();
lG = G.log();
lG = lG - sum(Nin)*log(scale);
G = exp(lG);
end