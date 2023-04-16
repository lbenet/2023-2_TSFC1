# # Tarea 2

#-
# > Fecha de envío: 21 de abril
# >
# > Fecha de aceptación: 8 de mayo
# >

#-
# ## Ejercicio 1
#
# (a) Consideren el mapeo $F(x) = x^2-2$ definido en $-2 \leq x \leq 2$. A partir de una condición inicial tomada al azar, construyan una órbita muy larga, por ejemplo, de $20\,000$ iterados, o más. Obtengan el histograma de frecuencias (normalizado) de los puntos que la órbita visita.
#
# (b) Repitan el ejercicio anterior pero considerando muchas condiciones iniciales, pero pocos iterados (~50).
#
# (c) ¿Qué conclusión podemos sacar de los histogramas en ambos casos?
#

#-
#Respuestas

#-
# ## Ejercicio 2
#
# (a) Usando lo que hicieron en la Tarea 1, incluyan lo que desarrollaron para los números `Dual`es en un módulo que llamaremos `NumDual` de Julia ([ver la documentación aquí](https://docs.julialang.org/en/v1/manual/modules/)). En particular, el módulo debe exportar el tipo `Dual` y la función `var_dual`, al menos. El archivo con el módulo lo deben incluir en un archivo ".jl" en su propio directorio de tareas. Carguen el módulo en este notebook, usando
# ```
# include("nombre_archivo.jl")
# using NumDual
# ```
#
# (b) Escriban una función que implemente el método de Newton para funciones en una dimensión. La derivada que se requiere debe ser calculada a través de los números duales. Obtengan usando esta implementación un cero de $f(x) = x^3 - 8$, para verificar que su implementación funciona.
#
# (c) Encuentren *todos* los puntos fijos del mapeo $F(x) = x^2 - 1.1$ usando la función que implementaron para el método de Newton.
#
# (d) Encuentren los puntos *de periodo 2* para el mapeo $F(x) = x^2 - 1.1$ usando la función que implementaron para el método de Newton.
#
# (e) Usen los números duales para mostrar que los puntos de periodo 2 para el mapeo $F(x) = x^2 -1$ son linealmente estables (atractivos).

#-
#Respuestas

# ## Ejercicio 3:
#
# Llamaremos $c_n$ al valor del parámetro $c$ para el mapeo cuadrático
# $Q_c(x) = x^2-c$, donde ocurre el ciclo superestable de periodo $2^n$,
# esto es, el valor de $c$ tal que $x_0=0$ pertenece a la órbita
# periódica de periodo $2^n$.
# Algunos de estos valores fueron obtenidos numéricamente en clase; esto puede
# servir como test inicial.
#
# - Calculen los valores de $c_r$, al menos hasta $c_6$; traten
# de obtener aún más. Con estos valores, definimos la secuencia:
# $\{f_0, f_1, f_2, \dots\}$, donde
# \begin{equation*}
# f_n = \frac{c_n-c_{n+1}}{c_{n+1}-c_{n+2}} .
# \end{equation*}
# Aproximen el valor al que converge esta secuencia,
# es decir, dar una estimación de $\delta = f_\infty$.
#
# - De los $2^p$ puntos del ciclo de periodo $2^p$, es decir,
# $\{0, p_1, \dots p_{2^{n-1}}\,\}$ hay uno (*distinto del 0*) cuya distancia
# a 0 es la menor; a esa distancia la identificaremos como $d_n$.
# Estimen numéricamente a qué converge la secuencia
# \begin{equation*}
# \alpha = - d_n/d_{n+1},
# \end{equation*}
# en el límite de $n$ muy grande.
#

#-
#Respuestas
