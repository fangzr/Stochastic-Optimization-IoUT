function L_sum = Get_data_L_bitrate(final)
len = size(final,2);
L_sum = zeros(1,len);


for i=1:len
    L_sum(1,i)=final(i).L_sum;
end