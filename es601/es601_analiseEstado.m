%%============================================================================
%%                    Main Code
%%============================================================================
clc
clear all
close all

RA = 217276;


%%  An�lise de Estados Primeira Ordem
%%============================================================================

%   Sistema de Primeira Ordem descrito pela seguinte Equa��o:
%   t*dy(t) + y(t) = g*u(t) [1]

%   Forma Padr�o em Estados
%   | dx(t) = a*x(t) + b*u(t) [2]
%   |  y(y) = c*x(t) + d*u(t) [3]

%   Toma-se a rela��o x(t) = y(t) [4], logo as equa��es se simplificam
%   para:
%   [4] em [1]: a = -(1/t); b = (g/t);
%   [4] em [3]: c = 1;      d = 0;



%%  An�lise de Estados Segunda Ordem
%%============================================================================

%   Sistema de Segunda Ordem descrito pela seguinte Equa��o:
%   m*ddy(t) + c*dy(t) + k*y(t) = a*u(t) [1]

%   Observa��o: Considera-se que as vari�veis mai�sculas ser�o vetores.

%   Forma Padr�o em Estados
%   | dX(t) = A*X(t) + B*u(t) [2]
%   |  Y(y) = C*X(t) + D*u(t) [3]



%   Exemplo de Aplica��o considerando um Sistema Massa-Mola-Amortecedor:

m   = 1;    % Massa
k   = 100;  % Constante El�stica
c   = 10;   % Constante de Amortecimento

X0  = [1; 0];   % Valores Iniciais de X(t)
U   = 0;        % Entrada do Sistema (0 = Homog�nea)

A   = [0 1; (-k/m) (-c/m)]; % Matriz de Transi��o de Estado
B   = [ ];                  % ([] = Homog�nea)
C   = [1 0];                %
D   = [ ];                  % ([] = Homog�nea)

