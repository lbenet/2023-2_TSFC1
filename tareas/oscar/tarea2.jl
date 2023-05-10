# Tarea 2

using Plots, Test

# > Fecha de envío:
# >
# > Fecha de aceptación:
# >

## Ejercicio 1

# (a) Consideren el mapeo $F(x) = x^2-2$ definido en $-2 \leq x \leq 2$. A partir de una condición inicial tomada al azar, 
# construyan una órbita muy larga, por ejemplo, de $20\,000$ iterados, o más. Obtengan el histograma de frecuencias 
# (normalizado) de los puntos que la órbita visita.

function trayectoria(f::Function, b::Number, x₀::Number)
    x_array, y_array = iteramapeo(f, x₀)
    dibujartrayectoria(f, b, x₀, x_array, y_array)
end

function trayectoria(f::Function, b::Number, x₀::Number, n_iteraciones::Int)
    x_array, y_array = iteramapeo(f, x₀, n_iteraciones)
    dibujartrayectoria(f, b, x₀, x_array, y_array)
end
    
function histograma(f::Function, b::Number, x₀::Number, n_iteraciones::Int)
    _ , y_array = iteramapeo(f, x₀, n_iteraciones)
    dibujarhistograma(y_array[3:end], b)
end

function histograma(f::Function, b::Number, x₀::Array, n_iteraciones::Int)
    _, big_array = iteramapeo(f, x₀[1], n_iteraciones)
    big_array = big_array[3:end]
    for x_0 in x₀[2:end]
        _, y_array = iteramapeo(f, x_0, n_iteraciones)
        append!(big_array, y_array[3:end])
    end
    dibujarhistograma(big_array, b)
end

function iteramapeo(f::Function, x₀::Number)
    ϵ = 0.001
    r = Inf
    xₙ = x₀

    x_array = [x₀]
    y_array = [0.]
    while r > ϵ
        xₙ₊₁ = f(xₙ)
        r = abs(xₙ₊₁ - xₙ)
        push!(x_array,xₙ,xₙ₊₁)
        push!(y_array,xₙ₊₁,xₙ₊₁)
        xₙ = xₙ₊₁
    end
    return x_array, y_array
end

function iteramapeo(f::Function, x₀::Number, n_iteraciones::Int)
    ϵ = 0.001
    r = Inf
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

function dibujartrayectoria(f::Function, b::Number, x₀::Number, x_array::Array, y_array::Array)
    x = -b:0.01:b
    plot(x, f.(x), label = "f₁(x) = √x", size=(950,500), lw = 2)
    plot!(x, x, label = "f₂(x) = x", lw = 3)
    xlabel!("xₙ")
    ylabel!("xₙ₊₁")
    plot!(x_array, y_array, lw = 1, label = "Trayectoria", ls=:dash)
    scatter!([x₀], [f(x₀)], label = "Condición inicial")
end

function dibujarhistograma(y_array::Array, b::Number)
    y_visitas = (y_array[1:2:end] .+ b) ./ (2b)
    #y_visitas = y_array[1:2:end]
    histogram(y_visitas, bins=100, title="Histograma de frecuencias para f(x)=x² - $b", label=false)
end

b = 2
f(x) = x^2 - b
x₀ = 0.4
n_iteraciones = 100
trayectoria_1 = trayectoria(f, b, x₀, n_iteraciones)

n_iteraciones = 2000
histograma(f, b, x₀, n_iteraciones)

# (b) Repitan el ejercicio anterior pero considerando muchas condiciones iniciales, pero pocos iterados (~50).

n_condiciones_iniciales = 40
n_iteraciones = 50
x₀ = 2b .* (rand(n_condiciones_iniciales)) .- b
histograma(f, b, x₀, n_iteraciones)

# (c) ¿Qué conclusión podemos sacar de los histogramas en ambos casos?

# Observamos que con muchas iteraciones y una condición inicial recorremos el espacio más _uniforme_ que
# con varias condiciones iniciales y pocas iteraciones.

# ## Ejercicio 2

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

function metodonewton(func, x₀, n_iteraciones)
    xₙ = x₀
    xₙ₊₁ = 0.
    for _ in 1:n_iteraciones
        xd = NumDual.vardual(xₙ)
        f_dual = func(xd)
        g, g′ = f_dual.fun, f_dual.der
        xₙ₊₁ = xₙ - g / g′
        xₙ = xₙ₊₁
    end
    
    return xₙ₊₁
end

f(x) = x^3 - 8.
x₀ = 2.3
n_iteraciones = 30
raiz = metodonewton(f, x₀, n_iteraciones)

@test f(raiz) == 0.

# (c) Encuentren *todos* los puntos fijos del mapeo $F(x) = x^2 - 1.1$ usando la función que implementaron para el método 
# de Newton.

F(x) = x^2 - 1.1
G(x) = F(x) - x

x₀₁ = 10.
n_iteraciones = 30
raiz_1 = metodonewton(G, x₀₁, n_iteraciones)

x₀₂ = -0.1
raiz_2 = metodonewton(G, x₀₂, n_iteraciones)

# (d) Encuentren los puntos *de periodo 2* para el mapeo $F(x) = x^2 - 1.1$ usando la función que implementaron para el 
# método de Newton.

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

n_iteraciones = 30
G₂(x) = ∘([F for _ in 1:2]...)(x) - x
puntos_fijos_anteriores = [raiz_1, raiz_2]
puntos_periodo_2 = findroots(G₂, puntos_fijos_anteriores, n_iteraciones)

# (e) Usen los números duales para mostrar que los puntos de periodo 2 para el mapeo $F(x) = x^2 -1$ son linealmente
# estables (atractivos).

function findroots(G::Function, n_iteraciones::Int, n_condiciones_iniciales::Int = 100)
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
                push!(roots, raiz)
            end
        end
    end
    return roots
end

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
            if sum(isapprox.(root, puntos_anteriores_periodos)) == 0
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

## Ejercicio 3

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

Q(x, c) = x^2 - c

function Qn(x,c,n_composiciones)
    x₀ = x
    for i = 1:n_composiciones
        x₁ = Q(x₀, c)
        x₀ = x₁
    end
    return x₀
end

function findfirstroot(f::Function, anteriores_raices::Array; n_iteraciones::Int=30)
    last_root = anteriores_raices[end]
    if length(anteriores_raices) == 1
        step = anteriores_raices[1] + 1
    else
        step = last_root + (last_root - anteriores_raices[end-1])/4
    end
    x_0 = step
    #@show step
    root = last_root
    while sum(root .≈ anteriores_raices) > 0
        root = metodonewton(f, x_0, n_iteraciones)
        #@show x_0, root
        x_0 += step
    end
    return root
end

function findcn(n::Int, anteriores_raices::Array; n_iteraciones::Int=300)
    if length(anteriores_raices) < 1
        #println("Nos encontramos en el caso donde n = 0")
        return findroots(c -> Qn(0.0, c, 2^n), n_iteraciones)
    else
        return findfirstroot(c -> Qn(0.0, c, 2^n), anteriores_raices, n_iteraciones=n_iteraciones)
    end
end

function findallcn(ns::Int; n_iteraciones::Int=300)
    anterior = Float64[]
    for n = 0:ns
        cn = findcn(n, anterior; n_iteraciones)
        push!(anterior, cn[1])
    end
    return anterior
end

findallcn(8)

n = 12
cns = findallcn(n)
fn = [(cns[i] - cns[i+1]) / (cns[i+1] - cns[i+2]) for i = 1:length(cns)-2]

plot(1:n-1, fn)

# El valor $f_{n}$ tiende a una constante cuando $n \rightarrow \infty$.

# - De los $2^p$ puntos del ciclo de periodo $2^p$, es decir,
# $\{0, p_1, \dots p_{2^{n-1}}\,\}$ hay uno (*distinto del 0*) cuya distancia
# a 0 es la menor; a esa distancia la identificaremos como $d_n$.
# Estimen numéricamente a qué converge la secuencia
# \begin{equation*}
# \alpha = - d_n/d_{n+1},
# \end{equation*}
# en el límite de $n$ muy grande.

α = [-cns[i]/cns[i+1] for i = 1:length(cns)-1]
