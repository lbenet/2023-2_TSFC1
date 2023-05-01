# # Tarea 1: Números duales

# Antes de describir los *números duales* recordaremos primero algunas propiedades de los números complejos.
# Los números complejos los podemos entender como una *pareja ordenada* $z=(x, y)$ que algebraicamente escribimos 
# $z = x +i y$, donde $x,y\in\mathbb R$, con la propiedad de que el *número* $i$ satisface $i^2 = -1$. Decimos que 
# $x$ es la *parte real* de $z$, y que $y$ es su *parte imaginaria*.
# Con estas definiciones, podemos extender las operaciones aritméticas al igual que las funciones elementales de 
# manera sencilla, simplemente explotando el álgebra y además $i^2=-1$.

# De manera similar, uno puede definir al *par ordenado* $\overleftrightarrow{x} = (x, x^\prime) = x + \epsilon x^\prime$, 
# con $x, x^\prime \in \mathbb R$, y donde el *número* $\epsilon$ lo definimos con la propiedad $\epsilon^2=0$. 
# Es fácil pues convencerse que estas estructuras, que llamaremos *números duales*, cumplen:

# \begin{eqnarray}
# (x + \epsilon x^\prime) \pm (y + \epsilon y^\prime) & = & (x\pm y) + \epsilon (x^\prime\pm y^\prime),\\
# (x + \epsilon x^\prime) \cdot (y + \epsilon y^\prime) & = & (x\cdot y) + \epsilon (xy^\prime+y x^\prime).
# \end{eqnarray}

# Llamaremos a $x$ la *parte principal* y a $x^\prime$ la *parte derivada* de $\overleftrightarrow{x}$.

# ## Ejercicio 1

# - A partir de $\overleftrightarrow{z} \cdot \overleftrightarrow{y} = \overleftrightarrow{x}$,
# y usando la definición del producto entre duales, obtener la expresión para
# $\overleftrightarrow{z} = \overleftrightarrow{x} / \overleftrightarrow{y}$.
# Es decir, obtener
# qué son $z$ y $z^\prime$ en términos de las componentes de $\overleftrightarrow{x}$ y
# $\overleftrightarrow{y}$.

# Al desarrollar la ecuación $\overleftrightarrow{z} \cdot \overleftrightarrow{y} = \overleftrightarrow{x}$ tenemos los siguiente:
# $$
# \overleftrightarrow{z} \cdot \overleftrightarrow{y} = zy + \epsilon (zy^\prime + yz^\prime ) = x + \epsilon x^\prime
# $$
# De donde podemos deducir que 
# \begin{eqnarray}
# zy & = & x \\
# zy^\prime + yz^\prime & = & x^\prime
# \end{eqnarray}

# Y así, al sustituir y despejar $z$ y $z^\prime$ tenemos que

# \begin{eqnarray}
# z & = & \dfrac{x}{y}\\
# z^\prime & = & \dfrac{x^\prime y - xy^\prime}{y^{2}}
# \end{eqnarray}

# - De la expresión obtenida (y de las fórmulas anteriores), ¿qué podemos decir
# (concluir o interpretar) sobre qué representa de $z^\prime$?

# La forma de $z^\prime$ recuerda mucho a la derivada de una división. Y analizando 
# los demás resultados, el nombre de <i>parte derivada de $\overleftrightarrow{z}$</i> resulta justamente de esta propiedad.

# ## Ejercicio 2

# - Definir una estructura (`struct`) `Dual` que represente a los números duales; los nombres de los campos serán `fun` y `der`. 
# Por sencillez, pueden considerar que los campos de `Dual` son del tipo `Float64`, aunque pueden *osar* y tratar de implementar el caso 
# paramétrico `Dual{T <: Real}`, donde `T` es el tipo de *ambos* campos.

"""
Creamos nuestra propia estructura dual, la cual recibe dos argumentos parametrizados por el mismo tipo de dato.
"""
struct Dual{T<: Number}
    fun::T
    der::T
end

# - Sobrecargar las operaciones de tal manera que las cuatro operaciones aritméticas que involucrena dos `Dual`-es, den el resultado que se espera.

import Base.+, Base.-, Base.*, Base./

"""
Sobrecargamos la operación de suma (`+`) para dos números `Duales`. La operación que se realiza es la siguiente:

Dual(x₁, x₂) + Dual(y₁,y₂) = Dual(x₁+y₁, x₂+y₂)

# Ejemplos

```julia-repl
julia> Dual(1,3) + Dual(4, 5)
Dual(5, 8)

julia> Dual(8,4) + Dual(-2, 0)
Dual(6, 4)
```
"""
+(x::Dual, y::Dual) = Dual(x.fun + y.fun, x.der + y.der)

"""
Sobrecargamos la operación de resta (`-`) para dos números `Duales`. La operación que se realiza es la siguiente:

Dual(x₁, x₂) - Dual(y₁,y₂) = Dual(x₁-y₁, x₂-y₂)

# Ejemplos

```julia-repl
julia> Dual(1,3) - Dual(4, 5)
Dual(-3, -2)

julia> Dual(4,5) - Dual(1, 3)
Dual(3, 2)
```
"""
-(x::Dual, y::Dual) = Dual(x.fun - y.fun, x.der - y.der)

"""
Sobrecargamos la operación de multiplicación (`*`) para dos números `Duales`. La operación que se realiza es la siguiente:

Dual(x₁, x₂) * Dual(y₁,y₂) = Dual(x₁*y₁, x₁*y₂ + y₁*x₂)

# Ejemplos

```julia-repl
julia> Dual(1,3) * Dual(4, 5)
Dual(4, 17)

julia> Dual(-2,5) * Dual(1, 3)
Dual(-2, -1)
```
"""
*(x::Dual, y::Dual) = Dual(x.fun * y.fun, x.fun * y.der + y.fun * x.der)

"""
Sobrecargamos la operación de división (`/`) para dos números `Duales`. La operación que se realiza es la siguiente:

Dual(x₁, x₂) / Dual(y₁,y₂) = Dual(x₁/y₁, (y₁*x₂ - x₁*y₂)/ y₁²)

# Ejemplos

```julia-repl
julia> Dual(1,3) / Dual(4, 5)
Dual(0.25, 0.4375)

julia> Dual(1,18) / Dual(2, 9)
Dual(0.5, 6.75)
```
"""
/(x::Dual, y::Dual) = Dual(x.fun / y.fun, (y.fun * x.der - x.fun * y.der)/y.fun^2)

# - Definan un método específico para crear duales (constructor externo), a partir de un
# sólo valor (en lugar de los dos requeridos), y que corresponderá a
# $\overleftrightarrow{x_0} = (x_0, 0)$. ¿Es el *0* de esta definición, o sea, $x_0^\prime=0$,
# compatible con la interpretación que dieron en el ejercicio anterior para la parte derivada?

"""
Definimos un Dual con un sólo real, en donde la parte derivada se hace 0 automáticamente.

# Ejemplos

```julia-repl
julia> Dual(3.)
Dual(3.0, 0.0)
```
"""
Dual(x::Real) = Dual(x,0.)

# Es compatible en el sentido de que es como si estuviéramos tomando la derivada de una constante, 
# la cuál sabemos que es 0.

# - Extiendan los métodos que permitan sumar/restar y multiplicar/dividir un número (`::Real`) y
# un `::Dual`. (Recuerden que ciertas operaciones son conmutativas!).
# NOTA: Este ejercicio lo pueden hacer escribiendo todos los métodos, uno a uno. Otra
# opción es usar `promote` y `convert` para definir reglas de promoción y conversión;
# [la documentación](https://docs.julialang.org/en/v1/manual/conversion-and-promotion/)
# tiene más información, por si este camino les interesa.

import Base.promote

"""
Definimos la promoción de un real a un Dual.

# Ejemplos

```julia-repl
julia> promote(1, Dual(1.,3))
(Dual(1.0,0.0), Dual(3.0, 0.0))
```
"""
promote(a::Number, x::Dual) = (Dual(a), x)

"""
Definimos la promoción de un real a un Dual.

# Ejemplos

```julia-repl
julia> promote(Dual(1.,3.), 1.)
(Dual(1.0, 3.0), Dual(1.0,0.0))
```
"""
promote(x::Dual, a::Number) = (x, Dual(a))

"""
Definimos las operaciones +, -, *, / para un real con un Dual con algo de metaprogramación, aplica la operación por ambos lados.

# Sustituimos la siguiente forma de hacerlo:

```julia
+(x::Number, y::Dual) = +(promote(x,y)...)
+(x::Dual, y::Number) = +(promote(x,y)...)

-(x::Number, y::Dual) = -(promote(x,y)...)
-(x::Dual, y::Number) = -(promote(x,y)...)

*(x::Number, y::Dual) = *(promote(x,y)...)
*(x::Dual, y::Number) = *(promote(x,y)...)

/(x::Number, y::Dual) = /(promote(x,y)...)
/(x::Dual, y::Number) = /(promote(x,y)...)
```
"""
function promocion(operacion)
    """
    $(operacion)(x::Number, y::Dual) = $(operacion)(promote(x,y)...); $(operacion)(x::Dual, y::Number) = $(operacion)(promote(x,y)...)
    """
end

operaciones = ["+", "-", "*", "/"]
for operacion in operaciones
    eval(Meta.parse(promocion(operacion)))
end

# - Definan las funciones `fun` y `der` que, al ser aplicadas a un `Dual` devuelvan la parte principal y 
# la parte derivada del `Dual`.

"""
Función que al ser aplicada a un Dual nos devuelve su parte principal.

# Ejemplos
```julia-repl
julia> fun(Dual(1.,3.))
1.0

julia> fun(Dual(10.4,3.2))
10.4
```
"""
function fun(x::Dual)
    x.fun
end


"""
Función que al ser aplicada a un Dual nos devuelve su parte derivada.

```julia-repl
julia> der(Dual(1.,3.))
3.0

julia> der(Dual(10.4,3.2))
3.2
```
"""
function der(x::Dual)
    x.der
end

# - Incluyan varios casos (propuestos por ustedes mismos) donde se *compruebe* que lo que
# implementaron da el resultado que debería ser. Para esto, pueden usar la librería
# estándard [`Test`](https://docs.julialang.org/en/v1/stdlib/Test/) de Julia.

@test Dual(4.,8.) + 3. == 3. + Dual(4., 8.) == Dual(3. + 4.,8.)
@test 2. - Dual(3.,6.)  == Dual(2. - 3.,0. - 6.)
@test Dual(3.,6.) - 2.  == Dual(3. - 2.,6.)
@test Dual(-4.,3.) / 3. == Dual(-4. /3., (3. *3. - (-4.)*0.) / 3. ^ 2)
@test 3. / Dual(-4.,3.) == Dual(3. /(-4.), (0. *(-4.) - 3. *3.)/(-4.)^2)
@test der(Dual(1,6)) == Dual(1,6).der
@test fun(Dual(1,6)) == Dual(1,6).fun

# ## Ejercicio 3

# Definan una nueva función `vardual(x_0)` cuyo resultado sea un `Dual` cuya parte
# principal es `x_0` y cuya parte derivada sea tal que `xd = vardual(x_0)` *represente*
# a la variable independiente $x$ (en $x_0$). La idea es que debe representar
# la parte derivada del dual `xd` que regresa `xd = vardual(x_0)`. Con esta función
# evalúen `g(xd)` donde
# $$
# g(x) = \frac{3x^2-8x+1}{7x^3-1}.
# $$

"""
Definimos la función `vardual`, la cual nos sirve para crear valores de `x` como variables independientes.

```julia-repl
julia> vardual(3.)
Dual(3.0, 1.0)
```
"""
vardual(x₀::Float64) = Dual(x₀, 1.)

# A continuación la evaluación en la función indicada con sus pruebas

x_0 = 5.3
xd = vardual(x_0)

# Definimos la función `g` pero sólo con las funciones que ya hemos definido y de la manera en que las hemos definido.
g(x) = (3.0x*x - 8.0x + 1.)/(7.0x*x*x - 1.)

# Definimos la derivada a mano para poder evaluarla en el test
g′(x) = ((7.0x*x*x - 1.)*(6.0x - 8.) - (3.0x*x - 8.0x + 1.)*(21.0x*x))/((7.0x*x*x - 1.)*(7.0x*x*x - 1.))

@test g(xd) == Dual(g(x_0), g′(x_0))

# ## Ejercicio 4

# - A partir de la interpretación que han hecho para la parte derivada (último inciso del Ejercicio 1), y *generalizando* 
# esa interpretación de qué representa cada campo y en particular el segundo de `Dual`, *extiendan* las funciones 
# `sin(a::Dual)`, `cos(a::Dual)`, `tan(a::Dual)`, `^(a::Dual, n::Int)`, `sqrt(a::Dual)`, `exp(a::Dual)` y `log(a::Dual)`.

import Base.sin, Base.cos, Base.tan, Base.^, Base.sqrt, Base.exp, Base.log

"""
Sobrecargamos la operación de seno (`sin`) para un número `Dual`. La operación que se realiza es la siguiente:

sin(Dual(x₁, x₂)) = Dual(sin(x₁), x₂*cos(x₁))

# Ejemplos

```julia-repl
julia> sin(Dual(3.1416, 3.1416))
Dual(-7.346410206643587e-6, -3.141599999915224)

julia> sin(Dual(3.1416, 3.1416/2))
Dual(-7.346410206643587e-6, -1.570799999957612)
```
"""
sin(x::Dual) = Dual(sin(x.fun), x.der*cos(x.fun))

"""
Sobrecargamos la operación de coseno (`cos`) para un número `Dual`. La operación que se realiza es la siguiente:

cos(Dual(x₁, x₂)) = Dual(cos(x₁), -x₂*sin(x₁))

# Ejemplos

```julia-repl
julia> cos(Dual(3.1416, 3.1416))
Dual(-0.9999999999730151, 2.3079482305191492e-5)

julia> cos(Dual(3.1416, 3.1416/2))
Dual(-0.9999999999730151, 1.1539741152595746e-5)
```
"""
cos(x::Dual) = Dual(cos(x.fun), -x.der*sin(x.fun))

"""
Sobrecargamos la operación de tangente (`tan`) para un número `Dual`. La operación que se realiza es la siguiente:

tan(Dual(x₁, x₂)) = sin(Dual(x₁, x₂)) / cos(Dual(x₁, x₂))

# Ejemplos

```julia-repl
julia> tan(Dual(3.1416, 3.1416))
Dual(7.346410206841829e-6, 1.5708000000847757)

julia> tan(Dual(3.1416, 3.1416/2))
Dual(7.346410206841829e-6, 1.5708000000847757)
```
"""
tan(x::Dual) = sin(x)/cos(x)

"""
Sobrecargamos la operación de exponente (`^`) para un número `Dual`. La operación que se realiza es la siguiente:

^(Dual(x₁, x₂), n) = Dual(x₁^n, n*x₁^(n-1)*x₂)

# Ejemplos

```julia-repl
julia> ^(Dual(2., 9.), 2)
Dual(4.0, 36.0)

julia> ^(Dual(sqrt(2), sqrt(2)), 5)
Dual(5.656854249492382, 28.28427124746191)
```
"""
^(x::Dual, n::Int) = Dual(x.fun^n, n*x.fun^(n-1)*x.der)

"""
Sobrecargamos la operación de raiz cuadrada (`sqrt`) para un número `Dual`. La operación que se realiza es la siguiente:

sqrt(Dual(x₁, x₂)) = Dual(sqrt(x₁), x₂/(2*srt(x₁)))

# Ejemplos

```julia-repl
julia> sqrt(Dual(9,4))
Dual(3.0, 0.6666666666666666)

julia> sqrt(Dual(16,4))
Dual(4.0, 0.5)
```
"""
sqrt(x::Dual) = Dual(sqrt(x.fun), x.der/(2.0*sqrt(x.fun)))

"""
Sobrecargamos la operación de exponencial (`exp`) para un número `Dual`. La operación que se realiza es la siguiente:

exp(Dual(x₁, x₂)) = Dual(exp(x₁), x₂*exp(x₁))

# Ejemplos

```julia-repl
julia> exp(Dual(0,4))
Dual(1.0, 4.0)

julia> exp(Dual(2,10))
Dual(7.38905609893065, 73.89056098930651)
```
"""
exp(x::Dual) = Dual(exp(x.fun), x.der*exp(x.fun))

"""
Sobrecargamos la operación de logaritmo (`log`) para un número `Dual`. La operación que se realiza es la siguiente:

log(Dual(x₁, x₂)) = Dual(log(x₁), x₂/x₁)

# Ejemplos

```julia-repl
julia> log(Dual(2,10))
Dual(0.6931471805599453, 5.0)

julia> log(Dual(1,10))
Dual(0.0, 10.0)
```
"""
log(x::Dual) = Dual(log(x.fun), x.der/x.fun)

# - Al igual que antes, construyan algún conjunto de pruebas que muestre, de manera
# sencilla, que lo que hicieron da lo que uno esperaría obtener.

import Base.≈
"""
Sobrecargamos la función isapprox (`≈`) para poder comparar operaciones no exactas, como las que
tenemos al hacer las operaciones seno y coseno.
"""
≈(x::Dual, y::Dual, atol::Real=0.001) = ≈(x.fun, y.fun; atol) && ≈(x.der, y.der; atol)

@test ≈(sin(Dual(π/2, 1.)), Dual(1., 0.))
@test ≈(cos(Dual(π/2, 1.)), Dual(0., -1.))
@test ≈(tan(Dual(π/2, 1.)), sin(Dual(π/2, 1.))/cos(Dual(π/2, 1.)))
@test Dual(3, 5)^4 == Dual(3^4, 4*(3^3)*5)
@test sqrt(Dual(9, 2)) == Dual(sqrt(9), 2/(2*sqrt(9)))
@test exp(Dual(10, 22)) == Dual(exp(10), 22*exp(10))
@test log(Dual(10, 100)) == Dual(log(10), 100/10)