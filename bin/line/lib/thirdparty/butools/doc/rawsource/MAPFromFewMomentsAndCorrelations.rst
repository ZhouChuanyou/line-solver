butools.map.MAPFromFewMomentsAndCorrelations
============================================

.. currentmodule:: butools.map

.. np:function:: MAPFromFewMomentsAndCorrelations

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`[D0, D1] = MAPFromFewMomentsAndCorrelations(moms, corr1, r)`
        * - Mathematica:
          - :code:`{D0, D1} = MAPFromFewMomentsAndCorrelations[moms, corr1, r]`
        * - Python/Numpy:
          - :code:`D0, D1 = MAPFromFewMomentsAndCorrelations(moms, corr1, r)`

    Creates a Markovian arrival process that has the given
    2 or 3 marginal moments and lag-1 autocorrelation.
    The decay of the autocorrelation function can be optionally
    adjusted as well.
    The lag-k autocorrelation function :math:`\rho_k` of the 
    resulting MAP is :math:`\rho_k=r(corr_1/r)^k`.

    Parameters
    ----------
    moms : vector of doubles, length 2 or 3
        The list of marginal moments to match. 
    corr1 : double
        The lag-1 autocorrelation coefficient to match.
    r : double, optional
        The decay of the autocorrelation function.
    
    Returns
    -------
    D0 : matrix, shape (M,M)
        The D0 matrix of the Markovian arrival process
    D1 : matrix, shape (M,M)
        The D1 matrix of the Markovian arrival process
    
    Notes
    -----
    With 2 marginal moments, or with 3 marginal moments and 
    positive autocorrelation the procedure always returns a 
    valid Markovian representation.

    References
    ----------
    .. [1] G Horvath, "Matching marginal moments and lag 
           autocorrelations with MAPs," ValueTools 2013, 
           Torino, Italy (2013).

    Examples
    --------
    For Matlab:
    
    >>> moms = [1.1, 6.05];
    >>> corr1 = -0.17;
    >>> [D0,D1]=MAPFromFewMomentsAndCorrelations(moms, corr1);
    >>> D0
         -0.28494      0.28494            0            0
                0      -18.134            0            0
                0            0     -0.28494      0.28494
                0            0            0     -0.95707
    >>> D1
                0            0            0            0
         0.022795       1.4279       4.9669       11.716
                0            0            0            0
         0.013835      0.86667     0.022795     0.053771
    >>> MarginalMomentsFromMAP(D0,D1,2)
              1.1         6.05
    >>> LagCorrelationsFromMAP(D0,D1,1)
            -0.17
    >>> moms = [1.2, 4.32, 20];
    >>> corr1 = 0.4;
    >>> [D0,D1]=MAPFromFewMomentsAndCorrelations(moms, corr1);
    >>> D0
         -0.54184      0.54184            0            0            0            0            0            0            0
                0      -116.34            0            0            0            0            0            0            0
                0            0     -0.24417      0.24417            0            0            0            0            0
                0            0            0       -2.014        2.014            0            0            0            0
                0            0            0            0       -2.014        2.014            0            0            0
                0            0            0            0            0       -2.014        2.014            0            0
                0            0            0            0            0            0       -2.014        2.014            0
                0            0            0            0            0            0            0       -2.014        2.014
                0            0            0            0            0            0            0            0       -2.014
    >>> D1
                0            0            0            0            0            0            0            0            0
           16.128       88.575     0.099774       11.534            0            0            0            0            0
                0            0            0            0            0            0            0            0            0
                0            0            0            0            0            0            0            0            0
                0            0            0            0            0            0            0            0            0
                0            0            0            0            0            0            0            0            0
                0            0            0            0            0            0            0            0            0
                0            0            0            0            0            0            0            0            0
         0.062048      0.34076     0.013818       1.5974            0            0            0            0            0
    >>> MarginalMomentsFromMAP(D0,D1,2)
              1.2         4.32           20
    >>> LagCorrelationsFromMAP(D0,D1,1)
              0.4

    For Python/Numpy
    
    >>> moms = [1.1, 6.05]
    >>> corr1 = -0.17
    >>> [D0,D1]=MAPFromFewMomentsAndCorrelations(moms, corr1)
    >>> print(D0)
    [[ -0.28493894   0.28493894   0.           0.        ]
     [ -0.         -18.13383801   0.           0.        ]
     [  0.           0.          -0.28493894   0.28493894]
     [  0.           0.          -0.          -0.95707108]]
    >>> print(D1)
    [[  0.           0.           0.           0.        ]
     [  0.02279512   1.42791193   4.96689722  11.71623375]
     [  0.           0.           0.           0.        ]
     [  0.01383548   0.86666992   0.02279512   0.05377057]]
    >>> print(MarginalMomentsFromMAP(D0,D1,2))
    [1.0999999999999996, 6.0499999999999963]
    >>> print(LagCorrelationsFromMAP(D0,D1,1))
    -0.17
    >>> moms = [1.2, 4.32, 20]
    >>> corr1 = 0.4
    >>> [D0,D1]=MAPFromFewMomentsAndCorrelations(moms, corr1)
    >>> print(D0)
    [[  -0.54183831    0.54183831    0.            0.            0.            0.     0.            0.            0.        ]
     [   0.         -116.33647359    0.            0.            0.            0.     0.            0.            0.        ]
     [   0.            0.           -0.24417077    0.24417077    0.            0.     0.            0.            0.        ]
     [   0.            0.            0.           -2.01402757    2.01402757     0.            0.            0.            0.        ]
     [   0.            0.            0.            0.           -2.01402757     2.01402757    0.            0.            0.        ]
     [   0.            0.            0.            0.            0.    -2.01402757    2.01402757    0.            0.        ]
     [   0.            0.            0.            0.            0.            0.    -2.01402757    2.01402757    0.        ]
     [   0.            0.            0.            0.            0.            0.     0.           -2.01402757    2.01402757]
     [   0.            0.            0.            0.            0.            0.     0.            0.           -2.01402757]]
    >>> print(D1)
    [[  0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  1.61283132e+01   8.85745130e+01   9.97738996e-02   1.15338735e+01    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]
     [  6.20477376e-02   3.40757777e-01   1.38183583e-02   1.59740370e+00    0.00000000e+00   0.00000000e+00   0.00000000e+00   0.00000000e+00    0.00000000e+00]]
    >>> print(MarginalMomentsFromMAP(D0,D1,3,1e-13))
    [1.2, 4.3199999999999985, 19.999999999999851]
    >>> print(LagCorrelationsFromMAP(D0,D1,1,1e-13))
    0.4

    
