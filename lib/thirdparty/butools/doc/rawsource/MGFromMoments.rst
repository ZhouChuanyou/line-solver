butools.dph.MGFromMoments
=========================

.. currentmodule:: butools.dph

.. np:function:: MGFromMoments

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`[alpha, A] = MGFromMoments(moms)`
        * - Mathematica:
          - :code:`{alpha, A} = MGFromMoments[moms]`
        * - Python/Numpy:
          - :code:`alpha, A = MGFromMoments(moms)`

    Creates a matrix-geometric distribution that has the
    same moments as given.

    Parameters
    ----------
    moms : vector of doubles
        The list of moments. The order of the resulting 
        matrix-geometric distribution is 
        determined based on the number of moments given. To 
        obtain a matrix-geometric distribution of order M,
        2*M-1 moments are required.

    Returns
    -------
    alpha : vector, shape (1,M)
        The initial vector of the matrix-geometric 
        distribution.
    A : matrix, shape (M,M)
        The matrix parameter of the matrix-geometric 
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
    
    >>> moms = [3.4675, 16.203, 97.729, 731.45, 6576.8];
    >>> [a,A]=MGFromMoments(moms)
    >>> a
          0.33333      0.33333      0.33333
    >>> A
          0.26191       3.6937      -2.5821
        -0.025302   -0.0056997      0.66959
        -0.030408    0.0073107      0.66695
    >>> MomentsFromMG(a,A,5)
           3.4675       16.203       97.729       731.45       6576.8
           
    For Python/Numpy:
    
    >>> moms = [3.4675, 16.203, 97.729, 731.45, 6576.8]
    >>> a,A=MGFromMoments(moms)
    >>> print(a)
    [[ 0.33333333  0.33333333  0.33333333]]    
    >>> print(A)
    [[ 0.26190621  3.69367602 -2.58213389]
     [-0.02530173 -0.00569967  0.66958705]
     [-0.03040818  0.00731073  0.66694767]]
    >>> print(MomentsFromMG(a,A,5))
    [3.4674999999999931, 16.203000000000046, 97.729000000001236, 731.45000000001903, 6576.8000000002794]

