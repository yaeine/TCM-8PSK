function source=truncature(path)
%�����Ҵ�·�������л�������
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
 
