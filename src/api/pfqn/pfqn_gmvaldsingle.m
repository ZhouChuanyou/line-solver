function [lG,G]=pfqn_gmvaldsingle(L,N,mu,options)
% G=PFQN_GMVALDSINGLE(L,N,MU)

if nargin<4
    options = [];
end

[M,R]=size(L);
if R>1
    line_error(mfilename,'multiclass model detected. gmvaldsingle is for single class models.');
end
g = L(1,1)*0;
for n=1:N
    g(0 +1,n +1, 1 +1)=0;
end
for m=1:M
    for tm=1:(N+1)
        g(m +1,0 +1,tm +1)=1;
    end
    for n=1:N
        for tm=1:(N-n+1)
            g(m +1, n +1, tm +1)= g(m-1 +1, n +1, 1 +1)+L(m)*g(m +1, n-1 +1, tm+1 +1)/mu(m,tm);
        end
    end
end
G = g(M +1,N +1,1 +1);
lG = log(G);
end