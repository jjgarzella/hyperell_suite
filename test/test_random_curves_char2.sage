"""
test_random_curves_char2.sage — Unit tests for char 2 curve generation in random_curves.sage.

Run from the repo root via:
    sage test/runtests.sage
"""

import unittest

load('random_generation/random_curves.sage')


class TestRandomHyperellipticChar2OddDegree(unittest.TestCase):

    def _check_curve(self, C, expected_genus, expected_f_degree, expected_h_degree):
        """Assert all structural properties of a char 2 generated curve."""
        f, h = C.hyperelliptic_polynomials()
        self.assertEqual(C.genus(), expected_genus,
                         f"Expected genus {expected_genus}, got {C.genus()}")
        self.assertEqual(f.degree(), expected_f_degree,
                         f"Expected deg(f)={expected_f_degree}, got {f.degree()}")
        self.assertEqual(h.degree(), expected_h_degree,
                         f"Expected deg(h)={expected_h_degree}, got {h.degree()}")
        self.assertTrue(f.is_monic(), f"f is not monic: {f}")
        self.assertTrue(h.is_monic(), f"h is not monic: {h}")
        self.assertTrue(f.is_squarefree(), f"f is not squarefree: {f}")
        self.assertTrue(h.is_squarefree(), f"h is not squarefree: {h}")
        self.assertEqual(gcd(h, f), 1, f"gcd(h, f) != 1: h={h}, f={f}")

    def test_genus2(self):
        for _ in range(5):
            C = random_hyperelliptic_char2_odd_degree(2)
            self._check_curve(C, expected_genus=2, expected_f_degree=5, expected_h_degree=2)

    def test_genus3(self):
        for _ in range(5):
            C = random_hyperelliptic_char2_odd_degree(3)
            self._check_curve(C, expected_genus=3, expected_f_degree=7, expected_h_degree=3)

    def test_genus1(self):
        for _ in range(5):
            C = random_hyperelliptic_char2_odd_degree(1)
            self._check_curve(C, expected_genus=1, expected_f_degree=3, expected_h_degree=1)


class TestRandomHyperellipticChar2EvenDegree(unittest.TestCase):

    def _check_curve(self, C, expected_genus, expected_f_degree, expected_h_degree):
        f, h = C.hyperelliptic_polynomials()
        self.assertEqual(C.genus(), expected_genus,
                         f"Expected genus {expected_genus}, got {C.genus()}")
        self.assertEqual(f.degree(), expected_f_degree,
                         f"Expected deg(f)={expected_f_degree}, got {f.degree()}")
        self.assertEqual(h.degree(), expected_h_degree,
                         f"Expected deg(h)={expected_h_degree}, got {h.degree()}")
        self.assertTrue(f.is_monic(), f"f is not monic: {f}")
        self.assertTrue(h.is_monic(), f"h is not monic: {h}")
        self.assertTrue(f.is_squarefree(), f"f is not squarefree: {f}")
        self.assertTrue(h.is_squarefree(), f"h is not squarefree: {h}")
        self.assertEqual(gcd(h, f), 1, f"gcd(h, f) != 1: h={h}, f={f}")

    def test_genus2(self):
        for _ in range(5):
            C = random_hyperelliptic_char2_even_degree(2)
            self._check_curve(C, expected_genus=2, expected_f_degree=6, expected_h_degree=3)

    def test_genus3(self):
        for _ in range(5):
            C = random_hyperelliptic_char2_even_degree(3)
            self._check_curve(C, expected_genus=3, expected_f_degree=8, expected_h_degree=4)

    def test_genus1(self):
        for _ in range(5):
            C = random_hyperelliptic_char2_even_degree(1)
            self._check_curve(C, expected_genus=1, expected_f_degree=4, expected_h_degree=2)


class TestRandomHyperellipticWrapperChar2(unittest.TestCase):

    def test_odd_degree_dispatches_to_char2(self):
        C = random_hyperelliptic(2, 5)
        f, h = C.hyperelliptic_polynomials()
        self.assertEqual(C.base_ring().characteristic(), 2)
        self.assertEqual(f.degree(), 5)
        self.assertEqual(C.genus(), 2)
        self.assertNotEqual(h, 0)

    def test_even_degree_dispatches_to_char2(self):
        C = random_hyperelliptic(2, 6)
        f, h = C.hyperelliptic_polynomials()
        self.assertEqual(C.base_ring().characteristic(), 2)
        self.assertEqual(f.degree(), 6)
        self.assertEqual(C.genus(), 2)
        self.assertNotEqual(h, 0)
