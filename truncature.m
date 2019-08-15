function source=truncature(path)
%根据幸存路经，进行回溯译码
[m,n]=size(path);
source=zeros(1,n);
j=1;
for i=n:-1:1
  if path(j,i)<=2
      source(1,i)=0;
  else
      source(1,i)=1;
  end
  j=path(j,i);
end
  source(1:n-1)=source(2:n);
  source(n)=0;
 
