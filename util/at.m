function [a,i]=at(A,r,i)
if ~iscell(A)
a=A(r);
elseif iscell(A)
a=A{r};
end
if nargin==3
    a=A(r,i);
elseif nargin==2 && length(r)>1 % multidimensional array
    v=r;
    d=size(A);
    i=v(1);
    for j=2:length(d)
        i=i+prod(d(1:(j-1)))*(v(j)-1);
    end
    a=A(i);
end
end