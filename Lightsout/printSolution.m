function printSolution(n,m)
a = createToggle(n);
a(:,n*n+1) = m;
[Ar,jb] = rrefgf(a,2);
disp('The solution is : ')
for i=1:n*n
      fprintf('%d ', Ar(i,n*n+1));
      pause(0.1)
      if mod(i,n)==0
          fprintf("\n");
      end
end
end