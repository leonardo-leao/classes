%%============================================================================
%%                    Main Code
%%============================================================================
clc
clear all
close all

RA = 217276;


%%  An�lise de Estados Cont�nuo Homog�neo
%%============================================================================

%   Sistema de Primeira Ordem descrito pela seguinte Equa��o:
%   t*dy(t) + y(t) = g*u(t) [1]

%   Forma Padr�o em Estados
%   | dx(t) = A*x(t) + B*u(t) [2]
%   |  y(y) = C*x(t) + D*u(t) [3]

%   Nota-se que um sistema de estados ser� representado por matrizes e
%   vetores com as seguinte dimens�es:
%       x: n x 1  A: n x n  B: n x r    onde:   r: N�mero de Entradas
%       y: p x 1  C: p x n  D: p x r            p: N�mero de Sa�das
%       u: r x 1                                n: Ordem do Sistema

%   Considera-se que o sistema de estados dever� apresentar as seguintes
%   dimens�es neste caso:
%       x: 2 x 1  A: 2 x 2  B: 2 x 1    onde:   r: 1
%       y: 1 x 1  C: 1 x 2  D: 1 x 1            p: 1
%       u: 1 x 1                                n: 2

%   Toma-se a rela��o x(t) = y(t) [4], logo as equa��es se simplificam
%   para:
%   [4] em [1]: a = -(1/t); b = (g/t);
%   [4] em [3]: c = 1;      d = 0;

%   Na sequ�ncia calcula-se a princ�pio a Solu��o Homog�nea (u(t) = 0)
%   como:
%   dx(t) = a*x(t) obtendo x(t) = x(0)*exp(a*t)


%%  An�lise de Estados Segunda Ordem Homog�nea
%%============================================================================

%   Sistema de Segunda Ordem descrito pela seguinte Equa��o:
%   m*ddy(t) + c*dy(t) + k*y(t) = a*u(t) [1]

%   Exemplo de Aplica��o considerando um Sistema Massa-Mola-Amortecedor:

m   = 1;                    % Massa
k   = 100;                  % Constante El�stica
c   = 10;                   % Constante de Amortecimento

X0  = [1; 0];               % Valores Iniciais de X(t)
U   = 0;                    % Entrada do Sistema (0 = Homog�nea)

A   = [0 1; (-k/m) (-c/m)]; % Matriz de Transi��o de Estado
B   = [0; 0];               % Matriz de Controlabilidade    ([] = Homog�nea)
C   = [1 0];                % Matriz de Observabilidade
D   = 0;                    %                               ([] = Homog�nea)



%%  M�todo 0: Fun��o Matlab
%%============================================================================

syms t
eA  = expm(A*t);    % Exponencial de Matrizes (resultado de controle)

%   Note que o comando expm(A) � diferente de exp(A). 
%       exp(A)  realiza a exponencial natural de cada entrada da matriz;
%       expm(A) realiza a exponencial natural matricial da matriz;


XC  = eA * X0;    % M�todo Controle
YC  = C  * XC;



%%  M�todo 1: Autovalores e Autovetores
%%============================================================================

n   = length(A);           % Size of Matrix

% M = size(X,DIM) returns the length of the dimension specified
%   by the scalar DIM.  For example, size(X,1) returns the number
%   of rows. If DIM > NDIMS(X), M will be 1.

% length(X) returns the length of vector X.  It is equivalent
%   to MAX(SIZE(X)) for non-empty arrays and 0 for empty ones.

%   Note tamb�m que expm(A) poder� ser calculado atrav�s dos Autovalores e
%   Autovetores de A como ilustrado abaixo:


[V,D]= eig(A);

% [V,D] = eig(A) produces a diagonal matrix D of eigenvalues and 
%   a full matrix V whose columns are the corresponding eigenvectors  
%   so that A*V = V*D.


AA  = V*D*inv(V);   % Matriz de Coeficientes

% inv(X) is the inverse of the square matrix X.
%   A warning message is printed if X is badly scaled or
%   nearly singular.

%   Note que haver� uma parcela complexa aproximadamente nula gerada por
%   arredondamentos num�ricos.


eAA = V*diag(exp(diag(D)))*inv(V);  % Exponencial Matricial

% diag(V,K) when V is a vector with N components is a square matrix
%   of order N+ABS(K) with the elements of V on the K-th diagonal. K = 0
%   is the main diagonal, K > 0 is above the main diagonal and K < 0
%   is below the main diagonal.


syms t
eAAt= V*diag(exp(diag(D*t)))*inv(V); % Fun��o Exponencial Matricial

XA  = eAAt * X0;   % M�todo de Autovalores
YA  = C    * XA;

%   Solu��o anal�tica atrav�s da interpreta��o simb�lica da equa��o.



%%  M�todo 2: Inversa de Laplace
%%============================================================================

%   Note tamb�m que expm(A) poder� ser calculado atrav�s da Inversa de 
%   Laplace como ilustrado abaixo:

syms s
I   = eye(n);                           % Matriz Identidade

% eye(N) is the N-by-N identity matrix.

eALt= ilaplace( inv( s*I - A ));        % Fun��o Exponencial Matricial

% F = ilaplace(L) is the inverse Laplace transform of the sym L
%   with default independent variable s.  The default return is a
%   function of t.  If L = L(t), then ilaplace returns a function of x:
%   F = F(x).

XL  = eALt * X0;    % M�todo de Laplace
YL  = C    * XL;



%%  M�todo 3: Polinomial (Cayley-Hamilton)
%%============================================================================

%   syms x y
%   p   = x^3 - x*y^2 + 1;
%   d   = x + y;

% [R,Q] = polynomialReduce(P,D) also produces the vector Q of
%   polynomials satisfying P = sum(Q.*D) + R.

%   Note tamb�m que expm(A) poder� ser calculado atrav�s de express�es
%   Polinomiais como ilustrado abaixo:


[V,D]= eig(A);

L   = diag(D);              % Vetor de Autovalores
VM  = fliplr(vander(L));    % Matriz de Vandermonde
VMi = inv(VM);

% Y = fliplr(X) returns X with the order of elements flipped left to right
%   along the second dimension

% A = vander(V), for a vector of length n, returns the n-by-n
%   Vandermonde matrix A. The columns of A are powers of the vector V,
%   such that the j-th column is A(:,j) = V(:).^(n-j)


syms t
ED  = sym(zeros(length(A),1));

for i=1:n
    % 1: Start of Array
    % n: End   of Array as the Size of A

    ED(i) = exp(L(i)*t);    % Creates a Vector of Functions
end

AL  = VMi*ED;


eAPt= 0;
for i=1:n
    % 1: Start of Array
    % n: End   of Array as the Size of A

    eAPt = eAPt + AL(i)*A^(i-1);

    % A^a: Computes the matrix A to the power of a
end

XP  = eAPt * X0;    % M�todo Polinomial
YP  = C    * XP;



%%  Compara��o M�todos
%%============================================================================

%   Compara-se os m�todos para avaliar sua consist�ncia.

t   = 0:0.01:2;
YCV = eval(YC);
YAV = eval(YA);
YLV = eval(YL);
YPV = eval(YP);

% eval(EXPRESSION) evaluates the MATLAB code in EXPRESSION. Specify
%   EXPRESSION as a character vector or string scalar.


figure
plot(t, YCV, t, YAV, 's', t, YLV, '+', t, YPV, 'o')
title('Compara��o M�todos')
xlabel('t [s]')
ylabel('y(t)')
legend("Controle", "Autovalores", "Laplace", "Polinomial", "location", "southeast")


fprintf('Compara��o com expm(At):\n');
disp(['Erro M�todo Autovalores: ' num2str(abs(mean(YAV-YCV)))]);
disp(['Erro M�todo Laplace:     ' num2str(abs(mean(YLV-YCV)))]);
disp(['Erro M�todo Polinomial:  ' num2str(abs(mean(YPV-YCV)))]);



%%  Refer�ncias
%   https://www.mathworks.com/help/matlab/math/matrix-exponentials.html
%   https://www.mathworks.com/matlabcentral/answers/116593-how-to-display-a-string-and-matrix-in-matlab
%   https://web.mit.edu/2.151/www/Handouts/CayleyHamilton.pdf
%   https://www.mathworks.com/help/matlab/ref/mpower.html
%   https://www.mathworks.com/help/matlab/creating_plots/specify-line-and-marker-appearance-in-plots.html
%   https://www.mathworks.com/help/matlab/ref/matlab.graphics.illustration.legend-properties.html