# Tarea 2

# Paqueterías a utilizar
using Plots, Test

# > Fecha de envío: 8/05/2023
# >
# > Fecha de aceptación:
# >

# # Ejercicio 1

# (a) Consideren el mapeo $F(x) = x^2-2$ definido en $-2 \leq x \leq 2$. A partir de una condición inicial tomada al azar, 
# construyan una órbita muy larga, por ejemplo, de $20\,000$ iterados, o más. Obtengan el histograma de frecuencias 
# (normalizado) de los puntos que la órbita visita.

"""
Dada una condición inicial, aplicamos una función de manera iterativa hasta que converja a cierta ϵ la distancia entre
el resultado obtenido y el anterior. Como resultado se obtienen 2 arreglos, uno que contiene el avance de las iteraciones 
empezando por la condición inicial, mientras que el segundo arreglo contiene cada iteraciones repetida dos veces, sin 
la condición inicial.
"""
function iteramapeo(f::Function, x₀::Number, ϵ::Number = 0.001)
    r = Inf
    xₙ = x₀

    x_array = [x₀]
    y_array = [0.]
    while r > ϵ
        xₙ₊₁ = f(xₙ)
        r = abs(xₙ₊₁ - xₙ)
        push!(x_array, xₙ, xₙ₊₁)
        push!(y_array, xₙ₊₁, xₙ₊₁)
        xₙ = xₙ₊₁
    end
    return x_array, y_array
end
"""
Dada una condición inicial, aplicamos una función de manera iterativa hasta cumplir cierto número de iteraciones dado. 
Como resultado se obtienen 2 arreglos, uno que contiene el avance de las iteraciones empezando por la condición inicial, 
mientras que el segundo arreglo contiene cada iteraciones repetida dos veces, sin la condición inicial.
"""
function iteramapeo(f::Function, x₀::Number, n_iteraciones::Int)
    xₙ = x₀
    x_array = [x₀]
    y_array = [0.]
    for _ in 1:n_iteraciones
        xₙ₊₁ = f(xₙ)
        push!(x_array,xₙ,xₙ₊₁)
        push!(y_array,xₙ₊₁,xₙ₊₁)
        xₙ = xₙ₊₁
    end
    return x_array, y_array
end

"""
Se grafica una función dada de la forma f(x) = x² - b, se toma a [-b, b] como el intervalo de graficación, también
se grafica la función identidad y = x, y dados dos arreglos generados por la función ´iteramapeo´ se grafican las trayectorias
generadas por dichos arreglos, que debieron tomar como función y condición inicial, las mismas que se utilizan aquí.
"""
function dibujartrayectoria(f::Function, b::Number, x₀::Number, x_array::Array, y_array::Array)
    x = -b:0.01:b
    plot(x, f.(x), label = "f₁(x) = x² - $b", size=(950,500), lw = 2)
    plot!(x, x, label = "f₂(x) = x", lw = 3)
    xlabel!("xₙ")
    ylabel!("xₙ₊₁")
    plot!(x_array, y_array, lw = 1, label = "Trayectoria", ls=:dash)
    scatter!([x₀], [f(x₀)], label = "Condición inicial")
end

"""
Se usan las funciones ´iteramapeo´ y ´dibujartrayectoria´ para generar la figura con la convergencia
de una condición inicial hacia un punto fijo de un mapeo dado. La iteración termina hasta que los 
resultados de iterar convergan entre sí a cierta distancia dada.
"""
function trayectoria(f::Function, b::Number, x₀::Number)
    x_array, y_array = iteramapeo(f, x₀)
    dibujartrayectoria(f, b, x₀, x_array, y_array)
end

"""
Se usan las funciones ´iteramapeo´ y ´dibujartrayectoria´ para generar la figura con la convergencia
de una condición inicial hacia un punto fijo de un mapeo dado. La iteración termina hasta completar un
número de iteraciones dado.
"""
function trayectoria(f::Function, b::Number, x₀::Number, n_iteraciones::Int)
    x_array, y_array = iteramapeo(f, x₀, n_iteraciones)
    dibujartrayectoria(f, b, x₀, x_array, y_array)
end

"""
Creamos un histograma con los resultados de las iteraciones dadas por la función ´iteramapeo´
"""
function dibujarhistograma(y_array::Array, b::Number)
    histogram(y_array, bins=100, title="Histograma de frecuencias para f(x)=x² - $b", label=false, normed=true)
end

"""
Se usan las funciones ´iteramapeo´ y ´dibujarhistograma´ para obtener los resultados de la iteración del 
mapeo dado de la forma f(x) = x^2 -b con cierta condición inicial dada y un número de iteraciones, y de este
modo poder dibujar un histograma normalizado con los resultados de haber iterado el mapeo mencionado.
"""
function histograma(f::Function, b::Number, x₀::Number, n_iteraciones::Int)
    _ , y_array = iteramapeo(f, x₀, n_iteraciones)
    dibujarhistograma(y_array[3:end], b)
end

# Definimos el mapeo y nuestra condición inicial
b = 2
f(x) = x^2 - b
x₀ = 0.4
n_iteraciones = 100
trayectoria_1 = trayectoria(f, b, x₀, n_iteraciones)

n_iteraciones = 2000
histograma(f, b, x₀, n_iteraciones)

# (b) Repitan el ejercicio anterior pero considerando muchas condiciones iniciales, pero pocos iterados (~50).

"""
Se usan las funciones ´iteramapeo´ y ´dibujarhistograma´ para obtener los resultados de la iteración del 
mapeo dado de la forma f(x) = x^2 -b con un arreglo de condiciones iniciales dado y un número de iteraciones, y de este
modo poder dibujar un histograma normalizado con los resultados de haber iterado el mapeo mencionado.
"""
function histograma(f::Function, b::Number, x₀::Array, n_iteraciones::Int)
    _, big_array = iteramapeo(f, x₀[1], n_iteraciones)
    big_array = big_array[3:end]
    for x_0 in x₀[2:end]
        _, y_array = iteramapeo(f, x_0, n_iteraciones)
        append!(big_array, y_array[3:end])
    end
    dibujarhistograma(big_array, b)
end

# Definimos un intervalo de condiciones iniciales válido.
n_condiciones_iniciales = 40
n_iteraciones = 50
x₀ = 2b .* (rand(n_condiciones_iniciales)) .- b
histograma(f, b, x₀, n_iteraciones)

# (c) ¿Qué conclusión podemos sacar de los histogramas en ambos casos?

# Observamos que con muchas iteraciones y una condición inicial recorremos el espacio más _uniforme_ que
# con varias condiciones iniciales y pocas iteraciones. Observamos que hay un umbral donde al cierto número 
# más grande de condiciones inicales en el inciso b, se vuelve más uniforme. Sin embargo, se ocupan más recursos 
# y tiempo con un número de operaciones similares.

# # Ejercicio 2

# a) Usando lo que hicieron en la Tarea 1, incluyan lo que desarrollaron para los números `Dual`es en un módulo que 
# llamaremos `NumDual` de Julia ([ver la documentación aquí](https://docs.julialang.org/en/v1/manual/modules/)). 
# En particular, el módulo debe exportar el tipo `Dual` y la función `var_dual`, al menos. El archivo con el módulo 
# lo deben incluir en un archivo ".jl" en su propio directorio de tareas. Carguen el módulo en este notebook, usando
# ```
# include("nombre_archivo.jl")
# using NumDual
# ```

include("duales.jl")
using .NumDual

# b) Escriban una función que implemente el método de Newton para funciones en una dimensión. La derivada que se requiere
# debe ser calculada a través de los números duales. Obtengan usando esta implementación un cero de $f(x) = x^3 - 8$, para
# verificar que su implementación funciona.

"""
Método de Newton-Raphson numérico utilizando diferenciación automática con números duales. Recibe
una función, una condición inicial y un número de iteraciones como argumentos.

# Ejemplos

```julia-repl
julia> metodonewton(x -> x^2 - 2., 2.3, 30)
1.4142135623730951

julia> metodonewton(x -> x - 2, 0.1, 30)
2.0
```
"""
function metodonewton(func::Function , x₀::Number, n_iteraciones::Int)
    xₙ = x₀
    xₙ₊₁ = 0.
    for _ in 1:n_iteraciones
        xd = NumDual.vardual(xₙ)
        f_dual = func(xd)
        g, g′ = f_dual.fun, f_dual.der
        xₙ₊₁ = xₙ - g / g′
        xₙ = xₙ₊₁
    end
    xₙ₊₁ = isapprox(xₙ₊₁, 0.0, atol=0.000001) ? 0.0 : xₙ₊₁
    return xₙ₊₁
end

# Definimos el mapeo, las condiciones iniciales y el número de iteraciones
f(x) = x^3 - 8.
x₀ = 2.3
n_iteraciones = 30
raiz = metodonewton(f, x₀, n_iteraciones)

@test f(raiz) == 0.

# (c) Encuentren *todos* los puntos fijos del mapeo $F(x) = x^2 - 1.1$ usando la función que implementaron para el método 
# de Newton.

# Definimos el mapeo y luego la función para encontrar puntos fijos.
F(x) = x^2 - 1.1
G(x) = F(x) - x

# #Definimos condiciones iniciales y número de iteraciones para la primera raiz.
x₀₁ = 10.
n_iteraciones = 30
raiz_1 = metodonewton(G, x₀₁, n_iteraciones)

# Definimos una condición inicial distinta para encontrar la otra raiz.
x₀₂ = -0.1
raiz_2 = metodonewton(G, x₀₂, n_iteraciones)

# (d) Encuentren los puntos *de periodo 2* para el mapeo $F(x) = x^2 - 1.1$ usando la función que implementaron para el 
# método de Newton.


"""
Función para encontrar raices de un mapeo G pero evitando raices anteriores que se le pasan como un arreglo, esto
con el fin de filtrar los puntos fijos de anteriores periodos.
Se generan condiciones iniciales aleatorias para encontrar el mayor número de raíces posibles.

# Ejemplo

```julia-repl
julia> findroots(x -> ((x^2)-1.1)^2 - 1.1 - x, [1.661895003862225, -0.6618950038622251], 30)
2-element Vector{Float64}:
 -1.0916079783099617
  0.0916079783099617
```
"""
function findroots(G::Function, puntos_fijos_anteriores::Vector, n_iteraciones::Int, n_condiciones_iniciales::Int = 100)
    roots = Float64[]
    for x_0 in 10*rand(n_condiciones_iniciales) .- 5
        raiz = metodonewton(G, x_0, n_iteraciones)
        if isempty(roots)
            push!(roots, raiz)
        else
            counter = 0
            for root in roots
                if root ≈ raiz
                    continue
                else
                    counter += 1
                end
            end
            if counter == length(roots)
                if sum(raiz .≈ puntos_fijos_anteriores) == 0
                    push!(roots, raiz)
                else
                    continue
                end
            end
        end
    end
    return roots
end

# Se genera el mapeo del cual conocer los puntos fijos y cuántas veces iteraremos en el método de Newton.
n_iteraciones = 30
G₂(x) = F(F(x)) - x
puntos_fijos_anteriores = [raiz_1, raiz_2]
puntos_periodo_2 = findroots(G₂, puntos_fijos_anteriores, n_iteraciones)

# (e) Usen los números duales para mostrar que los puntos de periodo 2 para el mapeo $F(x) = x^2 -1$ son linealmente
# estables (atractivos).

"""
Función para encontrar raices de un mapeo G.
Se generan condiciones iniciales aleatorias para encontrar el mayor número de raíces posibles.
"""
function findroots(G::Function, n_iteraciones::Int, n_condiciones_iniciales::Int = 100)
    roots = Float64[]
    for x_0 in 2*rand(n_condiciones_iniciales)
        raiz = metodonewton(G, x_0, n_iteraciones)
        raiz = isapprox(raiz, 0.0, atol=0.000001) ? 0.0 : raiz
        if isempty(roots)
            push!(roots, raiz)
        else
            if iszero(sum(isapprox.(raiz, roots, atol = 0.000001)))
                push!(roots, raiz)
            end
        end
    end
    return roots
end

"""
Función para poder generalizar y no tener que insertar las raices de periodos anteriores.
"""
function puntosperiodon(f, n, n_iteraciones = 30)
    roots = []
    puntos_anteriores_periodos = []
    for i = 1:n
        Qn = c -> ∘([f for _ in 1:i]...)(c) - c
        roots = findroots(Qn, n_iteraciones)
        if i != n
            append!(puntos_anteriores_periodos, roots)
        end
    end
    puntos_periodo_n = []
    for root in roots
        if length(puntos_anteriores_periodos) > 0
            if iszero(sum(isapprox.(root, puntos_anteriores_periodos)))
                push!(puntos_periodo_n, root)
            end
        else
            puntos_periodo_n = roots
        end
    end
    return puntos_periodo_n
end

n_iteraciones = 3000
F₁(x) = x^2 - 1.
puntos_periodo_2 = puntosperiodon(F₁, 2)

for xₙ in puntos_periodo_2
    xd = NumDual.vardual(xₙ)
    f_dual = F₁(F₁(xd))
    @show xₙ, f_dual.der
end

# Al evaluar los puntos de periodo 2 en la derivada de la función, vemos que todo es, en valor absoluto, menor que 1. Más aún, 
# son iguales a cero! Lo que significa que sería un _mínimo_ o un _máximo_.

# # Ejercicio 3

# Llamaremos $c_n$ al valor del parámetro $c$ para el mapeo cuadrático
# $Q_c(x) = x^2-c$, donde ocurre el ciclo superestable de periodo $2^n$,
# esto es, el valor de $c$ tal que $x_0=0$ pertenece a la órbita
# periódica de periodo $2^n$.
# Algunos de estos valores fueron obtenidos numéricamente en clase; esto puede
# servir como test inicial.

# - Calculen los valores de $c_r$, al menos hasta $c_6$; traten
# de obtener aún más. Con estos valores, definimos la secuencia:
# $\{f_0, f_1, f_2, \dots\}$, donde
# \begin{equation*}
# f_n = \frac{c_n-c_{n+1}}{c_{n+1}-c_{n+2}} .
# \end{equation*}
# Aproximen el valor al que converge esta secuencia,
# es decir, dar una estimación de $\delta = f_\infty$.

# #Definimos el mapeo original
Q(x, c) = x^2 - c

"""
Definimos la composición del mapeo Q bajo un número dado de composiciones.

# Ejemplos

```julia-repl
julia> Qn(0., 2., 2)
2.0

julia> Qn(1., 3., 4)
1.0
```
"""
function Qn(x,c,n_composiciones)
    x₀ = x
    for i = 1:n_composiciones
        x₁ = Q(x₀, c)
        x₀ = x₁
    end
    return x₀
end

"""
Mediante el método de Newton encontramos la raíz de una función pero filtrando en caso
de ya haber obtenido esa raíz a partir de un arreglo. La condición inicial para
el método de Newton se va obteniendo incrementando el valor de la condición
inicial tomando la distnacia entre las últimas dos condiciones inicales y dividiendo
entre 4.
"""
function findfirstroot(f::Function, anteriores_raices::Array; n_iteraciones::Int=30)
    last_root = anteriores_raices[end]
    if length(anteriores_raices) == 1
        step = anteriores_raices[1] + 1
    else
        step = last_root + (last_root - anteriores_raices[end-1])/4
    end
    x_0 = step
    root = last_root
    while sum(isapprox.(root, anteriores_raices, atol = 0.000001)) > 0
        root = metodonewton(f, x_0, n_iteraciones)
        x_0 += step
    end
    return root
end

"""
Utiliza las funciones ´findroots´ y ´findroots´ para encontrar los puntos fijos
del mapeo Qn compuesto un número n de veces dado. Se tiene que poner las raíces 
anteriores para no repetir suponiendo un perido anterior.
"""
function findcn(n::Int, anteriores_raices::Array; n_iteraciones::Int=300)
    if length(anteriores_raices) < 1
        return findroots(c -> Qn(0.0, c, 2^n), n_iteraciones)
    else
        return findfirstroot(c -> Qn(0.0, c, 2^n), anteriores_raices, n_iteraciones=n_iteraciones)
    end
end


"""
Se hace uso de la función ´findcn´ para encontrar las raíces del mapeo Qn
variando el valor de c e iterando sobre distintos periodos. Como un punto crítico de 
periodo n es igual de periodo 2n, entonces vamos guardando los puntos críticos que 
encontramos para así no repetir en las iteraciones posteriores.

# Ejemplos

```julia-repl
julia> findallcn(2)
3-element Vector{Float64}:
 0.0
 1.0
 1.3107026413368328

julia> findallcn(4)
5-element Vector{Float64}:
 0.0
 1.0
 1.3107026413368328
 1.3815474844320617
 1.3969453597045602
```
"""
function findallcn(ns::Int; n_iteraciones::Int=300)
    anterior = Float64[]
    for n = 0:ns
        cn = findcn(n, anterior; n_iteraciones)
        push!(anterior, cn[1])
    end
    return anterior
end

n = 9
cns = findallcn(n)
fn = [(cns[i] - cns[i+1]) / (cns[i+1] - cns[i+2]) for i = 1:length(cns)-2]

# Observamos que tiene a un valor cercano a 4.669.

# El valor $f_{n}$ tiende a una constante cuando $n \rightarrow \infty$.

# - De los $2^p$ puntos del ciclo de periodo $2^p$, es decir,
# $\{0, p_1, \dots p_{2^{n-1}}\,\}$ hay uno (*distinto del 0*) cuya distancia
# a 0 es la menor; a esa distancia la identificaremos como $d_n$.
# Estimen numéricamente a qué converge la secuencia
# \begin{equation*}
# \alpha = - d_n/d_{n+1},
# \end{equation*}
# en el límite de $n$ muy grande.

# Habrá que hacer prácticamente lo mismo que hicimos arriba, pero ahora en lugar de tener a c como la variable, más bien será x.

"""
Obtenemos las raíces estables de un mapeo utilizando la propiedad de la primera derivada.
"""
function stableroots(f::Function, x::Array)
    xd = NumDual.vardual.(x)
    f_duals = f.(xd)
    f′ = [f_dual.der for f_dual in f_duals]
    f′ = f′[x .< 0.5]
    x = x[x .< 0.5]
    stables = x[(abs.(f′) .≈ 1) .|| abs.(f′) .> 1. ]
    return stables
end

"""
De entre un arreglo se devuelve el número más cercano a un valor dado.
"""
findnearest(A::Vector,x::Real) = findmin(abs.(A .- x))[2]

function findsmallestroot(f::Function, n_condiciones_iniciales::Int=300; n_iteraciones::Int=30)
    x0 = 2*rand(n_condiciones_iniciales)
    roots = union(metodonewton.(f, x0, n_iteraciones))
    roots = filter(n -> !(n ≈ 0), roots)
    stable_roots = stableroots(f, roots)
    root = stable_roots[findnearest(stable_roots, 0.)]
    return root
end

"""
Para encontrar una raíz de un mapeo dado. Teniendo en cuenta una condición inicial
y el periodo.
"""
function findxn(cns::Array, n::Int, anteriores_raices::Array; n_iteraciones::Int=300)
    if length(anteriores_raices) < 1
        return findroots(x -> Qn(x, 0.0, 2^n), n_iteraciones)
    else
        return findsmallestroot(x -> Qn(x, cns[n+1], 2^n) - x, n_iteraciones=n_iteraciones)
    end
end

"""
Para encontrar todas las raíces del mapeo pero ahora respecto a x.
"""
function findallxn(cns::Array, ns::Int; n_iteraciones::Int=300)
    raices = Float64[]
    for n = 0:ns
        xn = findxn(cns, n, raices; n_iteraciones)
        push!(raices, xn[1])
    end
    return raices
end

xns = findallxn(cns, n)

α = [-xns[i]/xns[i+1] for i = 1:length(xns)-1]

# Observamos que tiende a `2.5029`.