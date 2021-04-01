function [X,Y] = Heun(f,h,XRANGE,YINIT)

% f � a fun��o.
% h � o tamanho do passo
% XRANGE = [x0 xFinal]
% YINIT � o valor y(x0)

X(1) = XRANGE(1);
Y(1)= YINIT;
k = 1; % N�mero de intera��es

while X(k)<XRANGE(2)
  X(k+1) = X(k)+h;
  k1 = f(X(k),Y(k));
  k2 = f(X(k+1),Y(k)+h*k1);
  Y(k+1) = Y(k)+h*(k1+k2)/2;
  k=k+1;
end
endfunction