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
ipopt_solver = JuMP.with_optimizer(Ipopt.Optimizer, tol=1e-6, print_level=0)
ipopt_ws_solver = JuMP.with_optimizer(Ipopt.Optimizer, tol=1e-6, mu_init=1e-4, print_level=0)

#cbc_solver = JuMP.with_optimizer(Cbc.Optimizer, logLevel=0)
#xmip_solver = JuMP.with_optimizer(AmplNLWriter.Optimizer, Ipopt.amplexe, ["print_level=0"])   # prueba corre con Ipopt
#xmip_solver = JuMP.with_optimizer(AmplNLWriter.Optimizer,"/Users/Edward/Downloads/couenne-osx/couenne", ["tol=1e-4", "print_level=0"])
xmip_solver = JuMP.with_optimizer(AmplNLWriter.Optimizer,"cplex") #for windows
#xmip_solver = JuMP.with_optimizer(AmplNLWriter.Optimizer,"/Users/Edward/Downloads/bonmin-osx/bonmin", ["print_level=0"])
#xnl_solver=JuMP.with_optimizer(AmplNLWriter.Optimizer,"couenne", ["tol=1e-4", "print_level=0"])
xnl_solver=JuMP.with_optimizer(Ipopt.Optimizer, tol=1e-4, print_level=0)

#juniper_solver = JuMP.with_optimizer(Juniper.Optimizer, nl_solver=xnl_solver, mip_solver=xmip_solver, log_levels=[])
juniper_solver = JuMP.with_optimizer(Juniper.Optimizer, nl_solver=xnl_solver, mip_solver=xmip_solver, log_levels=[])
scs_solver = JuMP.with_optimizer(SCS.Optimizer, max_iters=500000, acceleration_lookback=1, verbose=0)

#include("common.jl")
network_data = PowerModels.parse_file("data/matpower/case3_tnep.m")
#PowerModels.print_summary(network_data)


#ACPPowerModel
#DCPPowerModel
#DCPLLPowerModel
#SOCWRPowerModel
#QCWRPowerModel
#QCWRTriPowerModel


result = run_tnep(network_data,QCWRTriPowerModel , juniper_solver,setting = Dict("output" => Dict("branch_flows" => true)))
PowerModels.print_summary(result["solution"])