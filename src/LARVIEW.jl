module LARVIEW

	#export centroid, cuboidGrid, mkpol, view, hpc_exploded, lar2hpc

	using LARLIB
	
	using PyCall
	
	@pyimport pyplasm as p
	
	import Base.view

	"""
		Points = Matrix
		
	Alias declation of LAR-specific data structure.
	Dense `Matrix` ``M\times N`` to store the position of *vertices* (0-cells)
	of a *cellular complex*. The number of rows ``M`` is the dimension 
	of the embedding space. The number of columns ``N`` is the number of vertices.
	"""
	const Points = Matrix
	
	
	"""
		Cells = Array{Array{Int,1},1}
		
	Alias declation of LAR-specific data structure.
	Dense `Array` to store the indices of vertices of `P-cells`
	of a cellular complex. 
	The linear space of `P-chains` is generated by `Cells` as a basis.
	Simplicial `P-chains` have `P+1` vertex indices for `cell` element in `Cells` array.
	Cuboidal `P-chains` have ``2^P`` vertex indices for `cell` element in `Cells` array.
	Other types of chain spaces may have different numbers of vertex indices for `cell` 
	element in `Cells` array.
	"""
	const Cells = Array{Array{Int,1},1}
	
	
	"""
		Chain = SparseVector{Int8,Int}
		
	Alias declation of LAR-specific data structure.
	Binary `SparseVector` to store the coordinates of a `chain` of `N-cells`. It is
	`nnz=1` with `value=1` for the coordinates of an *elementary N-chain*, constituted by 
	a single *N-chain*.
	"""
	const Chain = SparseVector{Int8,Int}
	
	
	"""
		ChainOp = SparseMatrixCSC{Int8,Int}
		
	Alias declation of LAR-specific data structure. 
	`SparseMatrix` in *Compressed Sparse Column* format, contains the coordinate 
	representation of an operator between linear spaces of `P-chains`. 
	Operators ``P-Boundary : P-Chain -> (P-1)-Chain``
	and ``P-Coboundary : P-Chain -> (P+1)-Chain`` are typically stored as 
	`ChainOp` with elements in ``\{-1,0,1\}`` or in ``\{0,1\}``, for 
	*signed* and *unsigned* operators, respectively.
	"""
	const ChainOp = SparseMatrixCSC{Int8,Int}
	
	
	"""
		ChainComplex = Array{ChainOp,1}
		
	Alias declation of LAR-specific data structure. It is a 
	1-dimensional `Array` of `ChainOp` that provides storage for either the 
	*chain of boundaries* (from `D` to `0`) or the transposed *chain of coboundaries* 
	(from `0` to `D`), with `D` the dimension of the embedding space, which may be either 
	``\R^2`` or ``\R^3``.
	"""
	const ChainComplex = Array{ChainOp,1}
	
	
	"""
		LARmodel = Tuple{Points,Array{Cells,1}}
		
	Alias declation of LAR-specific data structure.
	`LARmodel` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as 
	`Points`, and *Topology* is stored as `Array` of `Cells`. The number of `Cells` 
	values may vary from `1` to `N+1`.
	"""
	const LARmodel = Tuple{Points,Array{Cells,1}}
	
	
	"""
		LAR = Tuple{Points,Cells}
		
	Alias declation of LAR-specific data structure.
	`LAR` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as 
	`Points`, and *Topology* is stored as `Cells`. 
	"""
	const LAR = Tuple{Points,Cells}
	
	
	"""
		Hpc = PyCall.PyObject
		
	Alias declation of LAR-specific data structure. 
	`Hpc` stands for *Hierarchical Polyhedral Complex* and is the geometric data structure 
	used by `PLaSM` (Programming LAnguage for Solid Modeling). See the Wiley's book 
	[*Geometric Programming for Computer-Aided Design*]
	(https://onlinelibrary.wiley.com/doi/book/10.1002/0470013885) and its 
	current `Python` library [*https://github.com/plasm-language/pyplasm*]
	(https://github.com/plasm-language/pyplasm).
	"""
	const Hpc = PyCall.PyObject



	"""
		cuboidGrid(shape::Array{Int64,1}[, full=false])::Union{LAR,LARmodel}

	compute a *cellular complex* (mesh) with *cuboidal cells* of either `LARmodel` 
	or `LAR` type, depending of the value of optional `full` parameter. The default is
	for returning a `LAR` value, i.e. a pair `(Points, Cells)`.
	The *dimension* of `Cells` is the one of the number `M` of rows of 
	cell `Points`. The dimensions of `Array{Cells,1}` in `LARmodel` run 
	from ``1`` to ``M``.
	"""
	cuboidGrid = LARLIB.larCuboids


	"""
		centroid( V::Points )::Array{Float64,1}
		
	*Geometric center* of a `Points` 2-array of `size` ``(M,N)``. Each of the 
	``M`` coordinates of *barycenter* of the dense array of ``N`` `points` is the *mean*
	of the corresponding `Points` coordinates.
	"""
	function centroid( V::Points )::Array{Float64,2}
		return sum(V,2)/size(V,2)
	end
	

	"""
		centroid(V::Array{Float64,2})::Array{Float64,1}
		
	*Geometric center* of a `Points` 2-array of `size` ``(M,N)``. Each of the 
	``M`` coordinates of *barycenter* of the dense array of ``N`` `points` is the *mean*
	of the corresponding `Array` coordinates.
	"""
	function centroid(V::Array{Float64,2})::Array{Float64,2}
	    return sum(V,2)/size(V,2)
    end
    
    
	"""
		cells2py(cells::Cells)::PyObject
		
	Return a `Cells` object in a *Python* source text format. The returned `PyObject` is
	 a list of lists of integers.
	
	# Example
	``` julia
	julia> FV = LARLIB.cuboid([1,1,1],true)[2][3]
	6-element Array{Array{Int64,1},1}:
	 [1, 2, 3, 4]
	 [5, 6, 7, 8]
	 [1, 2, 5, 6]
	 [3, 4, 7, 8]
	 [1, 3, 5, 7]
	 [2, 4, 6, 8]

	julia> cells2py(FV)
	PyObject [[1, 2, 3, 4], [5, 6, 7, 8], [1, 2, 5, 6], [3, 4, 7, 8], 
	[1, 3, 5, 7], [2, 4, 6, 8]]
	```
	"""
	function cells2py(cells::Cells)::PyObject
		return PyObject([Any[cell[h] for h=1:length(cell)] for cell in cells])
	end



	"""
		points2py(V::Points)::PyObject
		
	Return a `Points` object in a *Python* source text format. The returned `PyObject` is
	 a `list of lists of float`.
	
	# Example
	``` julia
	julia> V = LARLIB.cuboid([1,1,1])[1]
	3×8 Array{Float64,2}:
	 0.0  0.0  0.0  0.0  1.0  1.0  1.0  1.0
	 0.0  0.0  1.0  1.0  0.0  0.0  1.0  1.0
	 0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0

	julia> points2py(V::Points)
	PyObject [[0.0, 0.0, 0.0], [0.0, 0.0, 1.0], [0.0, 1.0, 0.0], [0.0, 1.0, 1.0], 
	[1.0, 0.0, 0.0], [1.0, 0.0, 1.0], [1.0, 1.0, 0.0], [1.0, 1.0, 1.0]]
	```
	"""
	function points2py(V::Points)::PyObject
		return PyObject([Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)])
	end



	"""
		mkpol(verts::Points, cells::Cells)::Hpc
		
	Return an `Hpc` object starting from a `Points` and a `Cells` object. *HPC = 
	Hierarchical Polyhedral Complex* is the geometric data structure 
	used by `PLaSM` (Programming LAnguage for Solid Modeling). See the Wiley's book 
	[*Geometric Programming for Computer-Aided Design*]
	(https://onlinelibrary.wiley.com/doi/book/10.1002/0470013885) and its 
	current `Python` library [*https://github.com/plasm-language/pyplasm*]
	(https://github.com/plasm-language/pyplasm).
	
	```julia
	julia> V,(VV,EV,FV,CV) = LARLIB.cuboid([1,1,1],true);
	
	julia> mkpol(V,EV)
	PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 
	'std::shared_ptr< Hpc > *' at 0x12cf45d50> >

	julia> 
	view(mkpol(V,EV))	
	[...]
	```
	"""
	function mkpol(verts::Points, cells::Cells)::Hpc
		verts = points2py(verts)
		cells = cells2py(cells)
		return p.MKPOL([verts,cells,[]])
	end



	
	"""
		view(hpc::Hpc)
		
	Base.view extension. 
	Display a *Python*  `HPC` (Hierarchica Polyhedral Complex) `object` using 
	the *`PyPlasm` viewer*, written in C++ with `OpenGL` and acceleration algorithms 
	for *big geometric data* structures. 
	
	# Example
	``` julia
	julia> m = LARLIB.cuboidGrid([2,2],true)
	([0.0 0.0 … 2.0 2.0; 0.0 1.0 … 1.0 2.0], Array{Array{Int64,1},1}[Array{Int64,1}[[1], 
	[2], [3], [4], [5], [6], [7], [8], [9]], Array{Int64,1}[[1, 2], [2, 3], [4, 5], [5, 
	6], [7, 8], [8, 9], [1, 4], [2, 5], [3, 6], [4, 7], [5, 8], [6, 9]], 
	Array{Int64,1}[[1, 2, 4, 5], [2, 3, 5, 6], [4, 5, 7, 8], [5, 6, 8, 9]]])

	julia> hpc = mkpol(m[1],m[2][2])
	PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 'std::shared_ptr< Hpc > *' 
	at 0x140d6c780> >

	julia> view(hpc)
	``` 
	"""
	function view(hpc::Hpc)
		p.VIEW(hpc)
	end
	
	

	"""
		view(V::Points, CV::Cells)
		
	Base.view extension. 
	Display a *Python*  `HPC` (Hierarchica Polyhedral Complex) `object` using 
	the *`PyPlasm` viewer*, written in C++ with `OpenGL` and acceleration algorithms 
	for *big geometric data* structures. Input parameters are of `Points` and `Cells`
	type.
	
	# Example

	```julia
	julia> V,(VV,EV,FV,CV) = LARLIB.cuboid([1,1,1],true);
	
	julia> mkpol(V,EV)
	PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 
	'std::shared_ptr< Hpc > *' at 0x12cf45d50> >

	julia> 
	view(mkpol(V,EV))	
	[...]
	```
	"""
	function view(V::Points, CV::Cells)
		hpc = lar2hpc(V::Points, CV::Cells)
		p.VIEW(hpc)
	end



	"""
		view(model::LARmodel)
		
	Base.view extension. 
	Display a *Python*  `HPC` (Hierarchica Polyhedral Complex) `object` using 
	the *`PyPlasm` viewer*, written in C++ with `OpenGL` and acceleration algorithms 
	for *big geometric data* structures. The input is a `LARmodel` object.
	
	# Example
	
	```julia
	julia> typeof( LARLIB.cuboid([1,1,1], true) )
	Tuple{Array{Float64,2},Array{Array{Int64,1},1}}
	
	julia> view( LARLIB.cuboid([1,1,1], true) )
	```
	"""
	function view(model::LARmodel)
		hpc = hpc_exploded(model::LARmodel)(1,1,1)
		p.VIEW(hpc)
	end



	"""
		view(pair::Tuple{Points,Cells})
		
	Base.view extension. 
	Display a *Python*  `HPC` (Hierarchica Polyhedral Complex) `object` using 
	the *`PyPlasm` viewer*, written in C++ with `OpenGL` and acceleration algorithms 
	for *big geometric data* structures. The input is a `pair` of type 
	`Tuple{Points,Cells}`.
	
	# Example
	```julia
	julia> typeof(LARLIB.cuboid([1,1,1])::LAR)
	Tuple{Array{Float64,2},Array{Array{Int64,1},1}}
		
	julia> LARVIEW.view(LARLIB.cuboid([1,1,1]))
	```
	"""
	function view(pair::Tuple{Points,Cells})
		V,CV = pair
		hpc = lar2hpc(V::Points, CV::Cells)
		p.VIEW(hpc)
	end


	"""
		view(obj::LARLIB.Struct)
	
	Display a geometric value of `Struct` type, via conversion to `LAR`
	and then to `Hpc` values. 
	"""
	function view(obj::LARLIB.Struct)
		lar = LARLIB.struct2lar(obj)
		view(lar)
	end



	"""
		view(scene::Array{Any,1})

	Display a geometric `scene`, defined as `Array{Any,1}` of geometric objects
	defined in the *same* coordinate system, i.e. in *World Coordinates*.
	
	# Example 
	
	A hierarchical `scene` defined in *Local Coordinates* as value of `Struct` type, 
	must be converted to `Array{Any,1}` by the expression 
	
		`evalStruct(scene::Struct)::Array{Any,1}`
	
	"""
	function view(scene::Array{Any,1})
		if prod([isa(item[1:2],LARLIB.LAR) for item in scene])
			p.VIEW(p.STRUCT([lar2hpc(collect(item)) for item in scene]))
		end
	end


	"""
		hpc_exploded( model::LARmodel )( sx=1.2, sy=1.2, sz=1.2 )::Hpc
		
	Convert a `LARmodel` into a `Hpc` object, after exploding all-dimensional cells with 
	scale `sx,sy,sz` parameters. Every cell is *translated* by the vector difference 
	between its *scaled centroid* and its *centroid*. Every cell is transformed in a 
	single `LAR` object before explosion.
	
	# Example
	```julia
	julia> hpc = hpc_exploded(LARLIB.cuboid([1,1,1], true))(1.5,1.5,1.5)
	
	julia> view(hpc)
	```
	"""
	function hpc_exploded( model::LARmodel )
		function hpc_exploded0( sx=1.2, sy=1.2, sz=1.2 )::Hpc
			verts,cells = model
			out = []
			for skeleton in cells[2:end]
				for cell in skeleton
					vcell = hcat([[verts[h,k] for h=1:size(verts,1)] for k in cell]...)
				
					center = centroid(vcell)
					scaled_center = length(center)==2 ? center.*[sx,sy] :  
														center.*[sx,sy,sz]
					translation_vector = scaled_center-center
					vcell = vcell .+ translation_vector
		
					py_verts = points2py(vcell)
					py_cells = cells2py( [collect(1:size(vcell,2))] )
					
					hpc = p.MKPOL([ py_verts, py_cells, [] ])
					push!(out, hpc)
				end
			end
			hpc = p.STRUCT(out)
			return hpc
		end
		return hpc_exploded0
	end



	"""
		lar2hpc(V::Points, CV::Cells)::Hpc
		
	Return an `Hpc` object starting from a `Points` and a `Cells` object. *HPC = 
	Hierarchical Polyhedral Complex* is the geometric data structure 
	used by `PLaSM` (Programming LAnguage for Solid Modeling). See the Wiley's book 
	[*Geometric Programming for Computer-Aided Design*]
	(https://onlinelibrary.wiley.com/doi/book/10.1002/0470013885) and its 
	current `Python` library [*https://github.com/plasm-language/pyplasm*]
	(https://github.com/plasm-language/pyplasm).
	# Example

	```julia
	julia> V,(VV,EV,FV,CV) = LARLIB.cuboid([1,1,1],true);
	
	julia> hpc = lar2hpc( (V, CV)::LAR ... )::Hpc
	PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 
	'std::shared_ptr< Hpc > *' at 0x12cf45d50> >

	julia> 
	view(hpc)	
	[...]
	```
	"""
	function lar2hpc(V::Points, CV::Cells)::Hpc
		hpc = mkpol(V,CV)
	end




	"""
		lar2hpc(model::LARmodel)::Hpc
		
	Return an `Hpc` object starting from a `LARmodel` object. *HPC = 
	Hierarchical Polyhedral Complex* is the geometric data structure 
	used by `PLaSM` (Programming LAnguage for Solid Modeling). See the Wiley's book 
	[*Geometric Programming for Computer-Aided Design*]
	(https://onlinelibrary.wiley.com/doi/book/10.1002/0470013885) and its 
	current `Python` library [*https://github.com/plasm-language/pyplasm*]
	(https://github.com/plasm-language/pyplasm).
	# Example
	```julia
	julia> model = LARLIB.cuboid([1,1,1],true);
	
	julia> view( lar2hpc(model) )
	
	julia> view( hpc_exploded(model)(1.5,1.5,1.5) )
	```
	"""
	function lar2hpc(model::LARmodel)::Hpc
		verts = model[1]
		cells = Array{Int,1}[]
		for item in model[2]
			append!(cells, item)
		end
		hpc = mkpol(verts,cells)
	end

	function lar2hpc(scene::Array{Any,1})::Hpc
		hpc = p.STRUCT([ LARVIEW.mkpol(item[1],item[2]) for item in scene ])
	end



	"""
		lar2exploded_hpc(V::Points,CV::Cells)::Hpc

	Return an *exploded* `Hpc` object starting from a `V::Points` and a `CV::Cells` 
	object, after exploding cells in `CV` with 
	scale `sx,sy,sz` parameters. Every cell is *translated* by the vector difference 
	between its *scaled centroid* and its *centroid*. Every cell is transformed in a 
	single `LAR` object before explosion. *HPC = Hierarchical Polyhedral Complex* 
	is the geometric data structure 
	used by `PLaSM` (Programming LAnguage for Solid Modeling). See the Wiley's book 
	[*Geometric Programming for Computer-Aided Design*]
	(https://onlinelibrary.wiley.com/doi/book/10.1002/0470013885) and its 
	current `Python` library [*https://github.com/plasm-language/pyplasm*]
	(https://github.com/plasm-language/pyplasm).
	
	BUG (Julia?, PyCall?):  
	hpc_exploded( (V,cells) )(sx,sy,sz)  ==>  OK
	hpc_exploded( (V,[cells[4]]) )(sx,sy,sz)  ==> KO
	with typeof(cells) == typeof([cells[4]]) == true
	
	V,cells = LARLIB.cuboidGrid([3,3,1],true)
	lar2exploded_hpc(V::Points,cells[4]::Cells)()

	"""
	function lar2exploded_hpc(V::Points,cells::Array{Cells,1})
		function lar2exploded_hpc0(sx=1.2, sy=1.2, sz=1.2)
			hpc = hpc_exploded( (V,cells) )(sx,sy,sz)
		end
		return lar2exploded_hpc0
	end


end # module
