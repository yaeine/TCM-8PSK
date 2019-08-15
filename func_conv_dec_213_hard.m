function dec_out=func_conv_dec_213_hard(enc_out)
data_in=enc_out;        %编码输出作为解码模块的输入
%% parameter
n=2;
k=1;
K=3;
m=K-1;
num_state=2^(k*m); 
%%
a=zeros(num_state,4);   %a矩阵存放的是某两种状态转换到该行所代表的状态时的输出，记输入比特为MSB.
                        %前两位对应的是上支路，后两位为下支路，且上支路对应前一状态为较小的值
                        %状态1为00，状态2为01，状态3为10，状态4为11
a(1,:)=[0 0 1 1];       %可以构造状态转换图      [1,2]=>1;[3,4]=>2;[1,2]=>3;[3,4]=>4
a(2,:)=[0 1 1 0];       
a(3,:)=[1 1 0 0];
a(4,:)=[1 0 0 1];
t=length(data_in)/n;    %译码长度
path_metric=zeros(1,4); %路径度量值
path=zeros(num_state,t);
select=zeros(1,num_state);
%% 
for ii=1:t
    for jj=1:2
        temp=zeros(1,2);%temp存放局部路径度量值
        temp(1)=path_metric(2*jj-1)+sum(xor(data_in(2*ii-1:2*ii),a(jj,1:2)));
        temp(2)=path_metric(2*jj)+sum(xor(data_in(2*ii-1:2*ii),a(jj,3:4)));
        if temp(1)<=temp(2)
            
            select(jj)=temp(1);
            path(jj,ii)=2*jj-1;            
        else 
            select(jj)=temp(2);
            path(jj,ii)=2*jj;            
        end        
    end
    for jj=3:3
        temp=zeros(1,2);
        temp(1)=path_metric(jj-2)+sum(xor(data_in(2*ii-1:2*ii),a(jj,1:2)));
        temp(2)=path_metric(jj-1)+sum(xor(data_in(2*ii-1:2*ii),a(jj,3:4)));
        if temp(1)<=temp(2)
            select(jj)=temp(1);
            path(jj,ii)=jj-2;            
        else
            select(jj)=temp(2);
            path(jj,ii)=jj-1;            
        end
    end
    for jj=4:4
        temp=zeros(1,2);
        temp(1)=path_metric(jj-1)+sum(xor(data_in(2*ii-1:2*ii),a(jj,1:2)));
        temp(2)=path_metric(jj)+sum(xor(data_in(2*ii-1:2*ii),a(jj,3:4)));
        if temp(1)<=temp(2)
            select(jj)=temp(1);
            path(jj,ii)=jj-1;            
        else
            select(jj)=temp(2);
            path(jj,ii)=jj;            
        end
    end        
    path_metric=select;
end
%%
dec_out=truncature(path);
end
