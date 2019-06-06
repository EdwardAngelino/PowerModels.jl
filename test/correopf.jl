
using PowerModels
using AmplNLWriter
import InfrastructureModels
import Memento

# Suppress warnings during testing.
Memento.setlevel!(Memento.getlogger(InfrastructureModels), "error")
Memento.setlevel!(Memento.getlogger(PowerModels), "error")

# for checking status codes
import MathOptInterface
const MOI = MathOptInterface

import Cbc
import Ipopt
import SCS
import Juniper

import JuMP
import JSON

import LinearAlgebra
using Test

# default setup for solvers
#ipopt_solver = JuMP.with_optimizer(Ipopt.Optimizer, tol=1e-6, print_level=0)
#ipopt_solver = JuMP.with_optimizer(AmplNLWriter.Optimizer,"couenne", ["tol=1e-4", "print_level=0"])
ipopt_solver = JuMP.with_optimizer(AmplNLWriter.Optimizer,"bonmin", ["tol=1e-4", "print_level=0"])

ipopt_ws_solver = JuMP.with_optimizer(Ipopt.Optimizer, tol=1e-6, mu_init=1e-4, print_level=0)

scs_solver = JuMP.with_optimizer(SCS.Optimizer, max_iters=500000, acceleration_lookback=1, verbose=0)


#data = PowerModels.parse_file("data/matpower/case3.m")
data = PowerModels.parse_file("data/pti/case3.raw"; import_all=true)
PowerModels.print_summary(data)

print("resultados\n-----------------\n")
result = run_ac_opf(data, ipopt_solver,setting = Dict("output" => Dict("branch_flows" => true)))
#result = run_opf(data, QCWRPowerModel,  ipopt_solver,setting = Dict("output" => Dict("branch_flows" => true)))
#PowerModels.print_summary(result["solution"])
