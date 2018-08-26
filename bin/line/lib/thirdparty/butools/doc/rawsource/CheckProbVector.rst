butools.mc.CheckProbVector
==========================

.. currentmodule:: butools.mc

.. np:function:: CheckProbVector

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`r = CheckProbVector(pi, sub, prec)`
        * - Mathematica:
          - :code:`r = CheckProbVector[pi, sub, prec]`
        * - Python/Numpy:
          - :code:`r = CheckProbVector(pi, sub, prec)`
    
    Checks if the vector is a valid probability vector: the 
    vector has only non-negative elements, the sum of the 
    vector elements is 1.
 
    If parameter "sub" is set to true, it checks if the 
    vector is a valid substochastic vector: the vector has 
    only non-negative elements, the sum of the elements are
    less than 1.
    
    Parameters
    ----------
    pi : vector, shape (1, M) or (M, 1)
        The matrix to check.
    sub : bool, optional
        If false, the procedure checks for stochastic, if 
        true, it checks for sub-stochastic property. The 
        default value is false.
    prec : double, optional
        Numerical precision. Entries with absolute value 
        less than prec are considered to be zeros. The 
        default value is 1e-14.
        
    Returns
    -------
    r : bool
        The result of the check.

    Examples
    --------
    For Matlab:
    
    >>> pi=[0.8 0.1]
    >>> CheckProbVector(pi, true)
    1
    >>> CheckProbVector(pi)
    0

    For Mathematica:
    
    >>> pi={0.8, 0.1};
    >>> CheckProbVector[pi, True]
    True
    >>> CheckProbVector[pi]
    False
    
    For Python/Numpy:
    
    >>> pi= [[0.8, 0.1]]
    >>> CheckProbVector(pi, True)
    True
    >>> CheckProbVector(pi)
    False

