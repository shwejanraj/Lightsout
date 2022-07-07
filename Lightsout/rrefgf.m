function [Arref,jb] = rrefgf(A,field)

[m,n] = size(A);

if (field <= 1) || (rem(field,1) ~= 0) || (field > 2^31)
  error('field must be a positive integer greater than 1, not exceeding 2^31.')
end

Arref = A;
A = int64(A);
field = int64(field);
% reduce A modulo field, just in case
A = mod(A,field);

% is field a prime number? If it is, this makes the code simpler.
isp = isprime(field);

% Loop over the entire matrix.
i = 1;
j = 1;
jb = [];
while (i <= m) && (j <= n)
   % Find value and index of the first non-zero element in column j
   % that is relatively prime to field.
   if isp
     % just find the first non-zero remaining in column j
     k = find(A(i:m,j),1,'first');
%      disp(k)
   else
     % find the first element remaining in the jth column that has a gcd of
     % 1 with field.
     k = find(gcd(A(i:m,j),field) == 1,1,'first');
   end
   if isempty(k)
     % the remaining column elements are all zero or non-invertible
     % in this field.
     p = 0;
   else
     % an element was found
     k = i + k - 1;
     p = A(k,j);  %getting pivot element.
   end
   
   if (p == 0)
      % The column is negligible, zero it out.
      A(i:m,j) = zeros(m-i+1,1,'int64');
      j = j + 1;
   else
      % Remember column index
      jb = [jb j];
      % Swap i-th and k-th rows.
      A([i k],j:n) = A([k i],j:n);
      % Divide the pivot row by the pivot element. This turns into a 
      % multiply by the modular inverse of the pivot.
      pivinv = minv(p,field);
      A(i,j:n) = mod(A(i,j:n)*pivinv,field);
      % Subtract multiples of the pivot row from all the other rows.
      for k = [1:i-1 i+1:m]
         A(k,j:n) = mod(A(k,j:n) - A(k,j)*A(i,j:n),field);
      end
      i = i + 1;
      j = j + 1;
   end
end

% done. We need to return A to its original class.
Arref(:) = A;

function xinv = minv(x,field)
  % returns the modular inverse of x in the defined field.
  [G,C,~] = gcd(x,field);
  if G ~= 1
    xinv = [];
  else
    % the other outputs [G,C,D]=gcd(x,field) are such that 
    % x*C + field*D = G
    % we don't care about D (the third output), so C gives us the modular
    % inverse of x. Make sure it is reduced though.
    xinv = mod(C,field);
  end
  
  