# -*- coding: utf-8 *-*


def lostf(x):
    """
    Fonction de X qui renvoie, pour x < 7 les valeurs de "Lost":
    4 8 15 16 23 42

    >>> lostf(1.0)
    4.0
    >>> lostf(3.0)
    15.0
    """

    return (
        60.0 -
        ((612.0 * x) / 5.0) +
        ((367.0 * x * x) / 4.0) -
        ((235.0 * x * x * x) / 8.0) +
        ((17.0 * x * x * x * x) / 4.0) -
        ((9.0 * x * x * x * x * x) / 40.0)
    )

message = "Intox"

for l in message:
    i = ord(l)
    print i, lostf(i)
