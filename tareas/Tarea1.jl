# # Tarea 1: Números duales

#-
# > Fecha de envío: 27 de marzo
# > Fecha de aceptación: 31 de marzo

#-
# Antes de describir los *números duales* recordaremos primero algunas propiedades de los
# números complejos.
# Los números complejos los podemos entender como una *pareja ordenada* $z=(x, y)$ que
# algebraicamente escribimos $z = x +i y$, donde $x,y\in\mathbb R$, con la propiedad de
# que el *número* $i$ satisface $i^2 = -1$. Decimos que $x$ es la *parte real* de $z$,
# y que $y$ es su *parte imaginaria*.
# Con estas definiciones, podemos extender las operaciones aritméticas al igual que las
# funciones elementales de manera sencilla, simplemente explotando el álgebra y además
# $i^2=-1$.

#-
# De manera similar, uno puede definir al *par ordenado*
# $\overleftrightarrow{x} = (x, x^\prime) = x + \epsilon x^\prime$, con
# $x, x^\prime \in \mathbb R$, y donde el *número* $\epsilon$ lo definimos con la propiedad
# $\epsilon^2=0$. Es fácil pues convencerse que estas estructuras, que llamaremos
# *números duales*, cumplen:
#
# \begin{eqnarray}
# (x + \epsilon x^\prime) \pm (y + \epsilon y^\prime) & = & (x\pm y) + \epsilon (x^\prime\pm y^\prime),\\
# (x + \epsilon x^\prime) \cdot (y + \epsilon y^\prime) & = & (x\cdot y) + \epsilon (xy^\prime+y x^\prime).
# \end{eqnarray}
#
# Llamaremos a $x$ la *parte principal* y a $x^\prime$ la *parte derivada* de $\overleftrightarrow{x}$.

#-
# ## Ejercicio 1
#
# - A partir de $\overleftrightarrow{z} \cdot \overleftrightarrow{y} = \overleftrightarrow{x}$,
# y usando la definición del producto entre duales, obtener la expresión para
# $\overleftrightarrow{z} = \overleftrightarrow{x} / \overleftrightarrow{y}$.
# Es decir, obtener
# qué son $z$ y $z^\prime$ en términos de las componentes de $\overleftrightarrow{x}$ y
# $\overleftrightarrow{y}$.
#
# - De la expresión obtenida (y de las fórmulas anteriores), ¿qué podemos decir
# (concluir o interpretar) sobre qué representa de $z^\prime$?

#-
#Respuesta

#-
# ## Ejercicio 2
#
# - Definir una estructura (`struct`) `Dual` que represente a los números duales;
# los nombres de los campos serán `fun` y `der`.
# Por sencillez, pueden considerar que los campos de `Dual` son del tipo `Float64`, aunque
# pueden *osar* y tratar de implementar el caso paramétrico `Dual{T <: Real}`,
# donde `T` es el tipo de *ambos* campos.
#
# - Sobrecargar las operaciones de tal manera que las cuatro operaciones aritméticas que
# involucrena dos `Dual`-es, den el resultado que se espera.
#
# - Definan un método específico para crear duales (constructor externo), a partir de un
# sólo valor (en lugar de los dos requeridos), y que corresponderá a
# $\overleftrightarrow{x_0} = (x_0, 0)$. ¿Es el *0* de esta definición, o sea, $x_0^\prime=0$,
# compatible con la interpretación que dieron en el ejercicio anterior para la parte derivada?
#
# - Extiendan los métodos que permitan sumar/restar y multiplicar/dividir un número (`::Real`) y
# un `::Dual`. (Recuerden que ciertas operaciones son conmutativas!).
# NOTA: Este ejercicio lo pueden hacer escribiendo todos los métodos, uno a uno. Otra
# opción es usar `promote` y `convert` para definir reglas de promoción y conversión;
# [la documentación](https://docs.julialang.org/en/v1/manual/conversion-and-promotion/)
# tiene más información, por si este camino les interesa.
#
# - Definan las funciones `fun` y `der` que, al ser aplicadas a un `Dual` devuelvan
# la parte principal y la parte derivada del `Dual`.
#
# - Incluyan varios casos (propuestos por ustedes mismos) donde se *compruebe* que lo que
# implementaron da el resultado que debería ser. Para esto, pueden usar la librería
# estándard [`Test`](https://docs.julialang.org/en/v1/stdlib/Test/) de Julia.

#-
#Respuesta

#-
# ## Ejercicio 3
#
# Definan una nueva función `vardual(x_0)` cuyo resultado sea un `Dual` cuya parte
# principal es `x_0` y cuya parte derivada sea tal que `xd = vardual(x_0)` *represente*
# a la variable independiente $x$ (en $x_0$). La idea es que debe representar
# la parte derivada del dual `xd` que regresa `xd = vardual(x_0)`. Con esta función
# evalúen `g(xd)` donde
# $$
# g(x) = \frac{3x^2-8x+1}{7x^3-1}.
# $$

#-
#Respuesta

#-
# ## Ejercicio 4
#
# - A partir de la interpretación que han hecho para la parte derivada (último inciso
# del Ejercicio 1), y *generalizando* esa interpretación de qué representa cada campo
# y en particular el segundo de `Dual`, *extiendan* las funciones `sin(a::Dual)`,
# `cos(a::Dual)`, `tan(a::Dual)`, `^(a::Dual, n::Int)`, `sqrt(a::Dual)`, `exp(a::Dual)`
# y `log(a::Dual)`.
#
# - Al igual que antes, construyan algún conjunto de pruebas que muestre, de manera
# sencilla, que lo que hicieron da lo que uno esperaría obtener.

#-
#Respuesta
