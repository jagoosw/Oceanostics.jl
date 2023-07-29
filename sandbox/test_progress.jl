using Revise
using Oceananigans
using Oceanostics
using Oceanostics.ProgressMessengers

grid = RectilinearGrid(size=(4, 5, 6), extent=(1, 1, 1));
model = NonhydrostaticModel(; grid);
simulation = Simulation(model, Δt=1, stop_time=10);

progress_messenger(simulation) = @info (Iteration() + Time()
                                        + Walltime() + MaxVelocities() + AdvectiveCFLNumber() 
                                        + DiffusiveCFLNumber() + MaxViscosity() + WalltimePerTimestep()
                                        )(simulation)
simulation.callbacks[:progress] = Callback(progress_messenger)

run!(simulation)
