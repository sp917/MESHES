function C = equaltest(A,B)

%Given any two one-dimensional arrays A,B we return an array of the same size of A telling
%us how many elements of B each element of A is equal to

C = zeros(size(A));

for i = 1:size(A)
    C(i) = sum(B == A(i));
end