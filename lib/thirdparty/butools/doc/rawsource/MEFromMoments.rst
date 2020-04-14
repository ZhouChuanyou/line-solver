butools.ph.MEFromMoments
========================

.. currentmodule:: butools.ph

.. np:function:: MEFromMoments

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`[alpha, A] = MEFromMoments(moms)`
        * - Mathematica:
          - :code:`{alpha, A} = MEFromMoments[moms]`
        * - Python/Numpy:
          - :code:`alpha, A = MEFromMoments(moms)`

    Creates a matrix-exponential distribution that has the
    same moments as given.

    Parameters
    ----------
    moms : vector of doubles, length(2*M-1)
        The list of moments. The order of the resulting 
        matrix-exponential distribution is 
        determined based on the number of moments given. To 
        obtain a matrix exponential distribution of order M,
        2*M-1 moments are required.

    Returns
    -------
    alpha : matrix, shape (1,M)
        The initial vector of the matrix-exponential 
        distribution.
    A : matrix, shape (M,M)
        The matrix parameter of the matrix-exponential 
        distribution.

    References
    ----------
    .. [1] A. van de Liefvoort. The moment problem for 
           continuous distributions. Technical report, 
           University of Missouri, WP-CM-1990-02, Kansas City,
           1990.

    Examples
    --------
    For Matlab:
    
    >>> moms = [0.20939, 0.10449, 0.089092, 0.11027, 0.17953];
    >>> [a,A]=MEFromMoments(moms)
    >>> a
          0.33333      0.33333      0.33333
    >>> A
           -8.085       10.177      -9.9999
          -1.2584      -5.1438       1.7873
          -1.9255       1.9599      -4.9712
    >>> MomentsFromME(a,A,5)
          0.20939      0.10449     0.089092      0.11027      0.17953

    For Python/Numpy:

    >>> moms = [0.20939, 0.10449, 0.089092, 0.11027, 0.17953]
    >>> a,A=MEFromMoments(moms)
    >>> print(a)
    [[ 0.33333333  0.33333333  0.33333333]]
    >>> print(A)
    [[ -8.0849919   10.17661295  -9.99993985]
     [ -1.2584437   -5.14380868   1.78730569]
     [ -1.92545004   1.95991495  -4.97119942]]
    >>> print(MomentsFromME(a,A,5))
    [0.20938722294654494, 0.10448912014333089, 0.089091500391907275, 0.11026674096545437, 0.1795302732472091]

