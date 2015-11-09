#!/usr/bin/octave

clear all; rand('state',0); randn('state',0);
n=50; N=1000;
x=linspace(-5,5,n)'; 
X=linspace(-5,5,N)';
pix=pi*x; 
y=sin(pix)+0.3*x.^2+0.1*randn(n,1);

x2=x.^2; 
X2=X.^2; 
%l_list = [0.01,0.03,0.1,0.3,1,3,10];
%hh_list = [0.01,0.03,0.1,0.3,1,3,10];
l_list = [0.03,0.1,0,3];
hh_list = [0.03,0.1,0.3];
hight = length(l_list);
weigh = length(hh_list);

group_N = 3;

for i=1:length(l_list)
  for j=1:length(hh_list)

    subplot(hight,weigh,j+(i-1)*weigh);
    hh=hh_list(i); 
    l=l_list(j);
    k=exp(-(repmat(x2,1,n)+repmat(x2',n,1)-2*x*x')/hh);
    K=exp(-(repmat(X2,1,n)+repmat(x2',N,1)-2*X*x')/hh);
    err = 0;
    for g=1:group_N
      tran_x = x;
      tran_y = y;
      tran_x(g:group_N:n,:)=[]; 
      tran_k =exp(-(repmat((tran_x.^2),1,length(tran_x))+repmat((tran_x.^2)',length(tran_x),1)-2*tran_x*tran_x')/hh);
      tran_y(g:group_N:n,:)=[]; 
      
      test_x = x(g:group_N:n,:);
      test_y = y(g:group_N:n,:);

      t=pinv((tran_k^2+l*eye(size(tran_k)(1))))*(tran_k*tran_y); 
      test_k =exp(-(repmat(test_x',length(tran_x),1)-repmat(tran_x,1,length(test_x)).^2)/hh);
      err += 1/length(test_y)*(test_k'*t-test_y)'*(test_k'*t-test_y);
    end
    err = err/group_N
    t=pinv((k^2+l*eye(n)))*(k*y); 
    F=K*t;

    %clf;
      hold on; axis([-5 5 -1 8]);
      title(sprintf("h=%0.2f, l=%0.2f",hh,l)); 
      plot(X,F,'r-'); 
      plot(x,y,'go'); 
      print(sprintf("%0.2f_%0.2f.png",l,hh),"-dpng")
  end
end
pause
