function [conv_out] = encoding_213(conv_in)
g1 = [1 0 1];
g2 = [1 1 1];
mem = zeros(1,2)

for ii=1:length(conv_in)   
    inter_var = [conv_in(ii) mem];
    first_out(ii)=mod(sum(g1.*inter_var),2);
    second_out(ii)=mod(sum(g2.*inter_var),2);
    mem = inter_var(1:end-1);
    conv_out(ii*2-1:ii*2)=[first_out(ii) second_out(ii)];
end
conv_out = [conv_out 0 0 0 0]
end

