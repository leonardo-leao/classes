%%============================================================================
%%                    Main Code
%%============================================================================
% clear all
close all

RA = 217276;


%%  Resposta Onda Quadrada
%%============================================================================
%%  Considera��es
%   Define-se a Onda Quadrada como uma Fun��o Par, isto �, sim�trica com
%   rela��o ao eixo y.
%        ___     
%       |   |    
%       |   |   
%   ____|   |____
%
%   Desta forma, define-se as seguintes vari�veis:

T   = 0.2;  % Per�odo Total da Onda
tau = T/2;  % Duty Cicle    da Onda
F   = 1/T;  % Frequ�ncia    da Onda
A   = 1;    % Amplitude     da Onda

%   Pela defini��o de S�rie de Fourier � an�lise seria realizada de -inf
%   at� +inf, entretanto considera-se que um intervalo sim�trico definido
%   a partir da seguinte constante ser� suficiente:

N   = 20;   % Extremo de An�lise


%%  S�rie de Fourier da Entrada
%   Realizando o c�lculo anal�tico obt�m-se a equa��o apresentada no for,
%   representando os coeficientes de Fourier da express�o desejada.
%   
%   Note que como a fun��o foi definida como par apenas estes coeficientes
%   precisaram ser calculados.

i   = 0;    % Contador
for k = -N:1:N
    % -N:   Limite Inferior
    %  1:   Passo
    % +N:   Limite Superior

    i = i+1;
    X(i) = (A*(tau/T))*sinc(F*tau*k);
    % Note que a fun��o sinc trazida pelo Matlab j� apresenta pi em seu
    % c�lculo logo esta constante n�o � incluida.
end

figure
stem(abs(X))
title('S�rie de Fourier da Entrada')
xlabel('  []')
ylabel('X []')

%   figure: create figure window
%   stem:   plots the data sequence Y
%   abs:    when X is complex, abs(X) is the complex modulus


%%  Fun��o de Transfer�ncia do Sistema
%   Considera-se que a Onda Quadrada descrita anteriormente ser� aplicada
%   como entrada de um sistema Massa-Mola-Amortecedor, obtendo a solu��o 
%   em Regime Permanente. (N�o h� transiente)
%
%   Frequency Response Functions FRFs
%
%   Nota-se as seguintes propriedades da S�rie de Fourrier:
%   y(t) = h(t) * x(t) <-> Y(jw) = H(jw) . X(jw)

M = 1;      % Massa
K = 10000;  % Constante El�stica
C = 10;     % Constante de Amortecimento
w = 2*pi*F; % Frequ�ncia

i = 0;  % Contador
for k = -N:1:N
    % -N:   Limite Inferior
    %  1:   Passo
    % +N:   Limite Superior

    i = i+1;
    H(i) = 1/(M*(1i*w*k)^2 + (1i*w*k)*C + K);
    % Note que a apesar de 'i' ser um contador '1i' representa a unidade
    % complexa.
end

figure
stem(abs(H))
title('S�rie de Fourier da FRF')
xlabel('  []')
ylabel('H []')


%%  S�rie de Fourier da Sa�da
%   

Y = H.*X;   % Multiplica��o Termo a Termo

figure
stem(abs(Y))
title('S�rie de Fourier da Sa�da')
xlabel('  []')
ylabel('Y []')


%%  S�rie de Fourier Inversa
%   Ser� necess�rio converter os valores da S�rie para valores temporais
%   realizando o somat�rio das exponenciais.

I = 10;             % Interval Length
t = 0:.001:I;       % Vetor de Tempo
y = zeros(size(t)); % Vetor de Sa�da

i = 0;  % Contador
for k = -N:1:N
    % -N:   Limite Inferior
    %  1:   Passo
    % +N:   Limite Superior
    
    i = i+1;
    y = y + Y(i)*exp(1i*w*k*t);
end

dt  = (3*T)/4;  % Deslocamento Temporal

figure
plot(t, real(y), out.tout-dt, out.simout, '+')
title('Resposta Temporal da Sa�da')
xlabel('t [s]')
ylabel('y []')

%   Nota-se que a defini��o do Matlab apresenta uma onda que se inicia no
%   zero.
%   Como deseja-se uma Onda Quadrada Par realiza-se o deslocamento
%   temporal.

%%  Refer�ncia
%   https://en.wikipedia.org/wiki/Fourier_series
%   https://en.wikipedia.org/wiki/Poisson_summation_formula