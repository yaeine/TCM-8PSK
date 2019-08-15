function [tx_qpsk_out] = modulate_qpsk(tx_map)
mapping3 = [2,0,-2,0];
mapping4 = [0,2,0,-2];
tx_qpsk_out = zeros(1,length(tx_map));
for ii = 1:length(tx_map)
    tx_qpsk_out(ii) = mapping3(tx_map(ii)+1)+i*mapping4(tx_map(ii)+1);
end
end