%%============================================================================
%%                    Main Code
%%============================================================================
clc
% clear all
close all

RA = 217276;


%%============================================================================
%%  Exerc�cio de Representa��o de Estados Discretos
%%============================================================================

%   Considera-se um sistema de Segunda Ordem com a seguinte equa��o
%   caracter�stica:

%    ddy + (2*qsi*wn)dy + (wn**2)y = (wn**2)*u(t)

%   Forma Padr�o em Estados Cont�nuo
%   | dx(t) = A*x(t) + B*u(t) [2]
%   |  y(t) = C*x(t) + D*u(t) [3]

%   Nota-se que um sistema de estados ser� representado por matrizes e
%   vetores com as seguinte dimens�es:
%       x: n x 1  A: n x n  B: n x r    onde:   r: N�mero de Entradas
%       y: p x 1  C: p x n  D: p x r            p: N�mero de Sa�das
%       u: r x 1

%   Considera-se que o sistema de estados dever� apresentar as seguintes
%   dimens�es neste caso:
%       x: 2 x 1  A: 2 x 2  B: 2 x 1    visto que   n = 2
%       y: 1 x 1  C: 1 x 2  D: 1 x 1                p = 1
%       u: 1 x 1                                    r = 1

%   Descretiza-se o sistema aplicando a seguinte aproxima��o:
%     dx(T) = x(KT+T) - x(KT)   quando T->0
%             ---------------
%                     T
%   Obtendo:
%   | x(k+1) = Ab*x(k) + Bb*u(k) [4]     Ab = (I + TA)   Bb = TB
%   | y(k)   = Cb*x(k) + Db*u(k) [5]     Cb = C          Db = D
%   Onde:
%       T: Per�odo de Amostragem


%   Na sequ�ncia calcula-se a princ�pio a Solu��o Homog�nea (u(t) = 0)
%   como:
%       x(k+1) = a*x(k) obtendo x(k) = A^k x(0)

%   Desta forma, define-se as seguintes vari�veis:

wn  = 100;  % Frequ�ncia Natural do Sistema
qsi = 0.05; % Amortecimento      do Sistema

X0  = [10;  % Valores  = [1;  Espa�o
        0]; % Iniciais    0]  Velocidade
    
%   Realizando as substitui��es adequadas, considerando que as vari�veis
%   auxiliares foram o Espa�o e a Velocidade, obt�m-se as seguintes
%   matrizes:

A0  = [0 1; (-wn^2) (-2*qsi*wn)];
B0  = [0; (wn^2)];
C0  = [1 0];                        % Visualizando Espa�o
D0  = 0;

%   Al�m disso, considera-se que o intervalo de an�lise ser� definido pelas
%   seguintes vari�veis:

tint = 1;       %   In�cio da An�lise
tstp = 0.001;   %   Passo  da An�lise

%   Considera-se tamb�m que a entrada ser� definida pelas seguintes
%   vari�veis:

u    = 1;       % Amplitude    da Entrada (u(t) = 0, Homog�neo)
t0   = 0;       % Deslocamento da Entrada 


%%  M�todo 0: Exponencial (M�todo de Controle)
%%============================================================================

%   Considera-se que a "A^k" ser� o Benchmark dessa an�lise.

[XCL, YCL]  = ssCFree_expm(t0,X0,A0,C0);
[XCF, YCF]  = ssCForced_expm(t0,A0,B0,C0,D0, u);



%%  M�todo 1: Autovalores e Autovetores
%%============================================================================

[XAL, YAL]  = ssCFree_eig(t0,X0,A0,C0);
[XAF, YAF]  = ssCForced_eig(t0,A0,B0,C0,D0, u);



%%  M�todo 2: Inversa de Laplace
%%============================================================================

[XLL, YLL]  = ssCFree_laplace(t0,X0,A0,C0);
[XLF, YLF]  = ssCForced_laplace(t0,A0,B0,C0,D0, u);



%%  M�todo 3: Polinomial (Cayley-Hamilton)
%%============================================================================

[XPL, YPL]  = ssCFree_poly(t0,X0,A0,C0);
[XPF, YPF]  = ssCForced_poly(t0,A0,B0,C0,D0, u);

