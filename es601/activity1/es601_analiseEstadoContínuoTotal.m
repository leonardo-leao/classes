%%                    Main Code
%%============================================================================

clc
% clear all
close all

RA = 217276;


%%  Exerc�cio de Representa��o de Estados
%%============================================================================

%   Considera-se um sistema de Segunda Ordem com a seguinte equa��o
%   caracter�stica:

%    ddy + (2*qsi*wn)dy + (wn**2)y = (wn**2)*u(t)

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

%   Desta forma, define-se as seguintes vari�veis:

wn  = 100;  % Frequ�ncia Natural do Sistema
qsi = 0.05; % Amortecimento      do Sistema

X0  = [10;  % Valores  = [1;  Espa�o
        0]; % Iniciais    0]  Velocidade
    
%   Realizando as substitui��es adequadas, considerando que as vari�veis
%   auxiliares foram o Espa�o e a Velocidade, obt�m-se as seguintes
%   matrizes:

A0  = [0 1; (-wn^2) (-2*qsi*wn)];   % Matriz de Transi��o de Estado
B0  = [0; (wn^2)];                  % Matriz de Controlabilidade
C0  = [1 0];                        % Matriz de Observabilidade
D0  = 0;

%   Al�m disso, considera-se que o intervalo de an�lise ser� definido pelas
%   seguintes vari�veis:

tint = 1;       %   In�cio da An�lise
tstp = 0.001;   %   Passo  da An�lise

%   Considera-se tamb�m que a entrada ser� definida pelas seguintes
%   vari�veis:

u    = 1;       % Amplitude    da Entrada (u(t) = 0, Homog�neo)
t0   = 0;       % Deslocamento da Entrada 


%%  M�todo 0: Fun��o Matlab (M�todo de Controle)
%%============================================================================

%   Considera-se que a fun��o "expm(A)" ser� o Benchmark dessa an�lise.

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



%%  Visualiza��o dos M�todos
%%============================================================================

%   Cada m�todo ser� graficamente comparado com base ao M�todo de Controle
%   estabelecido. Inicialmente define-se o intervalo de an�lise como:

tmin    = 0+t0;
tmax    = tmin+tint;
t       = tmin : tstp : tmax;

%   Na sequ�ncia ser� necess�rio avaliar cada express�o anal�tica obtida
%   atrav�s do comando "eval(f)".

YCLt    = real(eval(YCL));              % Y Controle    Livre   em t
YALt    = real(eval(YAL));              % Y Autovalores Livre   em t
YLLt    = real(eval(YLL));              % Y Laplace     Livre   em t
YPLt    = real(eval(YPL));              % Y Polinomial  Livre   em t

YCFt    = real(eval(YCF));              % Y Controle    For�ada em t
YAFt    = real(eval(YAF));              % Y Autovalores For�ada em t
YLFt    = real(eval(YLF));              % Y Laplace     For�ada em t
YPFt    = real(eval(YPF));              % Y Polinomial  For�ada em t

YCTt    = YCLt + YCFt;                  % Y Controle    Total   em t
YATt    = YALt + YAFt;                  % Y Autovalores Total   em t
YLTt    = YLLt + YLFt;                  % Y Laplace     Total   em t
YPTt    = YPLt + YPFt;                  % Y Polinomial  Total   em t

%   Note que apenas os valores reais ser�o considerados atrav�s do comando
%   "real(f)" para evitar warnings desnecess�rios.
%
%   Durante a solu��o num�rica haver� algum lixo num�rico complexo
%   indesejado na ordem de 10^(-15).

fpath = 'C:\Users\Admin-PC\OneDrive\UNICAMP\classes\es601\images';
fsize = [0 0 18 6];

%   Resposta Livre_________________________________________________________
figure; plot(t, YCLt, t, YALt, 's', t, YLLt, '+', t, YPLt, 'o')
title('Resultado Livre');       xlabel('t [s]'); ylabel('y(t)')
legend("Controle", "Autovalores", "Laplace", "Polinomial", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fpath, 'es601_ex6_RLAnalitico'), 'png');

%   Resposta For�ada_______________________________________________________
figure; plot(t, YCFt, t, YAFt, 's', t, YLFt, '+', t, YPFt, 'o')
title('Resultado For�ado');     xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Autovalores", "Laplace", "Polinomial", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fpath, 'es601_ex6_RFAnalitico'), 'png');

%   Resposta Total_________________________________________________________
figure; plot(t, YCTt, t, YATt, 's', t, YLTt, '+', t, YPTt, 'o')
title('Resultado Total');       xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Autovalores", "Laplace", "Polinomial", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fpath, 'es601_ex6_RTAnalitico'), 'png');



%%  Visualiza��o Simulink
%%============================================================================

%   Separou-se a an�lise do Simulink para que os gr�ficos n�o apresentassem
%   polui��o visual.
%
%   Espera-se que tanto as solu��o anal�ticas quanto simuladas convirgam na
%   M�todo de Controle, por isso apenas este ser� incluido como refer�ncia.

%   Resposta Livre_________________________________________________________
figure; plot(t, YCLt, out.tout, out.simL, 'o')
title('Resultado Livre Simulink');    xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Simulink", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fpath, 'es601_ex6_RLSimulink'), 'png');

%   Resposta For�ada_______________________________________________________
figure; plot(t, YCFt, out.tout, out.simF, 'o')
title('Resultado For�ado Simulink');    xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Simulink", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fpath, 'es601_ex6_RFSimulink'), 'png');

%   Resposta Total_________________________________________________________
figure; plot(t, YCTt, out.tout, out.simT, 'o')
title('Resultado Total Simulink');      xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Simulink", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fpath, 'es601_ex6_RTSimulink'), 'png');



%%  Compara��o M�todos
%%============================================================================

%   Deseja-se avaliar se os m�todos anal�ticos utilizados s�o confi�veis ou
%   n�o. Assim, al�m da ferramenta visual, determina-se o erro m�dio de
%   cada m�todo em compara��o ao M�todo de Controle.

fprintf('AN�LISE SIMB�LICA_____________________________________________\n');
const_test = 'Resultado Diverge';z
if qsi*wn>0
    const_test = 'Resultado Converge';
end
disp(['qsi*wn > 0: ' const_test]);


fprintf('\n\nAN�LISE NUM�RICA______________________________________________\n');
fprintf('Resultado Homogeneo       (Livre):\n');
disp(['Erro M�todo Autovalores Livre:   ' num2str(abs(mean(YALt-YCLt)))]);
disp(['Erro M�todo Laplace     Livre:   ' num2str(abs(mean(YLLt-YCLt)))]);
disp(['Erro M�todo Polinomial  Livre:   ' num2str(abs(mean(YPLt-YCLt)))]);
disp(['Erro M�todo Simulink    Livre:   ' num2str(abs(mean(out.simL'-YCLt)))]);

fprintf('\nResultado Particular    (For�ado):\n');
disp(['Erro M�todo Autovalores For�ado: ' num2str(abs(mean(YAFt-YCFt)))]);
disp(['Erro M�todo Laplace     For�ado: ' num2str(abs(mean(YLFt-YCFt)))]);
disp(['Erro M�todo Polinomial  Forcado: ' num2str(abs(mean(YPFt-YCFt)))]);
disp(['Erro M�todo Simulink    For�ado: ' num2str(abs(mean(out.simF'-YCFt)))]);

fprintf('\nResultado Total (Livre + For�ado):\n');
disp(['Erro M�todo Autovalores Total:   ' num2str(abs(mean(YATt-YCTt)))]);
disp(['Erro M�todo Laplace     Total:   ' num2str(abs(mean(YLTt-YCTt)))]);
disp(['Erro M�todo Polinomial  Total:   ' num2str(abs(mean(YPTt-YCTt)))]);
disp(['Erro M�todo Simulink    Total:   ' num2str(abs(mean(out.simT'-YCTt)))]);