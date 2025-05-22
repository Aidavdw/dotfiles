import matplotlib.pyplot as plt
# Simply plots the mesh convergence.

# First, the value you are trying to check the error of, at your highest resolution case:
f_ref: float = 800

# Add here your normalised grid spacings:
# (The distance between two cell centers)
# n = <size of a cell/element in this configuration> / <size of a cell/element in finest configuration>
# Your finest grid will have n = 1 by convention.
# Now run your model at coarser grids.
# twice as coarse ￫ n = 2
# twice as course as that one ￫ n = 4
# Recommend doing it in steps of 2, for ease.
normalised_grid_spacings: list[float] = [2.0, 4.0, 8.0]

# Fill in some 'metric' here for all your normalised grid spacings. This is a thing you want to minimise the error of.
# e.g. temperature, current density, whatever.
f_metric: list[float] = [802.0, 806.0, 820.0]


## END OF INPUT SEGMENT ##


# Usually denoted as epsilon.
def rel_err(f_n: float, f_ref: float) -> float:
    return (f_n - f_ref) / f_ref


# Calculate the relative change in value over a mesh change
rel_changes = [rel_err(f_n, f_ref) for f_n in f_metric]


_ = plt.loglog(normalised_grid_spacings, rel_changes, marker="o", linestyle="-")
_ = plt.xlabel("X Axis (log scale)")
_ = plt.ylabel("Y Axis (log scale)")
_ = plt.grid(True, which="both", ls="--")
_ = plt.show()
