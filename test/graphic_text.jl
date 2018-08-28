using LinearAlgebraicRepresentation
using LARVIEW
using Base.Test

@testset "mini-FL Tests" begin
   @testset "comp" begin
		@test Plasm.comp([acos,atan,tan,sin])(pi/4) * 4 - pi < 0.1e-14
		@test Plasm.comp([acos,atan,tan,sin])(1)==(acos∘atan∘tan∘sin)(1)
		@test Plasm.comp([atan,tan])(pi/4)*4 > 3.14159265358979
   end
   
   @testset "cons Tests" begin
		@test ((Plasm.cons([acos,atan,tan,sin])(pi/4) .<= 
		[0.667458,0.665774,1.0,0.707107]))==[true,true,true,true]
		@test (Plasm.cons([sin,cos])(pi/2).>=[1.0,0.0])==[true,true]
		@test Plasm.cons([+,-])([2,3])==[[2,3],[-2,-3]]
		@test typeof(Plasm.cons([+,-])([2,3]))==Array{Array{Int64,1},1}
   end
   
   @testset "k Tests" begin
		@test Plasm.k(10)(100)==10
		@test Plasm.k(10)(sin)==10
		@test Plasm.k(sin)(cos)==sin
		@test Plasm.k(sin)(1000)==sin
		@test Plasm.k([1,2,3])(100)==[1,2,3]
		@test Plasm.k([1,2,3])(sin)==[1,2,3]
   end
   
   @testset "aa Tests" begin
		@test (Plasm.aa(sin)([0.,pi/2])==[0.0,1.0])
		@test typeof(Plasm.aa(sin)([0.,pi/6,pi/2]))==Array{Float64,1}
		@test Plasm.aa(sum)([[1,2],[3,4],[5,6],[7,8]])==[3,7,11,15]
   end
end

@testset "ascii codes Tests" begin
	@test Plasm.ascii_LAR[32] == ([0.0, 0.0], Array{Int64,1}[[1]])
	@test Plasm.ascii_LAR[33] == ([1.75 1.75 2.0 2.0 1.5 1.5; 1.75 5.5 0.5 1.0 1.0 0.5], Array{Int64,1}[[1, 2], [3, 4], [4, 5], [5, 6], [6, 3]])
	@test Plasm.ascii_LAR[34] == ([1.0 2.0 2.0 2.0 1.5 1.5 2.0 3.0 3.0 3.0 2.5 2.5; 4.0 5.0 5.5 6.0 6.0 5.5 4.0 5.0 5.5 6.0 6.0 5.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 3], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 9]])
	@test Plasm.ascii_LAR[35] == ([1.0 3.0 1.0 3.0 1.25 1.75 2.25 2.75; 2.5 2.5 3.5 3.5 1.75 4.0 1.75 4.0], Array{Int64,1}[[1, 2], [3, 4], [5, 6], [7, 8]])
	@test Plasm.ascii_LAR[36] == ([0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 2.0 2.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 6.0 5.0 -0.5 6.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [13, 14]])
	@test Plasm.ascii_LAR[37] == ([2.5 2.5 2.0 2.0 2.5 2.5 2.0 2.0 1.5 3.5; 0.0 0.5 0.5 0.0 5.5 6.0 6.0 5.5 5.5 11.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 5], [9, 10]])
	@test Plasm.ascii_LAR[38] == ([4.0 3.0 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 5.0 4.0 2.0 2.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14]])
	@test Plasm.ascii_LAR[39] == ([1.0 2.0 2.0 2.0 1.5 1.5; 4.0 5.0 5.5 6.0 6.0 5.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 3]])
	@test Plasm.ascii_LAR[40] == ([2.0 1.0 0.5 1.0 2.0; 0.0 1.0 3.0 5.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5]])
	@test Plasm.ascii_LAR[41] == ([2.0 3.0 3.5 3.0 2.0; 0.0 1.0 3.0 5.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5]])
	@test Plasm.ascii_LAR[42] == ([1.0 3.0 2.0 2.0 1.0 3.0 1.0 3.0; 3.0 3.0 2.0 4.0 2.0 4.0 4.0 2.0], Array{Int64,1}[[1, 2], [3, 4], [5, 6], [7, 8]])
	@test Plasm.ascii_LAR[43] == ([1.0 3.0 2.0 2.0; 3.0 3.0 2.0 4.0], Array{Int64,1}[[1, 2], [3, 4]])
	@test Plasm.ascii_LAR[44] == ([1.0 2.0 2.0 2.0 1.5 1.5; -1.0 0.0 0.5 1.0 1.0 0.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 3]])
	@test Plasm.ascii_LAR[45] == ([1.0 3.0; 3.0 3.0], Array{Int64,1}[[1, 2]])
	@test Plasm.ascii_LAR[46] == ([2.0 2.0 1.5 1.5 2.0; 0.0 0.5 0.5 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5]])
	@test Plasm.ascii_LAR[47] == ([1.0 3.0; 0.0 6.0], Array{Int64,1}[[1, 2]])
	@test Plasm.ascii_LAR[48] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [4, 8]])
	@test Plasm.ascii_LAR[49] == ([0.0 2.0 2.0 0.0 4.0; 4.0 6.0 0.0 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[50] == ([0.0 0.0 1.0 3.0 4.0 4.0 0.0 4.0; 4.0 5.0 6.0 6.0 5.0 4.0 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]])
	@test Plasm.ascii_LAR[51] == ([0.0 4.0 2.0 4.0 4.0 3.0 1.0 0.0 0.0; 6.0 6.0 4.0 2.0 1.0 0.0 0.0 1.0 2.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]])
	@test Plasm.ascii_LAR[52] == ([4.0 0.0 4.0 4.0; 1.0 1.0 6.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
	@test Plasm.ascii_LAR[53] == ([4.0 0.0 0.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0; 6.0 6.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 2.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10]])
	@test Plasm.ascii_LAR[54] == ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0; 6.0 6.0 5.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11]])
	@test Plasm.ascii_LAR[55] == ([0.0 0.0 4.0 0.0; 5.0 6.0 6.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
	@test Plasm.ascii_LAR[56] == ([1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 4.0 4.0 3.0 1.0 0.0 0.0; 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 4.0 5.0 6.0 6.0 5.0 4.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [6, 5], [5, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14], [14, 6]])
	@test Plasm.ascii_LAR[57] == ([0.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 0.0 0.0 1.0 5.0 6.0 6.0 5.0 3.0 2.0 2.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11]])
	@test Plasm.ascii_LAR[58] == ([2.0 2.0 1.5 1.5 2.0 2.0 1.5 1.5; 1.0 1.5 1.5 1.0 3.0 3.5 3.5 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 5]])
	@test Plasm.ascii_LAR[59] == ([2.0 2.0 1.5 1.5 1.0 2.0 2.0 2.0 1.5 1.5; 3.0 3.5 3.5 3.0 -0.5 0.5 1.0 1.5 1.5 1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 7]])
	@test Plasm.ascii_LAR[60] == ([3.0 0.0 3.0; 6.0 3.0 0.0], Array{Int64,1}[[1, 2], [2, 3]])
	@test Plasm.ascii_LAR[61] == ([1.0 3.0 1.0 3.0; 2.5 2.5 3.5 3.5], Array{Int64,1}[[1, 2], [3, 4]])
	@test Plasm.ascii_LAR[62] == ([1.0 4.0 1.0; 6.0 3.0 0.0], Array{Int64,1}[[1, 2], [2, 3]])
	@test Plasm.ascii_LAR[63] == ([2.0 2.0 1.5 1.5 1.75 1.75 3.0 3.0 2.0 1.0 0.0 0.0; 0.0 0.5 0.5 0.0 1.0 2.75 4.0 5.0 6.0 6.0 5.0 4.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12]])
	@test Plasm.ascii_LAR[64] == ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 2.0 1.0 2.0 3.0 2.0; 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 1.0 2.0 3.0 2.0 1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13]])
	@test Plasm.ascii_LAR[65] == ([0.0 0.0 1.0 3.0 4.0 4.0 0.0 4.0; 0.0 5.0 6.0 6.0 5.0 0.0 2.0 2.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [7, 8]])
	@test Plasm.ascii_LAR[66] == ([0.0 0.0 3.0 4.0 4.0 3.0 4.0 4.0 3.0 0.0 0.0 3.0; 0.0 6.0 6.0 5.0 4.0 3.0 2.0 1.0 0.0 0.0 3.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [11, 12]])
	@test Plasm.ascii_LAR[67] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]])
	@test Plasm.ascii_LAR[68] == ([0.0 0.0 3.0 4.0 4.0 3.0 0.0; 0.0 6.0 6.0 5.0 1.0 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]])
	@test Plasm.ascii_LAR[69] == ([4.0 0.0 0.0 4.0 0.0 3.0; 0.0 0.0 6.0 6.0 3.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [5, 6]])
	@test Plasm.ascii_LAR[70] == ([0.0 0.0 4.0 0.0 3.0; 0.0 6.0 6.0 3.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[71] == ([2.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 3.0 3.0 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10]])
	@test Plasm.ascii_LAR[72] == ([0.0 0.0 4.0 4.0 0.0 4.0; 0.0 6.0 6.0 0.0 3.0 3.0], Array{Int64,1}[[1, 2], [3, 4], [5, 6]])
	@test Plasm.ascii_LAR[73] == ([2.0 2.0 1.0 3.0 1.0 3.0; 0.0 6.0 0.0 0.0 6.0 6.0], Array{Int64,1}[[1, 2], [3, 4], [5, 6]])
	@test Plasm.ascii_LAR[74] == ([0.0 1.0 2.0 3.0 3.0 2.0 4.0; 1.0 0.0 0.0 1.0 6.0 6.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [6, 7]])
	@test Plasm.ascii_LAR[75] == ([4.0 0.0 4.0 0.0 0.0; 6.0 3.0 0.0 0.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[76] == ([4.0 0.0 0.0; 0.0 0.0 6.0], Array{Int64,1}[[1, 2], [2, 3]])
	@test Plasm.ascii_LAR[77] == ([0.0 0.0 2.0 4.0 4.0; 0.0 6.0 4.0 6.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5]])
	@test Plasm.ascii_LAR[78] == ([0.0 0.0 4.0 4.0 4.0; 0.0 6.0 2.0 0.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[79] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0 1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]])
	@test Plasm.ascii_LAR[80] == ([0.0 0.0 3.0 4.0 4.0 3.0 0.0; 0.0 6.0 6.0 5.0 3.0 2.0 2.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]])
	@test Plasm.ascii_LAR[81] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0 1.0 1.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [10, 11]])
	@test Plasm.ascii_LAR[82] == ([0.0 0.0 3.0 4.0 4.0 3.0 0.0 3.0 4.0; 0.0 6.0 6.0 5.0 3.0 2.0 2.0 2.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [8, 9]])
	@test Plasm.ascii_LAR[83] == ([0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 6.0 5.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12]])
	@test Plasm.ascii_LAR[84] == ([2.0 2.0 0.0 4.0; 0.0 6.0 6.0 6.0], Array{Int64,1}[[1, 2], [3, 4]])
	@test Plasm.ascii_LAR[85] == ([0.0 0.0 1.0 3.0 4.0 4.0; 6.0 1.0 0.0 0.0 1.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]])
	@test Plasm.ascii_LAR[86] == ([0.0 2.0 4.0; 6.0 0.0 6.0], Array{Int64,1}[[1, 2], [2, 3]])
	@test Plasm.ascii_LAR[87] == ([0.0 0.0 1.0 2.0 3.0 4.0 4.0; 6.0 3.0 0.0 3.0 0.0 3.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]])
	@test Plasm.ascii_LAR[88] == ([0.0 4.0 0.0 4.0; 0.0 6.0 6.0 0.0], Array{Int64,1}[[1, 2], [3, 4]])
	@test Plasm.ascii_LAR[89] == ([0.0 2.0 4.0 2.0 2.0; 6.0 2.0 6.0 2.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[90] == ([0.0 4.0 0.0 4.0; 6.0 6.0 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
	@test Plasm.ascii_LAR[91] == ([2.0 1.0 1.0 2.0; 0.0 0.0 6.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
	@test Plasm.ascii_LAR[92] == ([1.0 3.0; 6.0 0.0], Array{Int64,1}[[1, 2]])
	@test Plasm.ascii_LAR[93] == ([2.0 3.0 3.0 2.0; 0.0 0.0 6.0 6.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
	@test Plasm.ascii_LAR[94] == ([1.0 2.0 3.0; 5.0 6.0 5.0], Array{Int64,1}[[1, 2], [2, 3]])
	@test Plasm.ascii_LAR[95] == ([1.0 4.0; 0.0 0.0], Array{Int64,1}[[1, 2]])
	@test Plasm.ascii_LAR[96] == ([2.0 2.0 3.0 2.5 2.5 2.0; 4.5 5.0 6.0 4.0 4.5 4.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5], [5, 1], [1, 6], [6, 4]])
	@test Plasm.ascii_LAR[97] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10]])
	@test Plasm.ascii_LAR[98] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 0.0 0.0 1.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10], [10, 11]])
	@test Plasm.ascii_LAR[99] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]])
	@test Plasm.ascii_LAR[100] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0 3.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10], [10, 11]])
	@test Plasm.ascii_LAR[101] == ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 0.0; 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]])
	@test Plasm.ascii_LAR[102] == ([4.0 4.0 3.0 2.0 1.0 1.0 0.0 2.0; 3.0 4.0 5.0 5.0 4.0 0.0 1.0 1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [7, 8]])
	@test Plasm.ascii_LAR[103] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 -1.0 -1.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [1, 9], [9, 10], [10, 11], [11, 12]])
	@test Plasm.ascii_LAR[104] == ([4.0 4.0 3.0 1.0 0.0 0.0 0.0 1.0; 0.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [6, 7], [7, 8]])
	@test Plasm.ascii_LAR[105] == ([1.0 3.0 1.0 3.0 2.0 2.0 2.25 2.25 1.75 1.75; 0.0 0.0 3.0 3.0 0.0 3.0 3.75 4.25 4.25 3.75], Array{Int64,1}[[1, 2], [3, 4], [5, 6], [7, 8], [8, 9], [9, 10], [10, 7]])
	@test Plasm.ascii_LAR[106] == ([1.0 3.0 2.0 2.0 1.0 0.0 2.25 2.25 1.75 1.75; 3.0 3.0 3.0 0.0 -1.0 0.0 3.75 4.25 4.25 3.75], Array{Int64,1}[[1, 2], [3, 4], [4, 5], [5, 6], [7, 8], [8, 9], [9, 10], [10, 7]])
	@test Plasm.ascii_LAR[107] == ([0.0 1.0 1.0 0.0 4.0 2.0 1.0 3.0 4.0; 0.0 0.0 3.0 3.0 0.0 0.0 1.0 3.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [5, 6], [6, 7], [7, 8], [8, 9]])
	@test Plasm.ascii_LAR[108] == ([2.0 2.0 1.0 1.0 3.0; 0.0 5.0 5.0 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[109] == ([4.0 4.0 2.0 2.0 2.0 0.0 0.0 0.0; 0.0 3.0 2.0 0.0 3.0 2.0 0.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5], [5, 6], [7, 8]])
	@test Plasm.ascii_LAR[110] == ([3.0 3.0 1.0 1.0 1.0; 0.0 3.0 2.0 0.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[111] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]])
	@test Plasm.ascii_LAR[112] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 0.0 0.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 3.0 -1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10]])
	@test Plasm.ascii_LAR[113] == ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 3.0 -1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10]])
	@test Plasm.ascii_LAR[114] == ([0.0 2.0 1.0 1.0 1.0 2.0 3.0 4.0; 0.0 0.0 0.0 3.0 2.0 3.0 3.0 2.0], Array{Int64,1}[[1, 2], [3, 4], [5, 6], [6, 7], [7, 8]])
	@test Plasm.ascii_LAR[115] == ([0.0 4.0 3.0 1.0 0.0 1.0 3.0 4.0; 0.0 0.0 1.0 1.0 2.0 3.0 3.0 2.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]])
	@test Plasm.ascii_LAR[116] == ([1.0 3.0 2.0 2.0 2.0 3.0; 0.0 0.0 0.0 5.0 4.0 4.0], Array{Int64,1}[[1, 2], [3, 4], [5, 6]])
	@test Plasm.ascii_LAR[117] == ([0.0 1.0 1.0 2.0 3.0 4.0 4.0; 3.0 3.0 1.0 0.0 0.0 1.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]])
	@test Plasm.ascii_LAR[118] == ([0.0 1.0 3.0 4.0; 3.0 0.0 3.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
	@test Plasm.ascii_LAR[119] == ([0.0 0.0 1.0 2.0 3.0 4.0 4.0; 3.0 2.0 0.0 2.0 0.0 2.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]])
	@test Plasm.ascii_LAR[120] == ([0.0 1.0 4.0 1.0 4.0; 3.0 3.0 0.0 0.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5]])
	@test Plasm.ascii_LAR[121] == ([0.0 1.0 2.5 0.0 1.0 4.0; 3.0 3.0 1.5 0.0 0.0 3.0], Array{Int64,1}[[1, 2], [2, 3], [4, 5], [5, 6]])
	@test Plasm.ascii_LAR[122] == ([0.0 0.0 3.0 0.0 3.0 4.0; 2.0 3.0 3.0 0.0 0.0 1.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]])
	@test Plasm.ascii_LAR[123] == ([2.5 2.0 2.0 1.5 2.0 2.0 2.5; 6.5 6.0 3.5 3.0 2.5 0.0 -0.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]])
	@test Plasm.ascii_LAR[124] == ([2.0 2.0; 0.0 5.0], Array{Int64,1}[[1, 2]])
	@test Plasm.ascii_LAR[125] == ([1.5 2.0 2.0 2.5 2.0 2.0 1.5; 6.5 6.0 3.5 3.0 2.5 0.0 -0.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]])
	@test Plasm.ascii_LAR[126] == ([1.0 1.75 2.75 3.5; 5.0 5.5 5.0 5.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
end

@testset "ascii codes Tests 2" begin
	@test length(Plasm.hpcs)==95
	@test Plasm.hpcs[1]==Plasm.ascii32
	@test Plasm.hpcs[10]==Plasm.ascii41
	@test Plasm.hpcs[12]==Plasm.ascii43
	@test Plasm.hpcs[20]==Plasm.ascii51
	@test Plasm.hpcs[30]==Plasm.ascii61
	@test Plasm.hpcs[40]==Plasm.ascii71
	@test Plasm.hpcs[50]==Plasm.ascii81
	@test Plasm.hpcs[60]==Plasm.ascii91
	@test Plasm.hpcs[70]==Plasm.ascii101
	@test Plasm.hpcs[80]==Plasm.ascii111
	@test Plasm.hpcs[95]==Plasm.ascii126
end


@testset "constants Tests" begin
	@test Plasm.textalignment == "centre"
	@test Plasm.textangle == pi/4
	@test Plasm.textwidth == 1.0
	@test Plasm.textheight == 1.0
	@test Plasm.textspacing == 0.25
	@test Plasm.fontwidth == 4.0
	@test Plasm.fontheight == 8.0
	@test Plasm.fontspacing == 1.0
end

@testset "various Tests" begin
	charlist = "Alberto"
	@test Plasm.charpols(charlist)[2][2]==[[1, 2],[2, 3],[4, 5]]
	@test typeof(Plasm.charpols(charlist))==
	Array{Tuple{Array{Float64,2},Array{Array{Int64,1},1}},1}
	@test typeof(Plasm.charpols(charlist)[2])==
	Tuple{Array{Float64,2},Array{Array{Int64,1},1}}
	@test typeof(Plasm.charpols(charlist)[2][2])==
	Array{Array{Int64,1},1}
	@test Plasm.distr([[1,2,3],0])==[[1,0],[2,0],[3,0]]
	@test Plasm.cat([[1,2],[3,4]])==[1,2,3,4]
	@test Plasm.translate(-1)(LinearAlgebraicRepresentation.cuboid([1,1]))==
	([-1.0 -1.0 0.0 0.0; 0.0 1.0 0.0 1.0], Array{Int64,1}[[1, 2, 3, 4]])
end




