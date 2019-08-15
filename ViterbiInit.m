function  ViterbiInit
global  state_inbits1;


state_inbits1=zeros(4,4);


mem=zeros(1,2);
for s1=0:3
    for in1=0:1
        mem=de2bi(s1,2,'left-msb');

        mid1=in1;
        mid2=mem(1);
        mid3=mem(2);

        mem(1)=mid1;
        mem(2)=mid2;
        
        s2=bi2de([mem(1) mem(2)],'left-msb');
        state_inbits1(s1+1,s2+1)=2*in1-1;

        
        

    end
end

end
