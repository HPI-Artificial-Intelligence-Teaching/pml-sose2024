# Julia tutorial scripts
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

"""
Variable names
""" 
δ = 0.00001
안녕하세요 = "Hello"

"""
Variable assignment and mutation
""" 
a = [1,2,3] # an array of 3 integers
b = a   # both b and a are names for the same array!
a[1] = 42     # change the first element
a = 3.14159   # a is now the name of a different object
b   # b refers to the original array object, which has been mutated

"""
Function definition
""" 
function f(x,y)
    x + y
end

f(x,y) = x + y

"""
Function application
""" 

f(2,3)

"""
Function as objects
""" 
g = f
g(2,3)

"""
Unicode function names
""" 
Σ(x,y) = x + y
Σ(2, 3)

"""
Function arguments
""" 
function f(x, y)
    x[1] = 42    # mutates x
    y = 7 + y    # new binding for y, no mutation
    return y
end

a = [4,5,6]
b = 3
f(a, b) # returns 7 + b == 10
a  # a[1] is changed to 42 by f
b  # not changed

"""
return keyword
""" 
function g(x,y)
    return x * y
    x + y
end
g(2,3)

"""
Operators
""" 
+(1,2,3)
f = +
f(1,2,3)

"""
Anonymouse functions
""" 
function (x)
    x^2 + 2x - 1
end

x -> x^2 + 2x - 1

"""
Compound expressions
""" 
z = begin
    x = 1
    y = 2
    x + y
end

z = (x = 1; y = 2; x + y)

"""
Conditional evaluation
""" 
function test(x, y)
    if x < y
        println("x is less than y")
    elseif x > y
        println("x is greater than y")
    else
        println("x is equal to y")
    end
end
test(1, 2)
test(2, 1)
test(1, 1)

"""
Ternary operator
""" 
test(x, y) = println(x < y ? "x is less than y" : 
                     x > y ? "x is greater than y" : "x is equal to y")
test(1, 2)
test(2, 1)
test(1, 1)

"""
While loop
""" 
i = 1
while i <= 3
    println(i)
    i += 1
end

"""
For loop
""" 
for i = 1:3
    println(i)
end

for i in [1,4,0]
    println(i)
end


"""
Break statement
""" 
i = 1
while true
    println(i)
    if i >= 3
        break
    end
    i += 1
end

for j = 1:1000
    println(j)
    if j >= 3
        break
    end
end

"""
Type declarations
""" 

(1+2)::AbstractFloat
(1+2)::Int

function foo()
           x::Int8 = 100
           x
       end
x = foo()
typeof(x)

function g(x, y)::Int8
    return x * y
end;

typeof(g(1, 2))

"""
Abstract types
""" 
abstract type Number end
abstract type Real          <: Number end
abstract type AbstractFloat <: Real end
abstract type Integer       <: Real end
abstract type Signed        <: Integer end
abstract type Unsigned      <: Integer end

Integer <: Number
Integer <: AbstractFloat

"""
Primitive types
""" 
primitive type F16       <: AbstractFloat 16 end
primitive type F32       <: AbstractFloat 32 end
primitive type F64       <: AbstractFloat 64 end
primitive type Integer8  <: Signed   8 end
primitive type UInteger8 <: Unsigned 8 end

Integer8 <: Integer
Integer8 <: Real
Integer8 <: AbstractFloat


"""
Compisting types
"""
struct Foo
    bar
    baz::Int
    qux::Float64
end

foo = Foo("Hello, world.", 23, 1.5)
typeof(foo)

foo.bar
foo.baz
foo.qux

mutable struct Bar
    baz
    qux::Float64
end

bar = Bar("Hello", 1.5)
bar.qux = 2.0
bar.baz = 1//2

"""
Parametric types
"""

struct Point{T}
    x::T
    y::T
end

p1 = Point{Float64}(1.0, 2.0)
p2 = Point(1,2)
typeof(p1)
typeof(p2)
Point{Float64} <: Point

Point{Float64} <: Point{Real}
Point{Float64} <: Point{<:Real}

"""
Tuple types
"""
struct Tuple2{A,B}
    a::A
    b::B
end

x = (1,"foo",2.5)
typeof(x)
x[1]

Tuple{Int,AbstractString} <: Tuple{Real,Any}
Tuple{Int,AbstractString} <: Tuple{Real,Real}

x = (a=1,b="hello")
y = NamedTuple{(:a, :b)}((1, ""))

typeof(x) 
typeof(y)

x.b
y.a

"""
Number types
"""

x = 0x1
x = 0b10
x = 0o010

2.5e-4
2.5f-4

x = Float32(-1.5)
sizeof(Float16(4.))

eps(1.0)
eps(1000.)
eps(0.0)

string(big"2"^200, base=16)
big"1.23456789012345678901"

"""
String types
"""

str = "Hello, world.\n"
s1 = """Contains "quote" characters"""
s2 = "\u2200 x \u2203 y"

str[begin]
str[1]
str[end]
str[end-1]

greet = "Hello"
whom = "world"

greet * ", " * whom * ".\n"
"$greet, $whom.\n"

m = match(r"^\s*(?:#\s*(.*?)\s*$|$)", "# a comment ")

"""
Methods
"""
f(x::Float64, y::Float64) = 2x + y
f(x::Number, y::Number) = 2x - y

f(2.0, 3.0)
f(2.0, 3)
f("foo", 3)

methods(f)

f(x,y) = println("Whoa there, Nelly.")
f("foo", 1)

g(x::Float64, y) = 2x + y
g(x, y::Float64) = x + 2y
g(2.0, 3.0)

"""
Parametric methods
"""

same_type(x::T, y::T) where {T} = true
same_type(x,y) = false

same_type(1, 2)
same_type(1.0, 2.0)

same_type(1, 2.0)
same_type(Int32(1), Int64(2))

same_type_numeric(x::T, y::T) where {T<:Number} = true
same_type_numeric(x::Number, y::Number) = false

same_type_numeric(1, 2)
same_type_numeric(1.0, 2.0)

same_type_numeric(1, 2.0)
same_type_numeric("foo", 2.0)

struct OrderedPair
    x::Real
    y::Real
    OrderedPair(x,y) = x > y ? error("out of order") : new(x,y)
end
OrderedPair(a) = OrderedPair(a,a)
OrderedPair(10)

"""
Interfaces
"""
struct Squares
    count::Int
end
Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)

for item in Squares(7)
    println(item)
end
25 in Squares(10)
sum(Squares(100))

function Base.getindex(S::Squares, i::Int)
    1 <= i <= S.count || throw(BoundsError(S, i))
    return i*i
end
Base.length(S::Squares) = S.count
Base.firstindex(S::Squares) = 1
Base.lastindex(S::Squares) = length(S)

Squares(100)[23]
Squares(23)[end]

Base.getindex(S::Squares, i::Number) = S[convert(Int, i)]
Base.getindex(S::Squares, I) = [S[i] for i in I]
Squares(10)[[3,4.,5]]

"""
Modules
"""

module NiceStuff
export nice, DOG
struct Dog end # singleton type, not exported
const DOG = Dog() # named instance, exported
nice(x) = "nice $x" # function, exported
end

using .NiceStuff

nice("house 🏡")
