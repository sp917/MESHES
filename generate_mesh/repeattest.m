function repeats = repeattest(A)
%   Given an array A, we test to see if EVERY element of A is repeated
%   If there is any element not repeated, we return 0. Otherwise we
%   return 1.

A = A(:); %We only care about the entries, so the shape is not important
disp('repeattest')
tic

[C,ia,ic] = unique(A);
a_counts = accumarray(ic,1);

if sum(a_counts==1) == 0
    repeats = 1;
else
    repeats = 0;
end
 
toc
end


