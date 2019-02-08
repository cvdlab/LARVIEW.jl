using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
import Base.cat
using PyCall
p = PyCall.pyimport("pyplasm")
using DataStructures



""" 
	apply(affineMatrix::Matrix)

Apply the `affineMatrix` parameter to the vertices of `larmodel`.

# Example

```
julia> 
```
"""
function apply(fun::Function, params::Array)
	return fun(params)
end


""" 
	apply(affineMatrix::Matrix)(larmodel::LAR)::LAR

Apply the `affineMatrix` parameter to the vertices of `larmodel`.

# Example

```
julia> square = LinearAlgebraicRepresentation.cuboid([1,1])
([0.0 0.0 1.0 1.0; 0.0 1.0 0.0 1.0], Array{Int64,1}[[1, 2, 3, 4]])

julia> Plasm.apply(LinearAlgebraicRepresentation.t(1,2))(square)
([1.0 1.0 2.0 2.0; 2.0 3.0 2.0 3.0], Array{Int64,1}[[1, 2, 3, 4]])
```
"""
function apply(affineMatrix)
	function apply0(larmodel)
		return Lar.struct2lar(Lar.Struct([ affineMatrix,larmodel ]))
	end
	return apply0
end



""" 
	comp(funs::Array)

Standard mathematical composition. 

Pipe execution from right to left on application to actual parameter.
"""
function comp(funs)
    function compose(f,g)
	  return x -> f(g(x))
	end
    id = x->x
    return reduce(compose, funs; init=id)
end



"""
	cons(funs::Array)(x::Any)::Array

*Construction* functional of FL and PLaSM languages.

Provides a *vector* functional that returns the array of 
applications of component functions to actual parameter.

# Example 

```
julia> Plasm.cons([cos,sin])(0)
2-element Array{Float64,1}:
 1.0
 0.0
```
"""
function cons(funs)
	return x -> [f(x) for f in funs]
end



""" 
	k(Any)(x)

*Constant* functional of FL and PLaSM languages.

Gives a constant functional that always returns the actual parameter
when applied to another parameter.

#	Examples

```
julia> Plasm.k(10)(100)
10

julia> Plasm.k(sin)(cos)
sin
```
"""
function k(Any)
	x->Any
end


""" 
	aa(fun::Function)(args::Array)::Array

AA applies fun to each element of the args sequence 

# Example 

```
julia> Plasm.aa(sqrt)([1,4,9,16])
4-element Array{Float64,1}:
 1.0
 2.0
 3.0
 4.0
```
"""
function aa(fun)
	function aa1(args::Array)
		map(fun,args)
	end
	return aa1
end



""" 
	id(x::Anytype)

Identity function.  Return the argument.

"""
id = x->x



	
""" 
	distr(args::Union{Tuple,Array})::Array

Distribute right. The parameter `args` must contain a `list` and an element `x`. 
Return the `pair` array with the elements of `args` coupled with `x`

# Example 

```
julia> Plasm.distr(([1,2,3],10))
3-element Array{Array{Int64,1},1}:
 [1, 10]
 [2, 10]
 [3, 10]
```
"""
function distr(args)
	list,element = args
	return [ [e,element] for e in list ]
end



	
""" 
	distl(args::Union{Tuple,Array})::Array

Distribute right. The parameter `args` must contain an element `x` and a `list`. 
Return the `pair` array with `x` coupled with the elements of `args`. 

# Example 

```
julia> Plasm.distl((10, [1,2,3]))
3-element Array{Array{Int64,1},1}:
 [10, 1]
 [10, 2]
 [10, 3]
```
"""
function distl(args)
	element, list = args
	return [ [element, e] for e in list ]
end

#---------------------------------------------------------
# COLOR
#---------------------------------------------------------



""" 
	const Color4f
	
`PyObject` <class 'pyplasm.xgepy.Color4f'>

Color value `(R,G,B,A)`, Red, Green, Blue, Alpha, 
with `0.0 � R,G,B,A � 1.0`. Quadruple of Float numbers 

# Example

```julia
using PyCall
p = PyCall.pyimport("pyplasm")

julia> black = Color4f(0,0,0,1)
PyObject Color4f(0.000000e+00,0.000000e+00,0.000000e+00,1.000000e+00)

julia> black = Color4f(1.0,1.0,1.0,1.0)
PyObject Color4f(1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00)
```
"""
const Color4f = p["Color4f"]




""" 
	const color

`PyObject` <function COLOR at 0x126d6f730>

# Example

```julia
julia> black = Color4f(0,0,0,1)
PyObject Color4f(0.000000e+00,0.000000e+00,0.000000e+00,1.000000e+00)

julia> b = color(black)
PyObject <function COLOR.<locals>.COLOR0 at 0x135dfcb70>

julia> white = Color4f(1,1,1,1)
PyObject Color4f(1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00)

julia> w = color(white)
PyObject <function COLOR.<locals>.COLOR0 at 0x135dfcc80>
```
"""
const color = p["COLOR"]




""" 
	const colors::OrderedDict(String,PyObject)

Dictionary of predefined `color::PyObject` functions, with `string` keys and 
`PyObject` value, usable as Julia functions of type `Hpc -> Hpc`.
Notice that in order to be visualized by `PyPlasm` viewer, color functions must 
be applied to `Hpc` values, and return `Hpc` values.

# Example

```julia
julia> julia> @show keys(colors);
keys(colors) = ["orange", "red", "green", "blue", "cyan", "magenta", 
				"yellow", "white", "black", "purple", "gray", "brown"]

julia> green = colors["green"]

julia> V,CV = Lar.cuboid([1,4,9])
([0.0 0.0 � 1.0 1.0; 0.0 0.0 � 4.0 4.0; 0.0 9.0 � 0.0 9.0], Array{Int64,1}[[1, 2, 3, 4, 5, 6, 7, 8]])

julia> hpc = Plasm.lar2hpc(V,CV)
PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 'std::shared_ptr< Hpc > *' at 0x12943c690> >

julia> green(hpc)
PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 'std::shared_ptr< Hpc > *' at 0x12943c6c0> >

julia> Plasm.view(green(hpc))
```
"""
const colors = OrderedDict([
"orange" => color(p["ORANGE"]),
"red" => color(p["RED"]),
"green" => color(p["GREEN"]),
"blue" => color(p["BLUE"]),
"cyan" => color(p["CYAN"]),
"magenta" => color(p["MAGENTA"]),
"yellow" => color(p["YELLOW"]),
"white" => color(p["WHITE"]),
"black" => color(p["BLACK"]),
"purple" => color(p["PURPLE"]),
"gray" => color(p["GRAY"]),
"brown" => color(p["BROWN"]) ])

white = color(Color4f(1,1,1))