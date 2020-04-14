butools.dmap.MarginalMomentsFromDMAP
====================================

.. currentmodule:: butools.dmap

.. np:function:: MarginalMomentsFromDMAP

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`moms = MarginalMomentsFromDMAP(D0, D1, K, precision)`
        * - Mathematica:
          - :code:`moms = MarginalMomentsFromDMAP[D0, D1, K, precision]`
        * - Python/Numpy:
          - :code:`moms = MarginalMomentsFromDMAP(D0, D1, K, precision)`

    Returns the moments of the marginal distribution of a 
    discrete Markovian arrival process.

    Parameters
    ----------
    D0 : matrix, shape (M,M)
        The D0 matrix of the discrete Markovian arrival process
    D1 : matrix, shape (M,M)
        The D1 matrix of the discrete Markovian arrival process
    K : int, optional
        Number of moments to compute. If K=0, 2*M-1 moments
        are computed. The default value is K=0.
    precision : double, optional
        Numerical precision for checking if the input is valid.
        The default value is 1e-14

    Returns
    -------
    moms : row vector of doubles, length K
        The vector of moments.

    Examples
    ========
    For Matlab:

    >>> D0 = [0, 0.02, 0, 0; 0, 0.17, 0.2, 0.14; 0.16, 0.17, 0.02, 0.18; 0, 0, 0, 0.12];
    >>> D1 = [0, 0.88, 0.1, 0; 0.18, 0.07, 0.14, 0.1; 0.13, 0.15, 0.15, 0.04; 0.31, 0.18, 0.12, 0.27];
    >>> moms = MarginalMomentsFromDMAP(D0, D1);
    >>> disp(moms);
      Columns 1 through 6
           1.4955       2.9542       7.8852       27.282       116.17       587.04
      Column 7
             3437

    For Mathematica:

    >>> D0 = {{0, 0.02, 0, 0},{0, 0.17, 0.2, 0.14},{0.16, 0.17, 0.02, 0.18},{0, 0, 0, 0.12}};
    >>> D1 = {{0, 0.88, 0.1, 0},{0.18, 0.07, 0.14, 0.1},{0.13, 0.15, 0.15, 0.04},{0.31, 0.18, 0.12, 0.27}};
    >>> moms = MarginalMomentsFromDMAP[D0, D1];
    >>> Print[moms];
    {1.4955358592094412, 2.9542479654368474, 7.885226907678561, 27.282328108669493, 116.17171481905851, 587.0447802480243, 3437.0301824147914}

    For Python/Numpy:

    >>> D0 = ml.matrix([[0, 0.02, 0, 0],[0, 0.17, 0.2, 0.14],[0.16, 0.17, 0.02, 0.18],[0, 0, 0, 0.12]])
    >>> D1 = ml.matrix([[0, 0.88, 0.1, 0],[0.18, 0.07, 0.14, 0.1],[0.13, 0.15, 0.15, 0.04],[0.31, 0.18, 0.12, 0.27]])
    >>> moms = MarginalMomentsFromDMAP(D0, D1)
    >>> print(moms)
    [1.4955358592094412, 2.9542479654368474, 7.885226907678561, 27.282328108669493, 116.17171481905851, 587.04478024802427, 3437.0301824147914]

