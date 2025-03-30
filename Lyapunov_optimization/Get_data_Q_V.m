function Q_t = Get_data_Q_V(final)
len = size(final,2);
Q_t = zeros(1,len);


for i=1:len
    Q_t(i)=final(i).Q_sum;
end