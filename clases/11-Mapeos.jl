# # Mapeos como sistemas dinámicos

# Los mapeos son aplicaciones de $F_\mu : \mathbb{R}^N \rightarrow \mathbb{R}^N$,
# donde $N$ es la dimensionalidad del espacio fase que representa el espacio
# de variables *dinámicas* de interés. (Aquí, escribí que $x\in\mathbb{R}^N$
# para ser concretos; uno puede considerar otros conjuntos como dominios
# del mapeo, como por ejemplo los complejos).
# La idea es definir la dinámica de $x\in\mathbb{R}^N$ a través de la función
# $F_\mu$ y sus iterados, o aplicaciones repetidas, es decir,
# \begin{equation}
# x_{n+1} = F_\mu (x_n).
# \tag{1}
# \end{equation}

# En (1), $\mu$ representa uno o varios parámetros que uno puede variar,
# y $x_n$ representa
# el estado del sistema al "tiempo discreto" $n$. La idea de introducir mapeos es evitar las
# complicaciones que surgen al resolver ecuaciones diferenciales, lo que involucraría un
# "tiempo continuo", pudiendo aislar los aspectos importantes que definen las
# propiedades dinámicas del sistema.

# Una suposición *importante* que haremos sobre $F_\mu$ es que es una función que **no**
# involucra ningún tipo de variable estocástica o aleatoria. Partiendo de esta suposición,
# diremos que el sistema es determinista: el estado al "tiempo" $n+1$ sólo depende del
# estado al tiempo $n$ y de los parámetros $\mu$ del mapeo, que consideraremos constantes
# respecto al tiempo.

# Entonces, *iterar* la función $F_\mu(x_0)$ significa evaluarla, una y otra vez, de
# manera repetida, a partir de un valor $x_0$ que llamaremos *condición inicial*.
# De manera concisa, escribiremos $x_n = F^n_\mu(x_0) = F_\mu(F_\mu(...(F_\mu(x_0))...))$.
# Otra manera de escribir esto mismo es escribiendo explícitamente cada iterado, es decir,
# $x_1=F_\mu(x_0)$ representa al primer iterado, $x_2=F_\mu(x_1)=F^2_\mu(x_0)$ al segundo,
# y en general el $n$-ésimo iterado lo escribiremos $x_n=F_\mu(x_{n-1})=F^n_\mu(x_0)$.

# Como ejemplo, consideraremos $F(x)=x^2+1$, y tendremos que
# \begin{align*}
# x_1 & = F(x_0) = x_0^2+1, \\
# x_2 & = F^2(x_0) = (x_0^2+1)^2+1,\\
# x_3 & = F^3(x_0) = ((x_0^2+1)^2+1)^2+1,\\
# x_4 & = F^4(x_0) = (((x_0^2+1)^2+1)^2+1)^2+1,\\
# \vdots
# \end{align*}

# Es claro que la notación $F^n(x)$ no significa la potencia $n$ del mapeo, si no el
# $n$-ésimo iterado del mapeo, a partir de la condición inicial $x$.

#-

# # Órbitas

# A la secuencia (¡ordenada!) de los iterados la llamaremos *órbita*, esto es,
# la órbita viene dada por la secuencia $x_0, x_1, x_2, \dots$.
# Así, para el ejemplo anterior con $x_0=0$ tendremos
# $x_1=1$, $x_2 = 2$, $x_3 = 5$, $x_4 = 26$, etc. Intuitivamente podemos decir que
# esta órbita tiende a infinito, ya que el valor del $n$-ésimo iterado aumenta, y el
# siguiente involucrará elevarlo al cuadrado.

# Hay varios tipos de órbitas. Algunas, como vimos antes, pueden diverger; eso depende
# no sólo del el mapeo, sino también de la condición inicial.
# Otras órbitas son más aburridas, en el sentido de que
# no cambian: son los puntos fijos del mapeo. Éstos, evidentemente, satisfacen la
# ecuación
# \begin{equation*}
# F_\mu(x) = x.
# \tag{2}
# \end{equation*}
# En otras palabras, cada iterado coincide consigo mismo.

# Por ejemplo, para el mapeo $G(x)=x^2-x-4$, los puntos fijos satisfacen $x^2-2x-4=0$, de
# donde concluímos que hay dos soluciones, $x_\pm = 1\pm\sqrt{5}$.
# Por otra parte, para $F(x) = x^2+1$ y $x\in\mathbb{R}$, la ecuación (2)
# lleva a $x^2+1=x$ que no tiene solución (en los reales), por lo que no hay puntos fijos.
# De hecho, esta es la razón por la que todas las
# órbitas divergen a $+\infty$. (Otra manera de formular esto último, menos rigurosa, es
# que el único punto fijo *atractivo* es $+\infty$; es una formulación menos rigurosa ya
# que $\infty\not\in\mathbb{R}$.)

# Numéricamente, verificar si cierta condición inicial es un punto fijo de un mapeo es
# sencillo, pero también delicado. Concretamente, para $G(x)$ definido arriba debemos
# verificar, por ejemplo, si el iterado $G(x_+)$ es $x_+$, y lo mismo para $x_-$.

G(x) = x^2 - x - 4  # definimos G(x)

#-

x₊ = 1 + sqrt(5)    # condición inicial, x\_+<TAB>

G(x₊) - x₊ == 0

#-

x₋ = 1 - sqrt(5)    # condición inicial, x\_-<TAB>

G(x₋) - x₋ == 0

#-

# El resultado anterior parece indicar que el iterado de $G(x_-)$ no es $x_-$; esto es a
# lo que me refería con que la verificación es delicada. La razón por la que no
# obtenemos el resultado "esperado" son los errores numéricos
# asociados al truncamiento: los *números de punto flotante* no son los números reales.
# Usando números de precisión extendida vemos que usando más bits de precisión,
# $G(x_-) - x_-$ se acerca más a cero.

G(x₋)-(x₋)

#-

precision(BigFloat)  # Precisión default de `BigFloat`, en "bits"

#-

G(1-sqrt(BigInt(5)))-(1-sqrt(BigInt(5)))

# Otro tipo de órbitas que son importantes son las órbitas periódicas. En este caso tenemos
# que una secuencia *finita* de iterados se repite a partir de cierta iteración:
# $x_0, x_1, \dots, x_{n-1}, x_0, x_1, \dots$. El menor número *positivo* de iterados
# de una órbita periódica, tal que se hace aparente su periodicidad, se llama *periodo*.
# Entonces, cada punto de dicha órbita (periódica) es periódico con periodo $n$,
# ya que $x_r=x_{r+n}$. Vale la pena notar que los puntos fijos son órbitas periódicas
# de periodo 1.

# Un punto que pertenece a una órbita de periodo $n$ satisface la ecuación
# \begin{equation*}
# F^n(x_0) = x_0.
# \tag{3}
# \end{equation*}
# Claramente, de la ecuación (3) concluimos que un punto de periodo
# $n$ del mapeo $F$ es un punto fijo (de periodo 1) del mapeo definido por la función $F^n$.
# Además, la ecuación (3) tiene *al menos* $n$ soluciones distintas.

# Un punto $x_0$ se llama *eventualmente periódico* cuando sin ser punto fijo o periódico,
# después de un cierto número *finito* de iteraciones, los iterados pertenecen a una
# órbita periódica.

# Un ejemplo, nuevamente para el mapeo $G(x)=x^2-1$, es $x_0=1$: $G(1)=0$, $G(0)=G^2(1)=-1$,
# $G(-1)=G^3(1)=0$, etc. Es decir, $x_0=1$ en sí no pertenece a la órbita periódica, aunque
# sus iterados, a partir de $x_1$, sí y forman una órbita de periodo 2.

# En sistemas dinámicos típicos, la mayoría de los puntos no son fijos, ni periódicos,
# ni eventualmente periódicos. Por ejemplo, el mapeo $T(x)=2x$ tiene como punto fijo
# único, $x^*=0$. Cualquier otra órbita tiende a $\;\pm\infty$, ya que
# $T^n(x_0) = 2^n x_0$ y entonces $|T^n(x_0)|\to\infty$.

# En general, la situación es aún más compleja... e interesante.

#-
# # Análisis gráfico

# En lo que sigue ilustraremos una manera gráfica de visualizar la dinámica de mapeos
# en 1 dimensión.

# Para graficar, usaremos la paquetería `Plots.jl`.

using Plots

#-

# La idea del análisis gráfico es poder visualizar los iterados de una órbita. En el eje
# de las abscisas (eje "x") dibujaremos $x_n$ y en el de las ordenadas dibujaremos a su
# iterado, es decir, $F(x_n)$. Entonces, para localizar $x_{n+1}$ simplemente
# necesitamos la gráfica de $y=F(x)$.

# Usaremos como ejemplo: $F(x) = \sqrt{x}$. Generaremos un número aleatorio entre 0 y 5
# con `rand` como condición inicial, y calcularemos su iterado.

x0 = 5.0*rand()
x1 = sqrt(x0)
x0, x1

#-

#Dominio (en x) para la gráfica
domx = 0.0:1/32:5.2

# `Plots.jl` se tarda en el primer dibujo dado que inicializa
# varias cosas internamente. Este es un problema más o menos resuelto en
# Julia v1.9.

#Dibuja F(x) y define escalas, etc. Usa `domx` para generar puntos quese usan
#para pintar la función `sqrt`
plot(domx, sqrt,
    xaxis=("x", (0.0, 5.0), 0:5.0),
    yaxis=((0.0, 3.0), "F(x)"),
    legend=false, title="F(x)=sqrt(x)", grid=false)

#Dibuja x_0 -> x_1 = F(x_0), en la misma grráfica!
#Noten que `Plots` usa vectores, de hecho, cantidades iterables
plot!([x0, x0, 0.0], [0.0, x1, x1], color=:orange)

#Dibuja el punto (x0, x1)
scatter!([x0], [x1], color=:orange, markersize=2)

#-

# Como se trata de *iterar* de manera repetida, lo que ahora requerimos es, en algún
# sentido, tener a $x_1$ en el eje `x`. Para esto usamos la identidad, i.e., la
# recta $y=x$. Noten el ligero cambio para que los ejes y el título aparezcan más
# agradables.

#Dibuja F(x) y define escalas, etc
plot(domx, sqrt,
    xaxis=("x", (0.0, 5.0), 0:5.0),
    yaxis=((0.0, 3.0), "F(x)"),
    legend=false, title="F(x)=sqrt(x)", grid=false)

#Dibuja la identidad; en este caso, usamos la función anónima `x->x`
plot!(domx, x->x, color=:red)

#Dibuja, y une por rectas, los puntos: (x0,0), (x0,x1), (0,x1)
plot!([x0, x0, 0.0], [0.0, x1, x1], color=:orange, lw=2.0)

#A partir del último punto (0,x1), dibuja (x1,x1) y (x1,0)
plot!([0.0, x1, x1], [x1, x1, 0.0], line=(:green, :dash, 2.0, 0.4))

#Dibuja los puntos (x0, x1) y (x1, x1) con un marcador más grande
scatter!([x0, x1], [x1, x1], color=:orange, markersize=2)

# Dado que tenemos $x_1$ en el eje $x$, el mismo proceso de antes
# puede ser implementado para obtener $x_2$, o cualquier otro iterado $x_n$.
# Vale la pena notar que, una vez que estamos en la diagonal, podemos ir
# *directamente* a la función $F(x)$ para obtener $x_2$, y nuevamente a la
# diagonal y a la función para tener $x_3$, etc.

x2 = sqrt(x1)

#Dibuja F(x) y define escalas, etc
plot(domx, sqrt,
    xaxis=("x", (0.0, 5.0), 0:5.0),
    yaxis=((0.0, 3.0), "F(x)"),
    legend=false, title="F(x)=sqrt(x)", grid=false)

plot!(domx, x->x, color=:red)

#Dibuja (x0,0), (x0,x1), (x1,x1), (x1,x2), (x2,x2)
plot!([x0, x0, x1, x1, x2], [0.0, x1, x1, x2, x2],
    line=(:orange, :dash, 2.0))

#Dibuja los puntos (x0, x1) y (x1, x1)
scatter!([x0, x1, x1, x2], [x1, x1, x2, x2], color=:orange, markersize=2)

# Seremos ahora un poco más sistemáticos, y definiremos una función, `itera_mapeo`,
# cuyos argumentos son la función `f`, la condición inicial `x0` y el *entero*
# `n` de iteraciones del mapeo. La función debe devolver *tres* *vectores*: uno
# que incluya la secuencia de iterados (incluyendo a la condición inicial), y
# otros se usarán para el análisis gráfico. Incluímos *docstrings* para documentar
# cada función.

"""
    itera_mapeo(f, x0, n)

Itera la función \$x->f(x)\$ (de una dimensión) `n` veces a partir de la
condición inicial `x0`. Regresa tres vectores, el primero contiene los
iterados de manera sucesiva; los otros contienen los iterados  que se usarán
para pintar el análisis gráfico.
"""
function itera_mapeo(f, x0, n::Int)
    #Defino/creo tres vectores de salida (de `Float64`s)
    its = [x0]
    its_x = [x0]
    its_y = [0.0]
    #Obtengo los iterados
    for i=1:n
        x1 = f(x0)
        push!(its, x1)
        push!(its_x, x0, x1)
        push!(its_y, x1, x1)
        x0 = x1
    end
    return its, its_x, its_y
end

# Definimos unos tests, sencillos, útiles para checar que las cosas hacen lo que
# deben hacer.

using Test
let
    nits = 2
    xs, vx, vy = itera_mapeo(x->sqrt(x), 16.0, 2)
    @test length(xs) == nits+1
    @test length(vx) == length(vy) == 2*nits+1
    @test xs == [16.0, 4.0, 2.0]
end

# Ahora definimos la función `analisis_grafico` de tal manera que usándola
# se obtenga el tipo de gráficas generada arriba. Esto es, que se grafique
# el mapeo `F` y la identidad, y los `n` siguientes iterados a partir de la
# condición inicial `x0`. El argumento (opcional)
# `domx` debe especificar la región (en $x$) que se grafica.

"""
    analisis_grafico(F::Function, x0::Float64, n::Int)

Implementa el análisis gráfico para la función \$x->F(x)\$, usando la condición
inicial `x0` y `n` iteraciones. Internamente se llama a `analisis_grafico!`
"""
function analisis_grafico(f, x0::Float64, n::Int, domx=0.0:1/128:1.0)
    #Graficamos x->F(x) y x->x
    Plt1 = plot(domx, x->f(x),
        xaxis=("x", (domx[1], domx[end])),
        yaxis=("f(x)"),
        color=:blue, legend=false, grid=false)

    plot!(Plt1,
        domx, identity, color=:blue, linestyle=:dash)

    #Se grafican los iterados
    analisis_grafico!(Plt1, f, x0, n, domx)
    return Plt1
end

"""
    analisis_grafico!(Plt1, f::Function, x0::Float64, n::Int)

Modifica la gráfica `Plt1` iterando el mapeo \$x->f(x)\$, a partir
de la condición inicial `x0`, usando `n` iterados. La gráfica se
hace considerando `domx` como el dominio.s
"""
function analisis_grafico!(Plt1, f::F, x0::Float64, n::Int,
        domx=0.0:1/128:1.0; color=:orange) where {F}
    #Calculamos los iterados
    _, vx, vy = itera_mapeo(x->f(x), x0, n)

    #Graficamos los nuevos iterados
    plot!(Plt1, vx, vy, line=(color, :dash, 2.0),
        markershape=:circle, markercolor=color, markerstrokecolor=color)

    return Plt1
end

# Ejemplificamos las funciones con $F(x)=\sqrt{x}$, con tres condiciones iniciales.

Plt1 = analisis_grafico(x->sqrt(x), 5.0, 4, 0.0:1/32:5.2);
analisis_grafico!(Plt1, x->sqrt(x), 0.1, 4, 0.0:1/32:5.2,
    color=:red)
analisis_grafico!(Plt1, x->sqrt(x), 3.6, 4, 0.0:1/32:5.2,
    color=:green)

# Claramente, del análisis gráfico, podemos ver que el punto $x=1$ es un punto
# (linealmente) estable, atractivo; por otra parte, y aunque esto es menos
# obvio, el punto $x=0$ es un punto (linealmente) inestable, repulsivo.

# # Puntos fijos

# El análisis gráfico es útil pero definitivamente no es riguroso. Esto se puede
# deber a cuestiones de precisión numérica o simplemente a que el número de
# iteraciones es finito y podría ser insuficiente.

# Un resultado riguroso (¡teorema!) que es útil para encontrar puntos fijos es el
# **teorema del valor intermedio**: Supongamos que $F:[a,b]\to\mathbb{R}$ es
# una función *continua*, y que $y_0$ se encuentra entre $F(a)$ y $F(b)$.
# Entonces, existe un punto en $x_0\in[a,b]$ tal que $F(x_0)=y_0$.

# Una consecuencia de este teorema es el teorema del punto fijo.

# **Teorema del punto fijo:** Supongamos que $F:[a,b]\to[a,b]$ es una función
# *continua*. Entonces, existe un punto fijo de $F(x)$ en $[a,b]$.

# Algunos comentarios:

# - El teorema asienta la *existencia* de un punto fijo; puede haber más.

# - El teorema asume que $F$ es *continua* y que mapea el intervalo $[a,b]$ en si mismo.

# - El intervalo $[a,b]$ es *cerrado*.

# - El teorema **no** dice cómo encontrar a los puntos fijos.

# La *demostración* se basa en aplicar el teorema del valor medio para la
# función $H(x)=F(x)-x$, y mostrar que existe un valor $x_0$ tal que $H(x_0)=0$.
# $H(x)$ es continua en el intervalo $[a,b]$ (así que se satisfacen las hipótesis
# del teorema del punto intermedio) y satisface $H(a) = F(a)-a \ge 0$ y
# $H(b)=F(b)-b\le 0$. (Estas propiedades se satisfacen ya que $F:[a,b]\to[a,b]$.)
# $\Box$

#-
# # Estabilidad

# A fin de entender el comportamiento *cerca* de un punto fijo, estudiaremos
# ahora mapeos lineales. La idea de estudiar un mapeo lineal es que éste constituye
# la primer aproximación en una series de Taylor (la linearización de algo más
# complicado), cerca de un punto fijo. Para hacer las cosas más sencillas,
# consideraremos que el punto fijo es el cero, y el mapeo tiene la forma:

# \begin{equation}
# F_\alpha(x) = \alpha x.\tag{4}
# \end{equation}

#-

# ### (a) $0<\alpha <1$.

#=
Definición del mapeo; noten que incluimos a la pendiente como
argumento de la función
=#
f(x, α) = α * x

#-

plt2 = analisis_grafico(x->f(x, 0.6), 0.8, 20, -1:1/32:1)
analisis_grafico!(plt2, x->f(x, 0.6), -0.8, 20, -1:1/32:1, color=:green)

# Como se puede observar, los iterados de ambas condiciones iniciales convergen a 0;
# en algún sentido, para $0<\alpha<1$ el punto fijo los *atrae*.

x1, _, _ = itera_mapeo(x->f(x, 0.6), 0.8, 20)
x2, _, _ = itera_mapeo(x->f(x, 0.6), -0.8, 20)
x1[end], x2[end]

# ### (b) $\alpha>1$.

x3, _, _ = itera_mapeo(x->f(x, 1.6), 0.08, 8)
x4, _, _ = itera_mapeo(x->f(x, 1.6), -0.08, 8)

plt3 = analisis_grafico(x->f(x, 1.6), 0.08, 8, -1:1/32:1)
analisis_grafico!(plt3, x->f(x, 1.6), -0.08, 8, -1:1/32:1, color=:green)

# En este caso, con $\alpha > 1$, observamos que los iterados *se alejan* del
# punto fijo; uno dice que el punto fijo los *repele*.

x3[end], x4[end]

# ### Caso general

# En el caso de un mapeo lineal $x_{n+1}=\alpha x_n$, el mapeo define una sucesión
# geométrica. Entonces, el $n$-ésimo iterado vendrá dado por:

# \begin{equation}
# x_n = x_0 \alpha^n\tag{5}
# \end{equation}

# De aquí es claro que, si $|\alpha|<1$, el límite cuando $n\to\infty$ es 0, el punto
# fijo. En este caso decimos que el punto fijo es **linealmente estable**.
# La diferencia entre el caso con $\alpha$ positiva o negativa radica en la *forma*
# en la que los iterados se acercan al punto fijo.

# Por otra parte, si $|\alpha|>1$, el límite cuando $n\to\infty$ es $\infty$, es decir,
# los iterados se alejan del punto fijo. En este caso diremos que el punto
# es **linealmente inestable**.

# El análisis que hemos desarrollado aquí lo hicimos para mapeos lineales de la forma
# $x_{n+1} = F_\alpha(x_n)=\alpha x_n$, pero es útil más allá de los mapeos lineales.
# Como dijimos arriba, cualquier mapeo $F(x)$, alrededor de su punto fijo, lo podemos
# escribir a primer orden como

# \begin{equation}
# F(x_* + \delta) = x_* + \delta F'(x_*) + \cal{O}(\delta^2),\tag{6}
# \end{equation}

# que precisamente es un mapeo lineal en $\delta$, donde el equivalente de la
# pendiente $\alpha$, utilizada arriba, es $F'(x_*)$. Esto es, las propiedades de
# estabilidad *lineal* están dadas por el valor de su derivada en el punto fijo.

#-
# ### Puntos periódicos

# De la misma manera que para los puntos fijos, los puntos periódicos se pueden
# clasificar en atractivos, repulsivos o neutros. Básicamente, esto es consecuencia de
# que cada punto periódico $\tilde{x}$, de periodo $p$, del mapeo $F(x)$, es un
# *punto fijo* del mapeo $\tilde{x} = F^p(\tilde{x})$, como mostramos anteriormente.

# Un ejemplo sencillo e ilustrativo de esto es el mapeo $F(x)=x^2-1$, definido
# en el intervalo $[-1,1]$. Claramente, este mapeo tiene tiene una órbita de periodo 2
# dada por $0, -1, 0, -1, \dots$. Cada uno de estos puntos, son puntos fijos de

# \begin{equation}
# F^2(x) = (x^2-1)^2-1 = x^2 (x^2-2),\tag{7}
# \end{equation}

# esto es, ambos puntos (¡y sólo ellos!) satisfacen la ecuación

# \begin{equation}
# F^2(x) - x = x(x^3-2x-1) = x(x+1)(x^2-x-1) = 0.\tag{8}
# \end{equation}

f1 = x -> x^2-1        # First iterate
f2 = x -> f1(f1(x))    # Second iterate

#-

plot(-1:1/32:1, f1,
    xaxis=("x", (-1.1, 1.1)), yaxis=("F(x), F^2(x)", (-1.03,0.03)),
    label="F(x)", grid=:false, legend=(0.78, 0.94), background_color_legend=:transparent,
    color=:blue)

plot!(-1:1/32:1, f2, xaxis=("x", (-1.1, 1.1)), label="F^2(x)", color=:red)

plot!(-1:1/16:0.1, identity, xaxis=("x", (-1.1, 1.1)), label="Id(x)", color=:green)

# Es claro de las gráficas que $(F^2)'(0)=(F^2)'(-1)=0$. Ambos puntos son
# puntos fijos atractivos para el mapeo $F^2(x)$; el otro punto fijo del mapeo
# $F^2(x)$, $x_* = (1-\sqrt{5})/2$, es repulsivo, ya que su pendiente es mayor a 1,
# que es la pendiente de la identidad. Vale la pena notar que $x_*$ es el único
# punto fijo de periodo 1, dado que satisface $F(x_*)-x_* = x_*^2-x_*-1 = 0$.

# Entonces, puntos que inician suficientemente cerca de 0 o de -1 serán atraídos
# a estos puntos bajo el mapeo $F^2(x)$. Bajo el mapeo $F$, puntos
# suficientemente cerca de 0 o -1, se acercarán paulativamente, cada segundo
# iterado.

# Es claro que el concepto de estabilidad se puede extender a los puntos de
# periodo $n$. Cuantitativamente, debemos evaluar la derivada de $F^n(x)$ en
# algún punto de la órbita periódica. Entonces, debemos calcular la derivada del
# mapeo $F^n(x)$. Consideremos como ejemplo el caso $F^2(x)$ primero. En este
# caso, tenemos $F^2(x)=F(F(x))$, y denotaremos a los puntos de periodo 2 como
# $x_0$ y $x_1$. Entonces, usando la regla de la cadena obtenemos:

# \begin{equation*}
# \frac{\textrm{d}F^2(x_0)}{\textrm{d}x} = F'(F(x_0)) F'(x_0) = F'(x_1) F'(x_0).
# \end{equation*}

# De igual manera, considerando los puntos de periodo 3 tenemos,
# $F^3(x)=F(F^2(x))$ y obtenemos:

# \begin{equation*}
# \frac{\textrm{d}F^3(x_0)}{\textrm{d}x} = F'(F^2(x_0)) (F^2)'(x_0) = F'(x_2) F'(x_1) F'(x_0).
# \end{equation*}

# Esto se generaliza de manera evidente, y es fácil demostrar que se cumple

# \begin{equation}
# \frac{\textrm{d}F^n(x_0)}{\textrm{d}x} = (F^n)'(x_0) = F'(x_{n-1})\cdots F'(x_1)F'(x_0).\tag{9}
# \end{equation}

# De esta última relación vemos que **todos** los iterados de una órbita periódica de
# periodo $n$ tienen la misma derivada *respecto* al mapeo $F^n$, i.e.,
# $(F^n)'(x_0)=(F^n)'(x_1)=\dots=(F^n)'(x_{n-1})$.
# Por lo tanto, todos los puntos ligados por una órbita periódica son atractivos o repulsivos.

# ---

# # Bibliografía

# - Robert L. Devaney, A First Course In Chaotic Dynamics: Theory and Experiment, 1992.

# - Heinz Georg Schuster, Wolfram Just, Deterministic Chaos, 2006.