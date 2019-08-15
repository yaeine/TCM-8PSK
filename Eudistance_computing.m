function[state_branch,state_branchindex] = Eudistance_computing(rx_TC8PSK)
global Len_data;
frame_len = Len_data
yc=real(rx_TC8PSK);
ys=imag(rx_TC8PSK);

global state_branch;
state_branch=zeros(4,4,2+frame_len/2);
%state_branch=[];
global state_branchindex;
state_branchindex=zeros(4,4,2+frame_len/2);
%state_branchindex=[];
global min_for_A;
min_for_A=zeros(1,2+frame_len/2);
global min_for_B;
min_for_B=zeros(1,2+frame_len/2);
global min_for_C;
min_for_C=zeros(1,2+frame_len/2);
global min_for_D;

for i=1:2+frame_len/2
%    A 0,8,16,24
sub_A=[(yc(i)-2)^2+(ys(i)-0)^2, (yc(i)+2)^2+(ys(i)-0)^2];
sub_B=[(yc(i)-0)^2+(ys(i)-2)^2, (yc(i)-0)^2+(ys(i)+2)^2];
sub_C=[(yc(i)-sqrt(2))^2+(ys(i)-sqrt(2))^2, (yc(i)+sqrt(2))^2+(ys(i)+sqrt(2))^2];
sub_D=[(yc(i)+sqrt(2))^2+(ys(i)-sqrt(2))^2, (yc(i)-sqrt(2))^2+(ys(i)+sqrt(2))^2];
[min_for_A(i),index_for_A(i)]=min(sub_A);
[min_for_B(i),index_for_B(i)]=min(sub_B);
[min_for_C(i),index_for_C(i)]=min(sub_C);
[min_for_D(i),index_for_D(i)]=min(sub_D);


state_branch(1:4,1:4,i) = [min_for_A(i) min_for_D(i) Inf Inf;
                           Inf Inf min_for_B(i) min_for_C(i);
                           min_for_D(i) min_for_A(i) Inf Inf;
                           Inf Inf min_for_C(i) min_for_B(i)];


state_branchindex(1:4,1:4,i) = [index_for_A(i) index_for_D(i) Inf Inf;
                           Inf Inf index_for_B(i) index_for_C(i);
                           index_for_D(i) index_for_A(i) Inf Inf;
                           Inf Inf index_for_C(i) index_for_B(i)];

                                                      
end

end


