function  [dec_outbits ] =ViterbiDecoder(state_branch,state_branchindex)
global state_branch;
global state_branchindex;
global  state_inbits1;
global ztdl;%状态度量
global xclj; %幸存路径
global Len_data;
global tst_outconv
global tst_outunconv
warning off;

L=2+Len_data/2;

dec_outbits=zeros(1,2*L-4);
ztdl=zeros(L+1,4);
xclj=zeros(4,4,L);
ztdl(1,1) =1;

%求状态度量和幸存路径
for k=2:L+1                                                                        %for1
    for s2=0:3                                                                    %for2
        duliang=[inf inf];
        state=zeros(1,2);
        index=0;
        for s1=0:3                                                            %for3
                if ztdl(k-1,s1+1)==0                                                         %if1
                   continue;    
                end                                                                           %end if1
%                 if state_branch(s1+1,s2+1,k-1)~=0                                                 %if2
                    index=index+1;
                    duliang(index)=state_branch(s1+1,s2+1,k-1)+ztdl(k-1,s1+1);
                    state(index)=s1;
%                 end                                                                           %end if2
        end                                                                                   %end for3
        if index~=0                                                                           %if3
            [zuixiao,index]=min(duliang);
            ztdl(k,s2+1)=zuixiao;
            xclj(state(index)+1,s2+1,k-1)=1;
        end                                                                                   %end if3
    end                                                                                       %end for2
end                                                                                           %end for1

%输出
s2=0;
for k=L:-1:1                                                                               %for4
    for s1=0:3                                                                    %for5
        if xclj(s1+1,s2+1,k)==1                                                               %if4
            if k<=L-2                                                              %if5
                dec_outbits(2*k-1)=(state_inbits1(s1+1,s2+1)+1)/2;        %输出的最低位
                tst_outconv(k) = (state_inbits1(s1+1,s2+1)+1)/2;
                dec_outbits(2*k)=state_branchindex(s1+1,s2+1,k)-1;                    %输出的次高位
                tst_outunconv(k)= state_branchindex(s1+1,s2+1,k)-1;
            end                                                                               %end if5
            s2=s1;%更新状态
            break;                                                                            
        end                                                                                   %end if4
    end                                                                                       %end for5
end                                                                                           %end for4
%global  inbits;
%A=zeros(1,80);
%for i=1:80
%if inbits(i)~=dec_outbits(i)
%   error=99;
%   error
%   inbits
%end
%end

