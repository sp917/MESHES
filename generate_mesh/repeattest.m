function repeats = repeattest(A)
%   Given an array A, we test to see if EVERY element of A is repeated
%   If there is any element not repeated, we return 0. Otherwise we
%   return 1.

A = A(:); %We only care about the entries, so the shape is not important

repeats = 1;
for i = 1:length(A)
    if (sum(A == A(i)) < 2)
        repeats = 0;
        break
    end
end

end

