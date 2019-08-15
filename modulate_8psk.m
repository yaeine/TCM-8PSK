function [tx_8psk_out] = modulate_8psk(tx_map)
mapping1 = [2,-2,0,0,sqrt(2),-sqrt(2),-sqrt(2),sqrt(2)];
mapping2 = [0,0,2,-2,sqrt(2),-sqrt(2),sqrt(2),-sqrt(2)];
tx_8psk_out = zeros(1,length(tx_map));
for ii = 1:length(tx_map)
    tx_8psk_out(ii) = mapping1(tx_map(ii)+1)+i*mapping2(tx_map(ii)+1);
end
end