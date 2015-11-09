#!/usr/bin/octave
clear;
n = 50; N = 100; h = 1;
times = 100; lamda = 0.1;
threshold = 0.01;
data = linspace(-5,5,n);
y = sin(pi*data)./data+0.3*data+0.05*randn(1,n);
K = exp(-(data-data').^2/(h^2));
m = 5; index = mod(randperm(n),m) + 1;
g = zeros(m,1);
for j=1:m                       %Cross-validation
  ki = K(index~=j,:)(:,index~=j);
  kc = K(index==j,:)(:,index~=j);
  yi = y(:,index~=j);
  yc = y(:,index==j);
  ki_size = size(ki)(1);
  theta = zeros(ki_size,1); z = theta; u = zeros(ki_size,1);
  for i=1:times
    theta = pinv(ki'*ki+eye(ki_size))*(ki'*yi'+z-u);
    z = max(0,theta+u-lamda*ones(ki_size,1)) - \
           max(0,-theta-u-lamda*ones(ki_size,1));
    u = u+theta-z;
  end
  zero_item = 0;
  for i=1:ki_size         %set small value to zero
    if abs(theta(i))<threshold
      theta(i) = 0;
      zero_item = zero_item + 1;
    end
  end
  g(j) = mean((yc'-kc*theta).^2);
end
theta = zeros(n,1);  z = theta; u = zeros(n,1);
for i=1:10
  theta = pinv(K'*K+eye(n))*(K'*y'+z-u);
  z = max(0,theta+u-lamda*ones(n,1)) - \
         max(0,-theta-u-lamda*ones(n,1));
  u = u+theta-z;
end
zero_item = 0;
for i=1:n
  if abs(theta(i))<threshold
    theta(i) = 0; zero_item = zero_item + 1;
  end
end

result_data = linspace(-5,5,N);
result_K = exp(-(result_data'-data).^2/(h^2));
result_y = result_K*theta;

theta2 = pinv(K'*K+lamda*eye(n))*(K'*y');
result_y2 = result_K*theta2;

plot(result_data,result_y2,"r-"); hold on;
plot(data,y,"go"); hold on;
plot(result_data,result_y,"b-");
title(sprintf("zero number %d, err= %e",zero_item,mean(g)));
axis([-5, 5, -3, 4])
print -djpg image.jpg
pause
