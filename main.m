clc
clear all
close all
% global 
global tst_outconv
global tst_outunconv
global  state_inbits1; % 【取值-1,0,1】
global state_branch;
global state_branchindex;
global min_for_A;
global min_for_B;
global min_for_C;
global min_for_D;
global Len_data
global mapping1
global mapping2
data0 = randi([0,1],1,200000);
Len_data = length(data0);
nomal_len = Len_data+(3-mod(Len_data,3))
nomal_add = zeros(1,3-mod(Len_data,3))
add_data = [data0,nomal_add]
nomal_in = reshape(add_data,3,nomal_len/3)
mapping1 = [2,-2,0,0,sqrt(2),-sqrt(2),-sqrt(2),sqrt(2)];
mapping2 = [0,0,2,-2,sqrt(2),-sqrt(2),sqrt(2),-sqrt(2)];
mapping3 = [2,0,-2,0];
mapping4 = [0,2,0,-2];
% ViterbiInit; % 【全局变量state_inbits1和state_inbits2 4x4 取值为-1,0,1】
state_inbits1 = [-1 1 0 0;
                 0 0 -1 1;
                 -1 1 0 0;
                 0 0 -1 1];
%卷积编码
%for ii = 1:(Len_data/2)
conv_in = data0(1:2:end);
uncode_in = data0(2:2:end);
uncode_in = [uncode_in 0 0] 
conv_out = encoding_213(conv_in);

%映射到8psk星座图-1
tx_map = zeros(1,2+Len_data/2);
for ii = 1:(2+Len_data/2)
    tx_map(ii) = 4*conv_out(2*ii-1)+2*conv_out(2*ii)+uncode_in(ii); 
end    

[tx_8psk_out] = modulate_8psk(tx_map);
%%映射到8psk星座图-nomal
for ii = 1:(nomal_len/3)
    nomal_map(ii) = 4*nomal_in(1,ii)+2*nomal_in(2,ii)+nomal_in(3,ii); 
end    
[nomal_8psk_out] = modulate_8psk(nomal_map);

for ii = 1:(nomal_len/2)
    qpsk_map(ii) = 2*data0(2*ii-1)+data0(2*ii);
end    
[qpsk_out] = modulate_qpsk(qpsk_map);






figure(1)
   scatter(real(tx_8psk_out),imag(tx_8psk_out),'filled','r')
   title('8PSK调制星座图');
   axis([-2.5 2.5 -2.5 2.5])   

SNR = 0:1:20;

for n = 1:length(SNR)


rx_TC8PSK = awgn(tx_8psk_out,SNR(n),'measured');
rx_nomal8psk = awgn(nomal_8psk_out,SNR(n),'measured');
rx_TCQPSK = awgn(qpsk_out,SNR(n),'measured');
if n == 21
    figure(3)
    scatplot(real(rx_TC8PSK),imag(rx_TC8PSK),'circles')   
end


%viterbi译码_硬判决-------------------------------------------------------------
for ii = 1:Len_data/2+2
    rx_i = real(rx_TC8PSK(ii));
    rx_q = imag(rx_TC8PSK(ii));
    for jj = 1:8
        eu_distance(jj) = (rx_i-mapping1(jj))^2+(rx_q-mapping2(jj))^2;
    end
    [min_distance,min_index] = min(eu_distance);
    demod_arr = de2bi(min_index-1,3,'left-msb');
    viterbi_in(2*ii-1:2*ii) =  demod_arr(1:2) ;
    uncode_out(ii) = demod_arr(3);
end
conv_decout = func_conv_dec_213_hard(viterbi_in);
for ii = 1:Len_data/2
    dec_outbits_h(2*ii-1)= conv_decout(ii);
    dec_outbits_h(2*ii) = uncode_out(ii);
end

%nomal硬判决
for ii = 1:nomal_len/3
    rx_i = real(rx_nomal8psk(ii));
    rx_q = imag(rx_nomal8psk(ii));
    for jj = 1:8
        eu_distance(jj) = (rx_i-mapping1(jj))^2+(rx_q-mapping2(jj))^2;
    end
    [min_distance,min_index] = min(eu_distance);
    demod_arr = de2bi(min_index-1,3,'left-msb');
    nomal_out(3*ii-2:3*ii) = demod_arr(1:3);
end
nomal_finalout = nomal_out(1:Len_data)

%QPSK硬判决
for ii = 1:Len_data/2
    rx_i = real(rx_TCQPSK(ii));
    rx_q = imag(rx_TCQPSK(ii));
    for jj = 1:4
        eu_distance2(jj) = (rx_i-mapping3(jj))^2+(rx_q-mapping4(jj))^2;
    end
    [min_distance,min_index2] = min(eu_distance2);
    demod_arr2 = de2bi(min_index2-1,2,'left-msb');
    QPSK_out(2*ii-1:2*ii) = demod_arr2(1:2);
end
QPSK_finalout = QPSK_out(1:Len_data);





[nErrors_h, BER_h(1,n)] = biterr(data0,dec_outbits_h);
[nErrors_n, BER_n(1,n)] = biterr(data0,nomal_finalout);
[nErrors_Q, BER_Q(1,n)] = biterr(data0,QPSK_finalout);

%软判决----------------------------------------------------------------

Eudistance_computing(rx_TC8PSK);
[dec_outbits_s] =ViterbiDecoder(state_branch,state_branchindex);

[nErrors_s, BER_s(1,n)] = biterr(data0,dec_outbits_s);
end

figure(6)
semilogy(SNR,BER_h,'r');hold on; %对y取对数形式
semilogy(SNR,BER_s,'b');grid on;
semilogy(SNR,BER_n,'g');hold on;
semilogy(SNR,BER_Q,'m');hold on;
xlabel('SNR (dB)'); ylabel('BER');
title('TCM Modulation with a convolutional encoder in an AWGN channel'); 
legend('TCM8psk硬判决','TCM8psk软判决','普通8PSK','QPSK','Location','best')
axis([0 18 10e-5 1])
                           
