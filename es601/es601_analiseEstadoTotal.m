%%============================================================================
%%                    Main Code
%%============================================================================
clc
% clear all
close all

RA = 217276;


%%============================================================================
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
%       x: n x 1  A: n x n  B: n x r
%       y: p x 1  C: p x n  D: p x r
%       u: r x 1

%   Considera-se que o sistema de estados dever� apresentar as seguintes
%   dimens�es neste caso:
%       x: 2 x 1  A: 2 x 2  B: 2 x 1    visto que   n = 2
%       y: 1 x 1  C: 1 x 2  D: 1 x 1                p = 1
%       u: 1 x 1                                    r = 1

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

xint = 1;       %   In�cio da An�lise
xstp = 0.001;   %   Passo  da An�lise

%   Considera-se tamb�m que a entrada ser� definida pelas seguintes
%   vari�veis:

u    = 1;       % Amplitude    da Entrada (u(t) = 0, Homog�neo)
x0   = 0;       % Deslocamento da Entrada 


%%  M�todo 0: Fun��o Matlab (M�todo de Controle)
%%============================================================================

%   Considera-se que a fun��o "expm(A)" ser� o Benchmark dessa an�lise.

%   Resposta Livre_________________________________________________________
syms x
eA  = expm(A0*(x-x0));

XCL = eA * X0;                          % X Controle Livre
YCL = C0 * XCL;                         % Y Controle Livre

%   Resposta For�ada_______________________________________________________
syms x t
eAPF = expm(A0*(x-t))*B0*u;

XCF = int(   eAPF, t, [x0 x]);           % X Controle For�ado
YCF = int(C0*eAPF, t, [x0 x]) + D0*u;    % Y Controle For�ado

%   Note que todas as respostas for�adas realizaram essa integral simb�lica
%   com rela��o a "t" entre "x" e "x0" como descrito na literatura.



%%  M�todo 1: Autovalores e Autovetores
%%============================================================================

[AVE,AVA]= eig(A0);                     % matriz de AutoVEetores
                                        % vetor  de AutoVAlores
%   Resposta Livre_________________________________________________________
syms x
eAAx= AVE*diag(exp(diag(AVA*(x-x0))))/AVE;

XAL = eAAx * X0;                        % X Autovalores Livre
YAL = C0   * XAL;                       % Y Autovalores Livre

%   Resposta For�ada_______________________________________________________
syms x t
eAPF = AVE*diag(exp(diag(AVA*(x-t))))/AVE*B0*u;

XAF = int(   eAPF, t, [x0 x]);           % X Autovalores For�ado
YAF = int(C0*eAPF, t, [x0 x]) + D0*u;    % Y Autovalores For�ado

%   Note que ao inv�s da utiliza��o do comando "inv(A)" para inverter a
%   matriz analisada utilizou-se "/", ou "\" em certos cen�rios, por sua
%   maior efici�ncia computacional.



%%  M�todo 2: Inversa de Laplace
%%============================================================================

I   = eye(length(A0));                  % Matriz Identidade

%   Resposta Livre_________________________________________________________
syms s x
eALx= ilaplace( inv( s*I - A0 ), (x-x0));

XLL = eALx * X0;                        % X Laplace Livre
YLL = C0   * XLL;                       % Y Laplace Livre

%   Resposta For�ada_______________________________________________________
syms x t
eAPF = ilaplace( inv( s*I - A0 ), (x-t))*B0*u;

XLF = int(   eAPF, t, [x0 x]);          % X Laplace For�ado
YLF = int(C0*eAPF, t, [x0 x]) + D0*u;   % Y Laplace For�ado




%%  M�todo 3: Polinomial (Cayley-Hamilton)
%%============================================================================

AVA = eig(A0);                          % vetor de AutoVAalores
VM  = fliplr(vander(AVA));              % matriz de VanderMonde

%   Note que o comando "fliplr(A)" deve ser aplicado para que a matriz de
%   Vandermonde esteja de acordo com a defini��o da literatura.

%   Resposta Livre_________________________________________________________
EDL = sym(zeros(length(A0),1));
syms x
for i=1:length(A0)
    EDL(i) = exp(AVA(i)*(x-x0));        % Exponenciais de Autovalores
end
APL = VM\EDL;                           % Coeficientes Alpha's

eAPLx    = 0;
for i=1:length(A0)
    eAPLx = eAPLx + APL(i)*A0^(i-1);    % Somat�rio dos Polin�mios
end

XPL = eAPLx * X0;                       % X Polinomial Livre
YPL = C0    * XPL;                      % Y Polinomial Livre

%   Resposta For�ada_______________________________________________________
EDF = sym(zeros(length(A0),1));
syms x t
for i=1:length(A0)
    EDF(i) = exp(AVA(i)*(x-t));
end
APF = VM\EDF; 

eAPFx    = 0;
for i=1:length(A0)
    eAPFx = eAPFx + APF(i)*A0^(i-1);
end

syms x t
eAPF = eAPFx*B0*u;

XPF =    int(eAPF, t, [x0 x]);          % X Polinomial For�ado
YPF = C0*int(eAPF, t, [x0 x]) + D0*u;   % X Polinomial For�ado



%%============================================================================
%%  Visualiza��o dos M�todos
%%============================================================================

%   Cada m�todo ser� graficamente comparado com base ao M�todo de Controle
%   estabelecido. Inicialmente define-se o intervalo de an�lise como:

xmin    = 0+x0;
xmax    = xmin+xint;
x       = xmin : xstp : xmax;

%   Na sequ�ncia ser� necess�rio avaliar cada express�o anal�tica obtida
%   atrav�s do comando "eval(f)".

YCLx    = real(eval(YCL));              % Y Controle    Livre   em x
YALx    = real(eval(YAL));              % Y Autovalores Livre   em x
YLLx    = real(eval(YLL));              % Y Laplace     Livre   em x
YPLx    = real(eval(YPL));              % Y Polinomial  Livre   em x

YCFx    = real(eval(YCF));              % Y Controle    For�ada em x
YAFx    = real(eval(YAF));              % Y Autovalores For�ada em x
YLFx    = real(eval(YLF));              % Y Laplace     For�ada em x
YPFx    = real(eval(YPF));              % Y Polinomial  For�ada em x

YCTx    = YCLx + YCFx;                  % Y Controle    Total   em x
YATx    = YALx + YAFx;                  % Y Autovalores Total   em x
YLTx    = YLLx + YLFx;                  % Y Laplace     Total   em x
YPTx    = YPLx + YPFx;                  % Y Polinomial  Total   em x

%   Note que apenas os valores reais ser�o considerados atrav�s do comando
%   "real(f)" para evitar warnings desnecess�rios.
%
%   Durante a solu��o num�rica haver� algum lixo num�rico complexo
%   indesejado na ordem de 10^(-15).

fname = 'C:\Users\Admin-PC\OneDrive\UNICAMP\classes\es601\images';
fsize = [0 0 18 6];

%   Resposta Livre_________________________________________________________
figure; plot(x, YCLx, x, YALx, 's', x, YLLx, '+', x, YPLx, 'o')
title('Resultado Livre');       xlabel('t [s]'); ylabel('y(t)')
legend("Controle", "Autovalores", "Laplace", "Polinomial", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RLAnalitico'), 'png');

%   Resposta For�ada_______________________________________________________
figure; plot(x, YCFx, x, YAFx, 's', x, YLFx, '+', x, YPFx, 'o')
title('Resultado For�ado');     xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Autovalores", "Laplace", "Polinomial", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RFAnalitico'), 'png');

%   Resposta Total_________________________________________________________
figure; plot(x, YCTx, x, YATx, 's', x, YLTx, '+', x, YPTx, 'o')
title('Resultado Total');       xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Autovalores", "Laplace", "Polinomial", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RTAnalitico'), 'png');



%%  Visualiza��o Simulink
%%============================================================================

%   Separou-se a an�lise do Simulink para que os gr�ficos n�o apresentassem
%   polui��o visual.
%
%   Espera-se que tanto as solu��o anal�ticas quanto simuladas convirgam na
%   M�todo de Controle, por isso apenas este ser� incluido como refer�ncia.

%   Resposta Livre_________________________________________________________
figure; plot(x, YCLx, out.tout, out.simL, 'o')
title('Resultado Livre Simulink');    xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Simulink", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RLSimulink'), 'png');

%   Resposta For�ada_______________________________________________________
figure; plot(x, YCFx, out.tout, out.simF, 'o')
title('Resultado For�ado Simulink');    xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Simulink", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RFSimulink'), 'png');

%   Resposta Total_________________________________________________________
figure; plot(x, YCTx, out.tout, out.simT, 'o')
title('Resultado Total Simulink');      xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "Simulink", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RTSimulink'), 'png');



%%  Compara��o M�todos
%%============================================================================

%   Deseja-se avaliar se os m�todos anal�ticos utilizados s�o confi�veis ou
%   n�o. Assim, al�m da ferramenta visual, determina-se o erro m�dio de
%   cada m�todo em compara��o ao M�todo de Controle.

fprintf('Resultado Homogeneo       (Livre):\n');
disp(['Erro M�todo Autovalores Livre:   ' num2str(abs(mean(YALx-YCLx)))]);
disp(['Erro M�todo Laplace     Livre:   ' num2str(abs(mean(YLLx-YCLx)))]);
disp(['Erro M�todo Polinomial  Livre:   ' num2str(abs(mean(YPLx-YCLx)))]);

fprintf('\nResultado Particular    (For�ado):\n');
disp(['Erro M�todo Autovalores For�ado: ' num2str(abs(mean(YAFx-YCFx)))]);
disp(['Erro M�todo Laplace     For�ado: ' num2str(abs(mean(YLFx-YCFx)))]);
disp(['Erro M�todo Polinomial  Forcado: ' num2str(abs(mean(YPFx-YCFx)))]);

fprintf('\nResultado Total (Livre + For�ado):\n');
disp(['Erro M�todo Autovalores Total:   ' num2str(abs(mean(YATx-YCTx)))]);
disp(['Erro M�todo Laplace     Total:   ' num2str(abs(mean(YLTx-YCTx)))]);
disp(['Erro M�todo Polinomial  Total:   ' num2str(abs(mean(YPTx-YCTx)))]);



%%============================================================================
%%  Exerc�cio de Representa��o de Estados
%%============================================================================

%   Al�m dos m�todos anal�ticos e do Simulink h� fun��es prontas do Matlab
%   capazes de lidar com sistemas de estados e transform�-los em equa��es
%   de transfer�ncia.

[b,a]           = ss2tf(A0, B0, C0, D0, 1);     % Fun��o de Transfer�ncia
[A1,B1,C1,D1]   = tf2ss(b, a);

%   Nota-se que as matrizes A1, B1, C1 e D1 s�o diferentes das matrizes
%   originais do sistema desta forma ser� necess�rio compar�-los:

sys0    = ss(A0,B0,C0,D0);  % Sistema de Estados Original
sys1    = ss(A1,B1,C1,D1);  % Sistema de Estados Distinto

%   Resposta Livre_________________________________________________________
inputL  = zeros(size(x));   % Entrada Nula
X1      = [0 X0(1)/wn^2]';

YLS0L   = real(lsim(sys0, inputL, x, X0));  % Y LSim em sys0 (Livre)
YLS1L   = real(lsim(sys1, inputL, x, X1));  % Y LSim em sys1 (Livre)

YIN0L   = initial(sys0, X0, x-x0);          % Y INitial em sys0 (Livre)
YIN1L   = initial(sys1, X0, x-x0);          % Y INitial em sys1 (Livre)
%   Note que a fun��o "initial()" � um caso particular de "lsim()".

%   Resposta For�ada_______________________________________________________
inputF  = u*ones(size(x));  % Entrada Degrau
YLS0F   = real(lsim(sys0, inputF, x));      % Y LSim em sys0 (For�ada)
YLS1F   = real(lsim(sys1, inputF, x));      % Y LSim em sys1 (For�ada)

stepConfig  = stepDataOptions('StepAmplitude', u, 'InputOffset', 0);
YST0F   = step(sys0, x-x0, stepConfig);     % Y STep em sys0 (For�ada)
YST1F   = step(sys1, x-x0, stepConfig);     % Y Setp em sys1 (For�ada)
%   Note que a fun��o "step()" � um caso particular de "lsim()".

%   Resposta Total_________________________________________________________
YLS0T   = real(lsim(sys0, inputF, x, X0));  % Y LSim em sys0 (Total)
YLS1T   = real(lsim(sys1, inputF, x, X0));  % Y LSim em sys1 (Total)



%%  Compara��o Sistemas
%%============================================================================

%   Resposta Livre_________________________________________________________
figure; plot(x, YCFx, x, YLS0F, 's', x, YLS1F, 'x')
title('Resposta For�ada lsim'); xlabel('t [s]');ylabel('y(t)');
legend("Controle", "lsim A0", "lsim A1", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RFlsim'), 'png');

%   Resposta For�ada_______________________________________________________
figure; plot(x, YCLx, x, YLS0L, 's', x, YLS1L, '+')
title('Resposta Livre lsim'); xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "lsim A0", "lsim A1", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RLlsim'), 'png');

%   Resposta Total_________________________________________________________
figure; plot(x, YCTx, x, YLS0T, 's', x, YLS0T, 'x')
title('Resposta Total lsim'); xlabel('t [s]'); ylabel('y(t)');
legend("Controle", "lsim A0", "lsim A1", "location", "southeast")
set(gcf, 'PaperPosition', fsize);
saveas(gca, fullfile(fname, 'es601_ex6_RTlsim'), 'png');



%%============================================================================
%%  Refer�ncia
%%============================================================================

%   https://www.mathworks.com/help/control/ref/ss.html
%   https://www.mathworks.com/help/control/ug/state-space-models.html
%   https://www.mathworks.com/help/matlab/ref/ss2tf.html
%   https://www.mathworks.com/matlabcentral/answers/289914-ss-function-is-undefined
%   https://www.mathworks.com/help/control/ref/lti.lsim.html
%   https://www.youtube.com/watch?v=VuY0nhWjyqc
%   https://www.mathworks.com/matlabcentral/answers/46214-print-to-file-saveas-maintaining-figure-dimensions
%   https://www.mathworks.com/matlabcentral/answers/17580-how-to-define-a-path-in-saveas-command