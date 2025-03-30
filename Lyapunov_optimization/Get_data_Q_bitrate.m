function Q_sum = Get_data_Q_bitrate(final)
len = size(final,2);
Q_sum = zeros(1,len);


for i=1:len
    Q_sum(1,i)=final(i).Q_sum;
end