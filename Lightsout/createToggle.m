function toogle = createToggle(n)
toogle =zeros(n*n,n*n);

 for i=0:n-1
     for j = 0 :n-1
          col = n*i+j;
          toogle(col+1,col+1) = 1;
          
          if i > 0
              toogle(col+1,col-n+1) = 1;
          end
          if i < n-1
             toogle(col+1,col+n+1) = 1;
          end
          if j > 0
              toogle(col+1,col) = 1;
          end
          if j < n-1
              toogle(col+1,col+2) = 1;
          end
%            toogle(i,j) = 1;
     end
end
            
