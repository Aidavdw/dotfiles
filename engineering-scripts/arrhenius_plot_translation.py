from math import exp
# Fuck you if you use arrhenius plots.
# Convert them to actually humanly readable plots


# The horizontal axis: 1000 / T in kelvin.
xs = [
    0.8517241379310345,
    0.9308316430020285,
    1.0281947261663287,
    1.1438133874239351,
    1.2939148073022313,
    1.4866125760649087,
    1.7452332657200813,
]

# The vertical axis: ln(σ T)
ys = [
    12.550387596899224,
    12.465116279069768,
    12.322997416020673,
    12.180878552971578,
    12.038759689922482,
    11.811369509043928,
    11.527131782945737,
]


def fix_horizontal_axis(x: float) -> float:
    """Goes from a 1000 / T  to a T"""
    return 1000.0 / x


def invert_vertical_axis(y: float, temperature_in_kelvin: float) -> float:
    """Goes from the vertical axis: ln(σ T) to σ"""
    return exp(y) / temperature_in_kelvin


if __name__ == "__main__":
    if len(ys) != len(xs):
        print("Not same amount of entries in X and Y axis.")

    temperatures: list[float] = []
    sigmas: list[float] = []

    for i in range(len(ys)):
        x = xs[i]
        temperature_in_kelvin = fix_horizontal_axis(x)
        y = ys[i]
        sigma = invert_vertical_axis(y, temperature_in_kelvin)
        temperatures.append(temperature_in_kelvin)
        sigmas.append(sigma)

    print("Temperatures:")
    print(temperatures)
    print("Y-values:")
    print(sigmas)
