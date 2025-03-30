function L_t = Get_data_L_V(final)
len = size(final,2);
L_t = zeros(1,len);


for i=1:len
    L_t(i)=final(i).L_sum;
end