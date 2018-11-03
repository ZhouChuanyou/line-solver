butools.map.MAP2CorrelationBounds
=================================

.. currentmodule:: butools.map

.. np:function:: MAP2CorrelationBounds

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`[lb, ub] = MAP2CorrelationBounds(moms)`
        * - Mathematica:
          - :code:`{lb, ub} = MAP2CorrelationBounds[moms]`
        * - Python/Numpy:
          - :code:`lb, ub = MAP2CorrelationBounds(moms)`

    Returns the upper and lower correlation bounds for a MAP(2)
    given the three marginal moments.

    !!!TO CHECK!!!

    Parameters
    ----------
    moms : vector, length(3)
        First three marginal moments of the inter-arrival times

    Returns
    -------
    lb : double
        Lower correlation bound
    ub : double
        Upper correlation bound

    References
    ----------
    .. [1] L Bodrog, A Heindl, G Horvath, M Telek, "A Markovian
           Canonical Form of Second-Order Matrix-Exponential 
           Processes," EUROPEAN JOURNAL OF OPERATIONAL RESEARCH
           190:(2) pp. 459-477. (2008)
           
    Examples
    --------
    For Matlab:
    
    >>> moms = [0.04918, 0.0052609, 0.00091819];
    >>> [lb,ub]=MAP2CorrelationBounds(moms);
    >>> lb
        -0.030588
    >>> ub
         0.074506    

    For Python/Numpy:
    
    >>> moms = [0.049180327868852472, 0.005260932876133214, 0.00091818676015607825]
    >>> [lb,ub]=MAP2CorrelationBounds(moms)
    >>> print(lb)
    -0.0305881459726
    >>> print(ub)
    0.0745055540504

