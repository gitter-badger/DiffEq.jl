######
##FEM Heat Δt Convergence Tests
######
using DiffEq

T = 1
Δx = 1//2^(6)
N = 4
topΔt = 8
pdeProb = heatProblemExample_moving() #also try heatProblemExample_pure() or heatProblemExample_diffuse()

#=
alg = "Euler" #Unstable due to μ
solutions = cell(N)
for i = 1:N
  Δt = 1//2^(topΔt-i)
  femMesh = parabolic_squaremesh([0 1 0 1],Δx,Δt,T,"Dirichlet")
  res = fem_solveheat(femMesh::FEMmesh,pdeProb,alg=alg)
  solutions[i] = res
end
simres = ConvergenceSimulation(solutions)
convplot_fullΔt(simres,titleStr="Euler Convergence Plots",savefile="eulerdtconv.svg")
=#

alg = "ImplicitEuler"
solutions = cell(N)
for i = 1:N
  Δt = 1//2^(topΔt-i)
  femMesh = parabolic_squaremesh([0 1 0 1],Δx,Δt,T,"Dirichlet")
  res = fem_solveheat(femMesh::FEMmesh,pdeProb,alg=alg,solver="LU")
  solutions[i] = res
end
simres2 = ConvergenceSimulation(solutions)
convplot_fullΔt(simres2,titleStr="Implicit Euler Convergence Plots",savefile="impeulerdtconv.svg")

alg = "CrankNicholson" #Bound by spatial discretization error at low Δt, decrease Δx for full convergence
solutions = cell(N)
for i = 1:N
  Δt = 1//2^(topΔt-i)
  femMesh = parabolic_squaremesh([0 1 0 1],Δx,Δt,T,"Dirichlet")
  res = fem_solveheat(femMesh::FEMmesh,pdeProb,alg=alg,solver="GMRES") #LU faster, but GMRES more stable
  solutions[i] = res
end
simres3 = ConvergenceSimulation(solutions)
convplot_fullΔt(simres3,titleStr="Crank-Nicholson Convergence Plots",savefile="crankdtconv.svg")
