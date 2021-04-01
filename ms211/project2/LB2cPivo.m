N = 4; %tamanho da matriz de entrada
tic(); %inicio da contagem do tempo
for i = 1:10 %repeti��es do algoritmo
  %A = randn(N);
  xs = ones(N,1);
  %b = A*xs;
  %A = [0.8, -0.2, -0.2, -0.3; -0.2, 0.9, -0.2, -0.3; -0.3, -0.3, 0.8, -0.2; -0.2, -0.2, -0.4, 0.8];
  %b = [0.5; 0.4; 0.3; 0];
  A = [2, 1, 1, 0; 4, 3, 3, 1; 8, 7, 9, 5; 6, 7, 9, 8];
  b = [1; 2; 4; 5];
  
  nrow = ones(N,1); %vetor auxiliar para registrar pivoteamentos
  for i=1: N
    nrow(i)=i;
  end
  
  for k = 1: N-1 %elimina��o de gauss
		max = 0; %valor m�ximo
    index = 0; %indice
    
    for j=k: N %percorre a matriz para encontrar o valor m�ximo
      if abs(A(nrow(j),k))>max
        max = abs(A(nrow(j),k)); %armazena o valor m�ximo em m�dulo
        index=j; %armazena o indice do valor m�ximo 
      end
    end
    
    if nrow(k)~=nrow(index) %caso n�o seja o valor m�ximo
      ncopy = nrow(k); %salva uma copia
      nrow(k) = nrow(index); %troca as linhas
      nrow(index) = ncopy; %troca as linhas
    end
    
    for i = k+1: N %percorre a matriz
			m(nrow(i),k) = A(nrow(i),k)./A(nrow(k),k); %obtem o multiplicador
      b(nrow(i),1) = (b(nrow(i),1) - (m(nrow(i),k).*b(nrow(k),1))); %realiza a subtra��o no vetor de vari�veis
			for j = k: N
				A(nrow(i),j) = (A(nrow(i),j)-(m(nrow(i),k).*A(nrow(k),j))); %realiza a subtra��o na matriz
      end
		end
	end

  xt = zeros(N,1); xt(nrow(N),1) = b(nrow(N),1)./A(nrow(N),N); %inicializa o vetor resposta
  for i=N-1:-1:1
    xt(nrow(i),1) = (b(nrow(i))-A(nrow(i),i+1:N)*xt(i+1:N))./A(nrow(i),i); %substitui��o reversa
  end
  
  E_r(i,1) = norm(xs-xt,inf)/norm(xs,inf); %registra o erro relativo
  R_r(i,1) = norm(b-A*xt,inf)/norm(b,inf); %registra o residuo relativo
endfor
  %A
  %b
  xt
  %nrow

[mean(E_r),mean(R_r)]; %retorna m�dia do erro e residuo
toc(); %finaliza a contagem de tempo
ans