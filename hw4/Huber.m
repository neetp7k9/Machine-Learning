#!/usr/bin/octave
function y=Huber(x,u)
  y = zeros(length(x),1);
  for i=1:length(x)
    if abs(x(i))>u
      y(i) = u*abs(x(i))-u*u/2;
    else
      y(i) = (x(i)*x(i))/2;
    end
  end
end

