"""
random_curves.sage — Generate random hyperelliptic curves over F_p.

Odd characteristic (p > 2):
    Curves in the form y^2 = f(x) (h = 0), where f is monic, depressed
    (x^(d-1) coefficient is zero), and squarefree.

Characteristic 2 (p = 2):
    Curves in the form y^2 + h(x)y = f(x), where h is monic and squarefree
    and f is monic and squarefree, with gcd(h, f) = 1.
    The depressed condition is not applied in characteristic 2 because it
    rules out too many squarefree polynomials over small fields.
    Degrees: deg(h) = g for odd-degree f, deg(h) = g+1 for even-degree f.

Provides:
    random_hyperelliptic_odd_degree(p, g)        -> HyperellipticCurve, degree 2g+1
    random_hyperelliptic_even_degree(p, g)       -> HyperellipticCurve, degree 2g+2
    random_hyperelliptic_char2_odd_degree(g)     -> HyperellipticCurve over GF(2), degree 2g+1
    random_hyperelliptic_char2_even_degree(g)    -> HyperellipticCurve over GF(2), degree 2g+2
    random_hyperelliptic(p, d)                   -> HyperellipticCurve, degree d
"""


def _random_monic_depressed_squarefree(R, d):
    """
    Return a random monic depressed squarefree polynomial of degree d in R = F_p[x].

    'Monic'     : leading coefficient is 1.
    'Depressed' : coefficient of x^(d-1) is 0.

    Retries until squarefree; expected attempts ~ p/(p-1).
    """
    F = R.base_ring()
    x = R.gen()
    while True:
        # Build coefficient list in ascending order: [c_0, c_1, ..., c_{d-2}, 0, 1]
        coeffs = [F.random_element() for _ in range(d - 1)] + [F(0), F(1)]
        f = R(coeffs)
        if f.is_squarefree():
            return f


def random_hyperelliptic_odd_degree(p, g):
    """
    Generate a random genus-g hyperelliptic curve y^2 = f(x) over F_p,
    where f has odd degree d = 2g+1.

    f is monic, depressed, and squarefree.

    Parameters
    ----------
    p : prime (must be odd)
    g : genus (integer >= 1)

    Returns
    -------
    HyperellipticCurve over GF(p)
    """
    F = GF(p)
    R = PolynomialRing(F, 'x')
    d = 2 * g + 1
    f = _random_monic_depressed_squarefree(R, d)
    return HyperellipticCurve(f)


def random_hyperelliptic_even_degree(p, g):
    """
    Generate a random genus-g hyperelliptic curve y^2 = f(x) over F_p,
    where f has even degree d = 2g+2.

    f is monic, depressed, and squarefree.

    Note: with monic f of even degree, there are two points at infinity
    defined over F_p.

    Parameters
    ----------
    p : prime (must be odd)
    g : genus (integer >= 1)

    Returns
    -------
    HyperellipticCurve over GF(p)
    """
    F = GF(p)
    R = PolynomialRing(F, 'x')
    d = 2 * g + 2
    f = _random_monic_depressed_squarefree(R, d)
    return HyperellipticCurve(f)


def _random_monic_squarefree(R, d):
    """
    Return a random monic squarefree polynomial of degree d in R.

    No constraint on the x^(d-1) coefficient (unlike the depressed variant).
    Used for characteristic 2 where the depressed condition is too restrictive.
    """
    F = R.base_ring()
    while True:
        coeffs = [F.random_element() for _ in range(d)] + [F(1)]
        f = R(coeffs)
        if f.is_squarefree():
            return f


def random_hyperelliptic_char2_odd_degree(g):
    """
    Generate a random genus-g hyperelliptic curve y^2 + h(x)y = f(x) over GF(2),
    where f has odd degree d = 2g+1 and h has degree g.

    h is monic and squarefree; f is monic and squarefree; gcd(h, f) = 1.

    Parameters
    ----------
    g : genus (integer >= 1)

    Returns
    -------
    HyperellipticCurve over GF(2)
    """
    F = GF(2)
    R = PolynomialRing(F, 'x')
    d = 2 * g + 1
    while True:
        h = _random_monic_squarefree(R, g)
        f_coeffs = [F.random_element() for _ in range(d)] + [F(1)]
        f = R(f_coeffs)
        if not (f.is_squarefree() and gcd(h, f) == 1):
            continue
        try:
            C = HyperellipticCurve(f, h)
            if C.genus() == g:
                return C
        except ValueError:
            continue  # singular curve (e.g. over algebraic closure), retry


def random_hyperelliptic_char2_even_degree(g):
    """
    Generate a random genus-g hyperelliptic curve y^2 + h(x)y = f(x) over GF(2),
    where f has even degree d = 2g+2 and h has degree g+1.

    h is monic and squarefree; f is monic and squarefree; gcd(h, f) = 1.

    Parameters
    ----------
    g : genus (integer >= 1)

    Returns
    -------
    HyperellipticCurve over GF(2)
    """
    F = GF(2)
    R = PolynomialRing(F, 'x')
    d = 2 * g + 2
    while True:
        h = _random_monic_squarefree(R, g + 1)
        f_coeffs = [F.random_element() for _ in range(d)] + [F(1)]
        f = R(f_coeffs)
        if not (f.is_squarefree() and gcd(h, f) == 1):
            continue
        try:
            C = HyperellipticCurve(f, h)
            if C.genus() == g:
                return C
        except ValueError:
            continue  # singular curve (e.g. over algebraic closure), retry


def random_hyperelliptic(p, d):
    """
    Generate a random hyperelliptic curve over F_p where f has the given degree d.

    For odd p: y^2 = f(x), f monic, depressed, squarefree.
    For p = 2: y^2 + h(x)y = f(x), h and f monic and squarefree, gcd(h,f) = 1.

    The genus is g = floor((d-1) / 2).

    Parameters
    ----------
    p : prime
    d : degree of f (integer >= 3)

    Returns
    -------
    HyperellipticCurve over GF(p)

    Raises
    ------
    ValueError if d < 3
    """
    if d < 3:
        raise ValueError(f"degree d must be >= 3 for a hyperelliptic curve, got {d}")

    g = (d - 1) // 2

    if p == 2:
        if d % 2 == 1:
            return random_hyperelliptic_char2_odd_degree(g)
        else:
            return random_hyperelliptic_char2_even_degree(g)
    else:
        if d % 2 == 1:
            return random_hyperelliptic_odd_degree(p, g)
        else:
            return random_hyperelliptic_even_degree(p, g)


# ---------------------------------------------------------------------------
# Usage examples
# ---------------------------------------------------------------------------
# sage: load('random_generation/random_curves.sage')
# sage: C = random_hyperelliptic(7, 5)   # odd p, genus 2, degree 5
# sage: C
# Hyperelliptic Curve over Finite Field of size 7 defined by y^2 = x^5 + ...
# sage: C.genus()
# 2
# sage: C = random_hyperelliptic(2, 5)   # char 2, genus 2, degree 5
# sage: C
# Hyperelliptic Curve over Finite Field of size 2 defined by y^2 + (...)y = x^5 + ...
