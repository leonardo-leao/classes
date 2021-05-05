import numpy as np

# parte 1 e 2
if(False):
    aux = [25,13,25,26,27,10,23,16,15,2,8] #base de dados inicial
    end = [] #base de dados final
    mul = 1 #multiplicador para os valores

    #multiplica valores do aux, usado para calcular os valores quando a base é modificada por uma multiplicação
    for i in range(len(aux)):
        end.append(aux[i]*mul)

    #caso hajam valores estes deve ser incluidos na tabela de frequência, do contrário será necessário modificar a variável
    val = np.array(end)
    freq = np.array([1,1,1,1,1,1,1,1,1,1,1])
    data = np.repeat(val, freq)

    print(data)
    print("soma", np.sum(data))
    print("média", data.mean())
    print("mediana",np.median(data))
    print("desvio padrão ",np.std(data, ddof=1))


# parte 3 e 4
if(False):
    val = np.array([20.35, 26.75, 23.2, 20.3])
    freq = np.array([16, 9, 6, 8])
    data = np.repeat(val, freq)

    # data = np.array([5, 14, 23, 27, 27, 19, 12, 18, 8, 11, 30, 10, 15])
    data = np.array(
        [
            2.26, 1.8, 2.5, 1.12, 2.76, 2.64, 1.47,
            1.25, 2.11, 1.94, 1.25, 1.83, 2.89, 1.66
        ]
    )
    data.sort()

    # Q1, Q2, Q3 = np.quantile(data, [0.25, 0.5, 0.75]) # Método diferente do implementado pela professora? o que está acontecendo aqui?


    #quartis
    meio = int(data.size/2)
    l1 = data[:meio]
    l2 = data[-meio:]
    # l1, l2 = np.split(data, 2)
    print(l1)
    print(l2)
    Q1 = np.median(l1)
    Q2 = np.median(data)
    Q3 = np.median(l2)
    IQ = Q3-Q1
    Lim_inf = Q1 - 1.5*IQ
    Lim_sup = Q3 + 1.5*IQ
    t = data[np.where(data > Lim_inf)]
    lim_inf_box = t[0]
    t = data[np.where(data < Lim_sup)]
    lim_sup_box = t[-1]


    print(data)
    print("soma", np.sum(data))
    print("média", data.mean())
    print("mediana", np.median(data))
    print("desvio padrão ", np.std(data, ddof=1))
    print("Q1: {:.2f}".format(Q1))
    print("Q2: {:.2f}".format(Q2))
    print("Q3: {:.2f}".format(Q3))
    print("IQ: {:.2f}".format(IQ))
    print("Limite inferior teorico: {:.2f}".format(Lim_inf))
    print("Limite superior teorico: {:.2f}".format(Lim_sup))
    print("Limite inferior real: {:.2f}".format(lim_inf_box))
    print("Limite superior real: {:.2f}".format(lim_sup_box))

    #dados
    x = np.array([0.63,1.83,0.13,0.21,-1.30,-0.26,0.77,2.79,-1.13,0.60,-0.63,-0.03,0.43 ,0.12,0.03,-1.39,-0.68,0.20])
    y = np.array([0.78,1.97,0.34,0.30,-0.12,-0.04,0.49,1.43,-1.63,0.33,-0.63,0.01 ,-0.47,0.03,1.17,-2.44,-1.08,0.77])

    #coeficiente de correlação
    def ccxy(x, y):
        if(x.size != y.size):
            return 2

        n = x.size

        xm = x.mean()
        ym = y.mean()

        sx = np.std(x, ddof=1)
        sy = np.std(y, ddof=1)

        zx = (x - xm)/sx
        zy = (y - ym)/sy

        ccxy = np.sum(zx*zy)/(n-1)

        return ccxy


    print("média x: {:.2f}".format(x.mean()))
    print("média y: {:.2f}".format(y.mean()))
    print("desvio padrão x: {:.2f}".format(np.std(x, ddof=1)))
    print("desvio padrão y: {:.2f}".format(np.std(y, ddof=1)))
    print("coeficiente de correlação: {:.2f}".format(ccxy(x,y)))

#parte 5 a 8
if(False):
    # 6: 1 2 3 4 5 6, 6
    # 5: 2 3 4 5 6,   5
    # 4: 3 4 5 6,     4
    # 3: 4 5 6,       3
    # 2: 5 6          2
    # 1: 6            1 -> 21/36

    # soma <= 11
    # 6: 1 2 3 4 5
    # 5: 1 2 3 4 5 6
    # 4: 1 2 3 4 5 6
    # 3: 1 2 3 4 5 6
    # 2: 1 2 3 4 5 6
    # 1: 1 2 3 4 5 6

    aIb   = 0.4958
    acIb  = 0.2442
    aIbc  = 0.1742
    acIbc = 0.0858

    a = aIb + aIbc
    b = aIb + acIb
    aUb = aIbc + aIb + acIb
    
    acUb = 1 - a + aIb
    aUbc = 1 - b + aIb
    acUbc = 1 - aIb

    ba = aIb/a
    acbc = acIbc/(1-b)
 
    acb = acIb/b
    bca = aIbc/a
    bac = acIb/(1-a)

    print("P(A):       {:.2f}".format(a))
    print("P(B):       {:.2f}".format(b))
    print("P(A  U B):  {:.4f}".format(aUb))
    print("P(Ac U B):  {:.4f}".format(acUb))
    print("P(A  U Bc): {:.4f}".format(aUbc))
    print("P(Ac U Bc): {:.4f}".format(acUbc))
    print("P(B  | A):  {:.2f}".format(ba))
    print("P(Ac | Bc): {:.2f}".format(acbc))
    print("P(Ac | B):  {:.2f}".format(acb))
    print("P(Bc | A):  {:.2f}".format(bca))
    print("P(B  | Ac): {:.2f}".format(bac))

#partes 9 à 11
if(True):
    #==========================
    #expectedValue and variance
    print("="*35)
    values = np.array([0, 49, 62])
    weight = np.array([0.48, 0.45, 0.07])

    expectedValue = np.sum(values*weight)
    varianceValue = np.sum((values*values)*weight) - expectedValue**2

    #function: Y = aX + b, when necessary
    a = 1
    b = 0
    expectedValueY    = a*expectedValue + b
    varianceValueY    = (a**2)*varianceValue
    standardDeviation = varianceValueY**(1/2)

    print("esperança: {:.4f}".format(expectedValueY))
    print("variância: {:.4f}".format(varianceValueY))
    print("desvio padrão: {:.4f}".format(standardDeviation))

    #======================
    #combine expected value
    print("\n"+"="*35)
    x1 = 2.38
    x2 = 17.3
    a1 = -6
    a2 = -18

    expectedValueR = a1*x1 + a2*x2
    varianceValueR = (a1**2)*x1 + (a2**2)*x2

    print("esperança resultante: {:.4f}".format(expectedValueR))
    print("variância resultante: {:.4f}".format(varianceValueR))

    #===============
    #square variable
    print("\n"+"="*35)
    expectedValue = -20
    varianceValue = 13.2

    #V(X) = E(X^2) - (E(X))^2
    expectedValue2 = varianceValue + expectedValue**2
    expectedValue2 = 417.3 #comment this line when variance is given
    varianceValue = expectedValue2 - expectedValue**2

    print("esperança quadrado: {:.4f}".format(expectedValue2))
    print("variância: {:.4f}".format(varianceValue))

    #===========
    #air company
    print("\n"+"="*35)
    passageiros = 104
    mala1 = 44
    mala2 = mala1 + 55

    X = np.array([0, 1, 2])
    values = np.array([0, mala1, mala2])
    weight = np.array([0.35, 0.33, 0.32])

    expectedX = np.sum(X*weight)
    expectedValue = np.sum(values*weight)
    varianceValue = np.sum((values*values)*weight) - expectedValue**2
    standardDeviation = varianceValue**(1/2)

    print("esperança mala passageiro: {:.4f}".format(expectedX))
    print("esperança mala total: {:.4f}".format(expectedX*passageiros))
    print("esperança ganho passageiro: {:.4f}".format(expectedValue))
    print("esperança ganho total: {:.4f}".format(expectedValue*passageiros))
    print("desvio padrão ganho passageiro: {:.4f}".format(standardDeviation))
    print("desvio padrão ganho total: {:.4f}".format(standardDeviation*(passageiros)**(1/2)))

    #===================
    #distribution models
    print("\n"+"="*35)

    def Combination(n, k):
        #n: number of objects
        #k: number of groups

        if n<k:
            return 0

        fatorialN = np.math.factorial(n)
        fatorialK = np.math.factorial(k)
        fatorialNK = np.math.factorial(n-k)

        cnk = fatorialN/(fatorialK*fatorialNK)

        return cnk

    def Bernoulli(x, n, p):
        #x: = 1, sucess
        #   = 0, fail
        #p: probability of sucess
        #n: number of trials

        px = (p**(x))*((1-p)**(n-x))

        return px

    def Geometric(x, p):
        #x: number of trials to sucess
        #p: probability of sucess

        px = p*(1-p)**(x-1)
        pxl = 0
        for i in range(1,x):
            pxl += p*(1-p)**(i-1)

        print("\nGeometric Distribution")
        print("p   = {:.4f}".format(p))
        print("1/p = {:.4f}".format(1/p))
        print("P(X ={}) = {:.4f}".format(x, px))
        print("P(X<={}) = {:.4f}".format(x, px+pxl))
        print("P(X>={}) = {:.4f}".format(x, 1-pxl))
        print("P(X< {}) = {:.4f}".format(x, pxl))
        print("P(X> {}) = {:.4f}".format(x, 1-px-pxl))

        return px

    def Binomial(x, n, p):
        #x: number of sucesses
        #n: number of trials
        #n: probability of sucess
        cnx = Combination(n, x)

        pxg = 0
        pxl = 0
        px = cnx*Bernoulli(x, n, p)

        for i in range(n+1):
            cni = Combination(n, i)
            if(i > x):
                pxg += cni*Bernoulli(i, n, p)
            if(i < x):
                pxl += cni*Bernoulli(i, n, p)

        print("\nBinomal Distribution")
        print("p = {:.4f}".format(p))
        print("n = {:.4f}".format(n))
        print("P(X ={}) = {:.4f}".format(x, px))
        print("P(X<={}) = {:.4f}".format(x, px+pxl))
        print("P(X>={}) = {:.4f}".format(x, px+pxg))
        print("P(X< {}) = {:.4f}".format(x, pxl))
        print("P(X> {}) = {:.4f}".format(x, pxg))

        return px

    b = Binomial(5, 9, 0.53)
    g = Geometric(14, 1/9)