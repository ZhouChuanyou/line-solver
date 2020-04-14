butools.ph.CheckMEPositiveDensity
=================================

.. currentmodule:: butools.ph

.. np:function:: CheckMEPositiveDensity

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`r = CheckMEPositiveDensity(alpha, A, maxSize, prec)`
        * - Mathematica:
          - :code:`r = CheckMEPositiveDensity[alpha, A, maxSize, prec]`
        * - Python/Numpy:
          - :code:`r = CheckMEPositiveDensity(alpha, A, maxSize, prec)`

    Checks if the given matrix-exponential distribution has 
    positive density.

    Parameters
    ----------
    alpha : matrix, shape (1,M)
        Initial vector of the matrix-exponential distribution 
        to check
    A : matrix, shape (M,M)
        Matrix parameter of the matrix-exponential distribution
        to check
    maxSize : int, optional
        The procedure tries to transform the ME distribution
        to phase-type up to order maxSize. The default value
        is 100.
    prec : double, optional
        Numerical precision. The default value is 1e-14.

    Returns
    -------
    r : bool
        True, if the given matrix-exponential distribution has
        a positive density

    Notes
    -----
    This procedure calls MonocyclicPHFromME, and can be time 
    consuming. 

    Examples
    --------
    For Matlab:
    
    >>> a = [0.2, 0.3, 0.5];
    >>> A = [-1,0,0;0,-3,2;0,-2,-3];
    >>> CheckMEPositiveDensity(a,A)
     1
    >>> a = [0.2, 0.3, 0.5];
    >>> A = [-1,0,0;0,-3,2.9;0,-2.9,-3];
    >>> CheckMEPositiveDensity(a,A)
     0
    >>> PdfFromME(a,A,1.0)
     -0.049993
     
    For Python/Numpy:

    >>> a = ml.matrix([[0.2, 0.3, 0.5]])
    >>> A = ml.matrix([[-1,0,0],[0,-3,2],[0,-2,-3]])
    >>> print(CheckMEPositiveDensity(a,A))
    True
    >>> a = ml.matrix([[0.2, 0.3, 0.5]])
    >>> A = ml.matrix([[-1,0,0],[0,-3,2.9],[0,-2.9,-3]])
    >>> print(CheckMEPositiveDensity(a,A))
    False
    >>> print(PdfFromME(a,A,[1.0]))
    [-0.04999295]

