
D=0.372;
d=[0.1:0.01:0.99].*D;
for i=1:size(d,2)
y(i) = (1+0.707./sqrt(1-d(i)^2./D^2))^2.*(D^2./d(i)^2-1)^2;
end
figure
plot(d,y)