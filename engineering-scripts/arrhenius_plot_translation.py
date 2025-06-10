from math import exp
# Fuck you if you use arrhenius plots.
# Convert them to actually humanly readable plots

# The horizontal axis: 1000 / T in kelvin.
x = [
    0.8517241379310345,
    0.93184584178499,
    1.0271805273833672,
    1.1448275862068966,
    1.2939148073022313,
    1.4845841784989857,
    1.7452332657200813,
]


# The vertical axis: ln(σ T)
y = [
    2.801033591731267,
    1.692506459948321,
    0.4134366925064601,
    -1.064599483204134,
    -2.883720930232558,
    -5.441860465116279,
    -8.710594315245478,
]


def fix_horizontal_axis(x: float) -> float:
    """Goes from a 1000 / T  to a T"""
    return 1000.0 / x


def invert_vertical_axis(y: float, temperature_in_kelvin: float) -> float:
    """Goes from the vertical axis: ln(σ T) to σ"""
    return exp(y) / temperature_in_kelvin


if __name__ == "__main__":
    if len(y) != len(x):
        print("Not same amount of entries in X and Y axis.")

    temperatures: list[float] = []
    sigmas: list[float] = []

    for i in range(len(y)):
        temperature_in_kelvin = fix_horizontal_axis(x[i])
        sigma = invert_vertical_axis(y[i], temperature_in_kelvin)
        temperatures.append(temperature_in_kelvin)
        sigmas.append(sigma)

    print("Temperatures:")
    print(temperatures)
    print("Y-values:")
    print(sigmas)
