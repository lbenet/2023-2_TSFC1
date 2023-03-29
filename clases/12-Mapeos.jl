# # Desplazamiento de Bernoulli

using Pkg
Pkg.activate(".")

# ## Desplazamiento de Bernoulli

# El mapeo de desplazamiento (o doblamiento) de Bernoulli, es el mapeo
# definido en $[0,1)\to[0,1]$ dado por
# \begin{equation}
# x_{n+1} = \sigma(x_n) = 2x_n\mod 1.
# \tag{1}
# \end{equation}
# La gráfica de este mapeo es muy sencilla: consiste en las dos rectas
# paralelas de pendiente 2, dadas por $y=2x$ si $x\in [0,0.5)$, y
# $y=2x-1$ si $x\in [0.5,1]$, como se muestra en la gráfica.

using Plots
plot(0:1/32:1/2, x->2*x, linewidth=3, color=:blue, label="y=2x")
plot!(1/2:1/32:1, x->2*x-1, linewidth=3, color=:blue, label="y=2x-1")
plot!(0:1/32:1, x->x, linewidth=1, linestyle=:dash, color=:red, label="y=x")
scatter!([0.5], [0.0], color=:blue,
    markerstrokecolor=:blue, marker=:circle,markersize=3, label="")
scatter!([0.5], [1.0], color=:white,
    markerstrokecolor=:blue, marker=:circle,markersize=3, label=:none)
scatter!([1.0], [1.0], color=:white,
    markerstrokecolor=:blue, marker=:circle,markersize=3, label=:none)

# En este apartado analizaremos la dinámica del mapeo (1), empezando por los puntos de equilibrio (o de periodo 1) del mapeo, y su estabilidad local, y algunas órbitas periódicas y no periódicas. Estudiaremos además su implementación en la computadora.

# ## Puntos de equilibrio y su estabilidad

# De la figura anterior, o al resolver $\sigma(x_n) = x_n$, claramente tenemos que el único punto de equilibrio en $[0,1)$ es $x_*=0$; $x=1$ no es punto fijo ya que no pertenece al dominio de la función. Tomando la derivada del mapeo y evaluándola en $x_*$ obtenemos 2; dado que este valor es mayor que 1, tenemos que $x_*=0$ es linealmente inestable. Este resultado lo podemos también obtener inspeccionando algunos iterados que inician cerca del punto de equilibrio, como se ilustra a continuación.

σ(x) = mod(2*x, 1) # definición del mapeo de Bernoulli

x0 = 1/1024
println("n = ", 0, "   x_n = ", x0)
for n = 1:4
    xn = σ(x0)
    x0 = xn
    println("n = ", n, "   x_n = ", xn)
end

# ## Órbitas periódicas

# Uno puede verificar que el mapeo $\sigma(x)$ tiene muchas órbitas periódicas. Por ejemplo, $\sigma(1/3)=2/3$ y $\sigma(2/3)=1/3$, lo que constituye una órbita de periodo 2. De manera similar $\sigma(1/5) = 2/5$, $\sigma(2/5) = 4/5$, $\sigma(4/5) = 3/5$, $\sigma(3/5)=1/5$ ilustra un ciclo de periodo 4.

# Es fácil obtener una fórmula explícita del mapeo de periodo 2, $\sigma^2(x) = \sigma(\sigma(x))$. Usando la definición, Eq. (1), es fácil obtener
# \begin{equation}
# \sigma^2(x) =
# \begin{cases}
# 4x,  & 0\le x < 1/4,\\
# 4x-1,& 1/4\le x < 1/2,\\
# 4x-2,& 1/2\le x < 3/4,\\
# 4x-3,& 3/4\le x < 1,\\
# \end{cases}
# \tag{2}
# \end{equation}
# que de manera compacta corresponde a $\sigma^2(x)=4x\mod 1$. A partir de $\sigma^2(x)=x$ y usando (2), obtenemos los puntos de periodo 2, que corresponden a 0 (que es el punto fijo) y a $1/3$ y $2/3$. Al igual que para el punto fijo, los puntos de periodo 2 son linealmente inestables.

# Uno puede generalizar fácilmente la Eq. (2) a cualquier periodo $n$, obteniendo $\sigma^n(x) = 2^n x \mod 1$. Claramente, esto involucra considerar al dominio en términos de los $2^n$ intervalos $[r/2^n, (r+1)/2^n)$, con $r=0, \dots,2^n-1$. Más allá de las fórmulas en concreto, vemos que las potencias de 2 jugarán un papel importante.

# ## Ejercicio 1

# a. Obtener, para 10 condiciones iniciales tomadas al azar, los 100 primeros iterados de $\sigma(x)$. A partir de estos resultados, y en función de la condición inicial, determinar el tipo de órbita, esto es, si es un punto fijo, una órbita periódica, una órbita eventualmente periódica, o una órbita sin un patrón fijo. ¿Qué podemos concluir, en términos de los resultados obtenidos, sobre el comportamiento de condiciones iniciales *genéricas*?

# b. Repetir el inciso anterior considerando $x_0=1/5$ y $x_0=1/3$, cuyas órbitas conocemos. ¿Hay algo extraño en los resultados?

for i = 1:10
    x0 = rand()
    xn = x0
    for its = 1:100
        xn = σ(xn)
    end
    println("i = $i\t x0 = $x0 \t x₁₀₀ = $xn")
end

#-

x0 = 1/3
xn = x0
for its = 1:100
    xn = σ(xn)
end
println("x0 = $x0 \t x₁₀₀ = $xn")

x0 = 1/5
xn = x0
for its = 1:100
    xn = σ(xn)
end
println("x0 = $x0 \t \t \t x₁₀₀ = $xn")

# Los resultados numéricos de los dos primeros incisos son raros. Por un lado, casi cualquier condición inicial (ya que la elegimos al azar) *termina* en cero después de muchas iteraciones; esto es contradictorio con la inestabilidad lineal del cero como punto fijo, que calculamos antes. Por otro lado, no se observa la periodicidad que obtuvimos con condiciones lineales específicas, sino que los iterados *terminan* en cero.

# A fin de aclarar los problemas, repetiremos el último inciso del ejercicio usando números racionales.

x0 = 1//3
xn = x0
for its = 1:100
    xn = σ(xn)
end
println("x0 = $x0 \t x₁₀₀ = $xn")

#-

x0 = 1//5
xn = x0
for its = 1:100
    xn = σ(xn)
end
println("x0 = $x0 \t x₁₀₀ = $xn")


# En este caso vemos que los iterados 100 muestran la periodicidad que habíamos obtenido: $\sigma^{100}(1/3)=\sigma^2(1/3)=1/3$, y $\sigma^{100}(1/5)=\sigma^4(1/5) = 1/5$. Esta observación genera la pregunta: ¿cuál de las simulaciones numéricas es correcta? El hecho de que la simulación numérica con racionales de los mismos resultados que los que obtuvimos analíticamente nos debe entonces hacer dudar de los resultados de la primera simulación.

# ## Resultados analíticos

# A continuación haremos una descripción analítica de la dinámica del mapeo de Bernoulli. Como observamos antes, las potencias de 2 son importantes para definir el $n$-ésimo iterado del mapeo. Por esto, en esta sección, usaremos  base 2 para entender la dinámica del mapeo. Así, cualquier condición inicial $x_0\in [0,1)$ la podemos representar, en su desarrollo *binario*, como
# \begin{equation}
# x_0 = 0.a_1 a_2 a_3 \dots a_n \dots,
# \tag{3}
# \end{equation}
# donde, dado que estamos usando base 2, tenemos que $a_k$ es 0 o 1. Por ejemplo, si $x_0 < 1/2$ tendremos que $a_1=0$, y si $x_0 \ge 1/2$ entonces $a_1=1$.

# Ahora explotaremos la representación binaria (3) para entender la dinámica; ésta corresponde a $x_0 = \sum_{k=1} a_k 2^{-k}$. Como explicamos anteriormente, el mapeo (1) equivale a $x_{n+1}=2x_n$ si $x_n\le 1/2$, o $x_{n+1}=2x_n-1$ si $x_n> 1/2$. Entonces, si $a_1=0$ tenemos que $x_1 = 2x_0 = 0.a_2 a_ 3 \dots a_n \dots$, dado que multiplicar por 2, en este caso, resulta en $\sum_{k=2} a_k 2^{-k+1}$. Por otro lado, si $a_1=1$ entonces $x_1 = 2x_0 - 1 = 1.a_2 a_ 3 \dots - 1 = 0.a_2 a_ 3 \dots $, también. Esto es, independientemente del valor de $a_1$, la representación de $x_1$ corresponde a mover *el punto binario* una posición hacia la derecha, y desechar el primer valor. Es por esto que el mapeo de Bernoulli también se conoce como el desplazamiento de Bernoulli.

# Como consecuencia de lo anterior, la representación del $n$-ésimo iterado corresponde a
# \begin{equation}
# x_n = \sigma^n(x_0) = 0.a_{n+1} a_{n+2} \dots.
# \tag{4}
# \end{equation}

# La Eq. (4) nos permite entender la dinámica de manera muy precisa, y también los resultados numéricos. El primer caso que consideraremos es si la representación de $x_0$ corresponde a un número racional cuya representación binaria es *finita*, es decir, que termina con una cola infinita de ceros; en este caso, después de un número $n$ de iterados, obtendremos $x_*=0$, que es el punto de equilibrio, por lo que cualquier número de iterados subsecuente seguirá ahí. El segundo caso es aquél en que $x_0$ es un número racional, pero cuya representación binaria muestra una cola periódica con dos o más elementos. En este caso, después de varios iterados (parte transiente), los iterados sucesivos repetirán la cola periódica; esto es, se terminará en una órbita periódica cuyo periodo es igual al de la cola periódica. De estos dos casos podemos concluir que la dinámica de cualquier número racional $x_0$ resulta en el punto de equilibrio, o en una órbita periódica. Finalmente, si consideramos una condición inicial que es irracional, su representación binaria no será periódica nunca, por lo que su dinámica reproducirá esto. En otras palabras, una condición inicial irracional resultará en una órbita aperiódica.

# Dado que la computadora trabaja con números de punto flotante con *precisión finita*, la representación de los números de punto flotante quivale a números racionales con una cola inifinita de ceros. Esto explica los resultados obtenidos en los ejercicios al usar números de punto flotante.

# La consecuencia importante de este análisis se vuelve clara al considerar dos condiciones iniciales cuya diferencia es muy pequeña, e.g., $\epsilon=2^{-N}$. Su dinámica será similar, en términos de sus iterados, hasta la $N$-ésima iteración, y a partir de aquí su dinámica será esencialmente aleatoria, ya que con probabilidad 1, ambas condiciones iniciales serán números irracionales. En términos de la distancia entre los iterados de las dos condiciones iniciales, ésta crecerá *exponencialmente* rápido y, a partir de la $N$-ésima iteración será de orden 1, es decir, de orden del tamaño del sistema. Estas caracterísiticas, como veremos más adelante, están íntimamente relacionadas con el conceto de caos.
