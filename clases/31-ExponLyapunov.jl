# # Exponentes de Lyapunov

# # # Definición

using Pkg
Pkg.activate("..")
Pkg.instantiate()

# Hasta ahora, lo que hemos visto es que al variar el parámetro $c$ para el mapeo cuadrático $Q_c(x)$, el mapeo exhibe una familia de bifurcaciones de doblamiento de periodo. Esto lo vimos, inicialmente de forma analítica, y después de manera numérica. Sin embargo, la resolución numérica eventualmente se vuelve insuficiente y es complicado visualizar las cosas. La pregunta que buscaremos resolver es si uno *puede* llegar a *periodo infinito* para un valor finito $c_\infty$, de hecho mayor a $-2$, para el mapeo cuadrático. Periodo infinito en este caso equivale a no tener periodo, y entonces uno se pregunta si hay un sentido de estabilidad de órbitas genéricas; como veremos, no lo hay, y esta dinámica refleja lo que llamaremos *caos*. Abordaremos esta pregunta poco a poco.

#-
# Una manera de caracterizar el caos, en el sentido de *sensibilidad a condiciones iniciales*, es a través de los **exponentes de Lyapunov**. La idea es sencilla: si hay una dependencia *exponencial*, respecto al tiempo, en la evolución de la separación de condiciones iniciales infinitesimalmente cercanas, entonces diremos que hay sensibilidad a las condiciones iniciales, es decir, caos.

#-
# Para esto, simplemente monitoreamos la evolución de dos condiciones iniciales cercanas, $x_0$ y $x_0+\epsilon$, donde $\epsilon>0$ es muy pequeño. Considerando mapeos en una dimensión, la distancia entre los $n$-ésimos iterados es
# \begin{equation}
# d_n = \big|\, f^{n}(x_0+\epsilon)-f^{n}(x_0) \big|\,.
# \end{equation}

#-
# Entonces, suponiendo que $d_n$ tiene una dependencia exponencial de $n$
# (tiempo discreto), para $n\to\infty$ y $\epsilon\to 0$, escribimos
# $d_n= \epsilon \exp(\lambda n)$, de donde obtenemos
# \begin{equation*}
# \lambda(x_0) \equiv \lim_{n\to\infty} \;\lim_{\epsilon\to 0} \;
# \frac{1}{n}\log\Big| \frac{f^{n}(x_0+\epsilon)-f^{n}(x_0)}{\epsilon}\Big|.
# \end{equation*}

#-
# A $\lambda(x_0)$ le llamamos el exponente de Lyapunov. Si $\lambda(x_0)>0$
# diremos que hay caos, mientras que si $\lambda(x_0)<0$ diremos que no lo hay.
# El que no haya caos debemos interpretarlo como que el movimiento es periódico
# (o quizás cuasi-periódico), pero no hay movimiento aperiódico. En cambio, que haya
# caos significa que hay regiones del espacio $x$ cuya dinámica es no periódica,
# aunque pueden existir condiciones iniciales que tengan órbitas periódicas.

#-
# Observaciones:
#
# - El exponente de Lyapunov, estrictamente hablando, depende de la condición
# inicial $x_0$.
# - En la definición del exponente de Lyapunov se require la evaluación
# de **dos** límites, uno que involucra al tiempo ($n\to\infty$), y otro que
# representa la distancia entre las condiciones iniciales ($\epsilon\to 0$).
# - La definición del exponente de Lyapunov es sutil, ya que en muchas
# ocasiones *sabemos* que el rango de $f(x)$ es acotado cuando $x$ está
# en cierto dominio, lo que entonces podría llevar erróneamente a concluir
# que $\lambda(x_0)=0$. La sutileza está evidentemente en el órden de los
# límites, que no necesariamente conmuta.
# - Las unidades del exponente de Lyapunov corresponden al inverso del tiempo, es
# decir, $\lambda^{-1}$ describe una escala relevante del tiempo en que
# condiciones iniciales se separan una distancia del orden de $e$ ($\exp(1)$).

#-
# Si el mapeo $f(x)$ es suficientemente suave, entonces podemos escribir
# \begin{equation*}
# \lambda(x_0) = \lim_{n\to\infty} \frac{1}{n}\log\Big| \frac{{\rm d} }{{\rm d}x}f^{n}(x_0)\Big|,
# \end{equation*}
# donde literalmente hemos usado la definición de la derivada de la función $f^{n}$, el iterado $n$
# de $f(x)$.
# Para mapeos se cumple
# \begin{equation*}
# \frac{{\rm d}f^n}{{\rm d}x}(x_0) = f'(x_0) f'(x_1)\dots f'(x_{n-1}) = \prod_{i=0}^{n-1} f'(x_i),
# \end{equation*}
# donde $x_i=f^i(x_0)$, es decir, $x_i$ es el i-ésimo iterado de $x_0$, obtenemos
# \begin{equation}
# \lambda(x_0) = \lim_{n\to\infty} \frac{1}{n} \sum_{i=0}^{n-1} \log\Big| \, f'(x_i)\, \Big|.
# \end{equation}
# Esta forma de calcular los exponentes de Lyapunov es muy conveniente para mapeos
# en una dimensión.

#-
# ### Preguntas

# - ¿Cómo se compara el exponente de Lyapunov $\lambda(x_0)$ con $\lambda( f(x_0) )$, para el mapeo $x\mapsto f(x)$?

# - ¿Cómo se generaliza la expresión que relaciona al exponente de Lyapunov con la derivada del mapeo en 1 variable, a mapeos de 2 variables?


# ## Exponentes de Lyapunov en el mapeo cuadrático

# Ahora obtendremos la dependencia del exponente
# de Lyapunov del parámetro $c$, para el mapeo cuadrático $Q_c(x) = x^2+c$.
# Volveremos a generar aquí el diagrama de bifurcaciones, ya que ambos diagramas
# permiten entender muchas cosas.

# Definimos primero varias funciones para hacer la vida más sencilla.

Q(x, c) = x^2 + c # mapeo cuadrático

#n-ésimo iterado del mapeo Q(x,c)
function Qn(x, c, n)
    for i = 1:n
        x = Q(x, c)
    end
    return x
end

Qprime(x, c) = 2*x # derivada

#Posición del punto fijo `x_+`
pplus(c) = 0.5*(1+sqrt(1-4*c))

"""
    rand_dominio_Q(c)

Regresa un número aleatorio en el dominio de
`Q(x, c)`.
"""
function rand_dominio_Q(c)
    xplus = pplus(c)
    return 2*xplus*rand()-xplus
end

# Generamos primero los datos para el diagrama de bifurcaciones.

#Las siguiente función la definimos en alguna clase anterior, y la
#usaremos para regenerar el diagrama de bifurcaciones; se modificó aquí
#para explotar lo que tenemos aquí.
function diag_bifurc(f, nit, nout, crange)
    ff = Array{Float64}(undef, (nout, length(crange)))

    for ic in eachindex(crange)
        c = crange[ic]
        x = rand_dominio_Q(c) # condición inicial aleatoria
        x = Qn(x, c, nit)
        @inbounds for i = 1:nout
            x = Q(x, c)
            ff[i, ic] = x
        end
    end

    return ff
end

#-
#Rango de interés para los parámetros
crange = range(0.25, stop=-2, length=2^10)

ff = diag_bifurc(Q, 10_000, 256, crange);
cc = ones(size(ff, 1)) * crange';

#Lo siguiente cambia las matrices en vectores, y se usa para la gráfica
ff = reshape(ff, size(ff, 1)*size(ff, 2));
cc = reshape(cc, size(ff));

#Aquí calculamos el exponente de Lyapunov, usando la Ec. \refeq{eq2}.

"""
    expon_Lyap(f, funprime, x0, c, nit=1_000_000)

Regresa el exponente de Lyapunov para el mapeo `x->fun(x,c)`, utilizando
la función `funprime(x, c)` que representa la derivada del mapeo (respecto
a la variable dependiente `x`); `c` representa el parámetro del mapeo
y `nit` el número de iteraciones que se consideran.
"""
function expon_Lyap(fun, funprime, x, c, nit=10_000)
    sum_log = 0.0
    for i = 1:nit
        fprim = funprime(x, c)
        sum_log += log(abs(funprime(x, c)))
        x = fun(x, c)
    end
    return sum_log/nit
end

#Vector con resultados del exponente de Lyapunov
λv = expon_Lyap.(Q, Qprime, rand_dominio_Q.(crange), crange);

#-
# Ahora graficamos, primero, el diagrama de bifurcaciones, y después el resultado obtenido para el exponente de Lyapunov.

using Plots

#Dibujamos el diagrama de bifurcaciones
p1 = scatter(cc, ff, markersize=0.5, markerstrokestyle=:solid,
    legend=false, title="Fig. 1")
xaxis!(p1, "c")
yaxis!(p1, "x_n")
xlims!(p1, -2.0, 0.5)
ylims!(p1, -2.0, 2.0)
plot!(p1, [-2, 0.5], [0.0, 0.0], color=:red)

#-
#Dibujamos el diagrama para el exponente de Lyapunov
p2 = scatter(crange, λv, markersize=0.5, markerstrokestyle=:solid,
    legend=false, title="Fig. 2")
xaxis!(p2, "c")
yaxis!(p2, "L")
xlims!(p2, -2.0, 0.5)
ylims!(p2, -1.5, 1.0)
plot!(p2, [-2, 0.5], [0.0, 0.0], color=:red)

# Hay varias observaciones interesantes que se pueden hacer al usar ambos diagramas:
#
# - Cada vez que ocurre una bifurcación de doblamiento de periodo, el exponente de Lyapunov es cero; esto es consecuencia de que en el punto de bifurcación (de doblamiento de periodo), la derivada es -1.
# - Cada vez que ocurre un ciclo superestable ($x=0$ es parte de la órbita periódica), el exponente de Lyapunov diverge a $-\infty$; esto es consecuencia de que en este caso, la derivada (en $x=0$) se anula.
# - Al disminuir $c$, en algún momento el exponente de Lyapunov se hace positivo; esto es, todos los iterados de la órbita son localmente inestables.

#-
# A partir de los cálculos que hemos hecho, podemos obtener una aproximación del valor de $c$ en que el exponente de Lyapunov es positivo (al disminuir $c$) por primera vez.

n0 = findfirst(l -> l > 0.0, λv)

(crange[n0], λv[n0])
