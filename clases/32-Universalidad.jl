# # Universalidad

using Pkg
Pkg.activate("..")
Pkg.instantiate()

using Plots

# Anteriormente generamos el siguiente diagrama de bifurcaciones de la familia cuadrática:
#
# ![Diag. bifurcaciones](diag_bif1.png)

#-
# En esta sección, daremos razones por qué ciertos aspectos de la dinámica son
# universales, como por ejemplo los exponentes de Feigenbaum (que calcularon en la Tarea 2). Es decir, por qué
# se obtienen *los mismos resultados* para una familia más amplia de mapeos,
# más allá de la cuadrática.

#-
# El argumento que se presenta será más bien cualitativo; sin embargo, las
# observaciones que aquí se harán se pueden poner en términos rigurosos, que
# se conocen como la teoría de renormalización.

#-
# ## Ciclos superestables
#
# Para la familia de mapeos cuadráticos $Q_c(x) = x^2+c$, un punto particular
# es $x=0$, simplemente porque en $x=0$ se satisface $Q_c'(x=0)=0$ para todo
# valor de $c$. Si bien esta observación parece trivial, tener
# que la derivada en un punto de una órbita periódica se anula implica que dicha
# órbita, en términos de su estabilidad, está lo más alejada posible de -1 o 1,
# que son los puntos de posibles bifurcaciones.
# Definiremos un *ciclo superestable* de periodo $n$ como aquél en
# que el punto $x_0=0$ forma parte del órbita periódica de periodo $n$
# y el mapeo es tal que $f'(x_0)=0$.

#-
# Es fácil ver que en $c_0=0$ se tiene un ciclo superestable periódico de
# periodo 1; ver por ejemplo el diagrama de bifurcaciones.
# En este caso, uno puede sustituir $c=0$ en $Q_c(x)$, y verificar
# que $Q_{0}(x_0)=x_0$ se cumple.

"Mapeo cuadrático evaluado en `x`, con parámetro `c`"
Q(x, c) = x^2 + c

"Derivada de `Qc(x,c)` respecto a `x` evaluada en `x`, con parámetro `c`"
Qprime(x, c) = 2x

c_0 = 0.0
Q(0.0, c_0) == 0.0


#-
"""
    Qn(x, c, n)
Esta función regresa el n-enésimo iterado de \$Q(x, c)\$,
donde el valor a iterar es `x` y el valor del parámetro es `c`.
"""
function Qn(x, c, n)
    for i = 1:n
        x = Q(x, c)
    end
    return x
end

# La siguiente gráfica muestra el mapeo $Q_c(x)$ para $c=c_0$.

xrange = -1:1/64:1
plot(xrange, x->Qn(x, c_0, 1))
plot!(xrange, x->x)
ylims!(-1,1)
xlabel!("x")
ylabel!("Q_c(x)")
title!("c₀ = $c_0")

# Para obtener el valor $c_1$ del ciclo superestable de periodo 2, debemos
# encontrar la $c$ tal que
#
# \begin{equation*}
# Q_c^2(0) = c^2+c = c(c+1) = 0,
# \end{equation*}
#
# cuya solución (distinta de $c_0=0$) es $c_1=-1$.

c_1 = -1.0
xrange = -1:1/64:1
plot(xrange, x->Qn(x, c_1, 2))
plot!(xrange, x->x)
ylims!(-1,1)
x₁ = -0.6
plot!([x₁, -x₁, -x₁, x₁, x₁], [x₁, x₁, -x₁, -x₁, x₁])
xlabel!("x")
ylabel!("Q_c^2(x)")
title!("c₁ = $c_1")

#
#-
# Para encontrar el valor de $c$ en que $Q_{c}^4(x=0)=0$ usaremos el
# método de Newton. En este caso usaremos
# [TaylorSeries.jl](https://github.com/JuliaDiff/TaylorSeries.jl) para
# calcular la derivada de la función `f` (usando diferenciación automática).

using Pkg
Pkg.add("TaylorSeries")

#-
using TaylorSeries
#
function roots_newton(f, x0)
    t = Taylor1(eltype(x0), 1)   # Define una variable tipo `Taylor1` de orden 1
    #Se implementan 30 iterados del método de Newton
    for ind = 1:30
        #`fT` equivale al desarrollo de Taylor de `f`, de orden 1
        fT = f(x0+t)
        #`fT[0]` y `fT[1]` son el coeficiente de orden 0 y 1 de la serie `fT`
        x0 = x0 - fT[0]/fT[1]
    end
    return x0
end

#-
Q4c = c -> Qn(0.0, c, 4)
c_2 = roots_newton(Q4c, -1.4)
xrange = -1:1/64:1
plot(xrange, x->Qn(x, c_2, 4))
plot!(xrange, x->x)
ylims!(-1,1)
x₁ = -0.25
plot!([x₁, -x₁, -x₁, x₁, x₁], [x₁, x₁, -x₁, -x₁, x₁])
xlabel!("x")
ylabel!("Q_c^4(x)")
title!("c₂ = $c_2")

# Nuevamente, el recuadro en la gráfica de $c_2$ muestra un detalle de
# $Q_{c_2}^4(x)$ que, localmente, se *parece* a $Q_{c_0}(x)$. En este caso,
# la comparación con el diagrama original es directa, o una doble reflexión (respecto al eje y)
# corresponde a la identidad.

Q8c = c -> Qn(0.0, c, 8)
c_3 = roots_newton(Q8c, -1.4)
xrange = -1:1/128:1
plot(xrange, x->Qn(x, c_3, 8))
plot!(xrange, x->x)
ylims!(-1,1)
x₁ = -0.125
plot!([x₁, -x₁, -x₁, x₁, x₁], [x₁, x₁, -x₁, -x₁, x₁])
xlabel!("x")
ylabel!("Q_c^8(x)")
title!("c₃ = $c_3")

# ### Ejercicio
#
# Comparar gráficamente los mapeos $Q_{c}(x)$ y $Q_{c^\prime}^2(x)$ para
# $c=1/4, 0, -3/4, -1, -2, -2.2$ y $c^\prime=-3/4,-1,-5/4,-1.3, -1.546\dots, -1.65$.
#
# #(Respuesta)

#-
# ## Constante $\alpha$ de Feigenbaum
#
# El punto del análisis gráfico anterior es que, *localmente*, los mapeos
# $Q_{c_0}(x)$ y $Q^{2^n}_{c_n}(x)$ son muy similares, si uno se enfoca en
# un dominio muy particular para $Q^{2^n}_{c_n}(x)$.

#-
# Vale la pena notar que, en este caso, la distancia al punto fijo (que cruza
# la identidad) y que define los recuadros, es
# $d_n = Q_{c_n}^{2^{n-1}}(0) \approx -\alpha d_{n+1}$.

#-
# Esta observación se expresa de manera formal construyendo una función que
# localmente se comporta como $Q^{2^n}_{c_n}(x)$, esto es:
#
# \begin{equation*}
# g_1(x) = \lim_{n\to\infty} (-\alpha)^n Q_{c_{n+1}}^{2^n}\;\Big(\frac{x}{(-\alpha)^n}\Big).
# \end{equation*}

#-
# El límite $n\to\infty$ hace que todas las particularidades del mapeo $Q_c(x)$
# se pierdan y, en este sentido, que sólo resten las propiedades que son *universales*.
#
# La ecuación anterior se generaliza a:
#
# \begin{equation*}
# g_i(x) = \lim_{n\to\infty} (-\alpha)^n Q_{c_{n+i}}^{2^n}\;\Big(\frac{x}{(-\alpha)^n}\Big),
# \end{equation*}

#-
# De la definición de $g_i(x)$, uno puede demostrar que las funciones $g_i(x)$
# satisfacen la ecuación
#
# \begin{equation*}
# g_{i-1}(x) = -\alpha g_i\Big( g_i\big(-\,\frac{x}{\alpha}\big)\Big) .
# \end{equation*}

#-
# Tomando el límite $i\to \infty$ nos lleva a:
#
# \begin{equation*}
# g(x) \equiv T g(x) = -\alpha g\Big( g\big(-\,\frac{x}{\alpha}\big)\Big),
# \end{equation*}
#
# donde $T$ es el *operador de doblamiento de periodo*.
#
# Si una función $g(x)$ satisface la ecuación anterior, entonces la función
# $\mu g(x/\mu)$, con $\mu\neq 0$, es también solución de la ecuación. Esta
# es una propiedad de escalamiento. De aquí, imponiendo que $g(0)=1$ se
# tiene $1=-\alpha g(1)$.

#-
# La idea es hacer un desarrollo en serie de Taylor de $g(x)$ cerca de $x=0$
# a fin de obtener una aproximación de $\alpha$. De la ecuación de doblamiento
# de periodo uno obtiene:
# \begin{align*}
# g'(x) &=& g'\Big( g\big(-\,\frac{x}{\alpha}\big) \Big) g'\big(-\,\frac{x}{\alpha}\big),\\
# g''(x) &=& -g''\Big( g\big(-\,\frac{x}{\alpha}\big) \Big) \Big[ g'\big(-\,\frac{x}{\alpha}\big)\Big]^2
# -\,\frac{1}{\alpha} g'\Big( g\big(-\,\frac{x}{\alpha}\big) \Big) g''\big(-\,\frac{x}{\alpha}\big).
# \end{align*}

#-
# De la primer ecuación podemos concluir que $g'(0)=0$. Por esto, a segundo
# orden tenemos que $g(x)\simeq 1+b x^2$. Sustituyendo esta aproximación en la
# ecuación de doblamiento de periodo y desarrollando *hasta* segundo orden,
# se obtiene:
#
# \begin{equation*}
# 1+b x^2 \simeq -\alpha\Big(1+b\big(1+b(-\frac{x}{\alpha})^2\big)^2\Big) = -\alpha\Big( 1+ b + \frac{2b^2}{\alpha^2}x^2\Big) + {\cal O}(x^4).
# \end{equation*}

#-
# Igualando término a término (potencias de $x$) tenemos que se debe satisfacer:
#
# \begin{align*}
# 1 &=& -\alpha(1 + b),\\
# b &=& - 2b^2/\alpha.\\
# \end{align*}

#-
# De aquí finalmente obtenemos $b \approx -\alpha/2$ y
# $\alpha\approx 1+\sqrt{3}=2.73\dots$; el valor de
# esta constante es $\alpha = 2.502907\dots$.

#-
# La otra constante de Feigenbaum, $\delta$, se obtiene estudiando las propiedades de la
# ecuación linearizada en $c$.

#-
# ## Referencia
#
# Heinz Georg Schuster, Wolfram Just, Deterministic Chaos, 2006.
