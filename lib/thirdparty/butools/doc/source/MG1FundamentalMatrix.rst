butools.mam.MG1FundamentalMatrix
================================

.. currentmodule:: butools.mam

.. np:function:: MG1FundamentalMatrix

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`G = MG1FundamentalMatrix(A, precision, maxNumIt, method)`
        * - Mathematica:
          - :code:`G = MG1FundamentalMatrix[A, precision, maxNumIt, method]`
        * - Python/Numpy:
          - :code:`G = MG1FundamentalMatrix(A, precision, maxNumIt, method)`

    Returns matrix G corresponding to the M/G/1 type Markov
    chain defined by matrices A.
    
    Matrix G is the minimal non-negative solution of the 
    following matrix equation:
    
    .. math::
        G = A_0 + A_1 G + A_2 G^2 + A_3 G^3 + \dots.
    
    The implementation is based on [1]_, please cite it if
    you use this method.
    
    Parameters
    ----------
    A : length(M) list of matrices of shape (N,N)
        Matrix blocks of the M/G/1 type generator from
        0 to M-1.
    precision : double, optional
        Matrix G is computed iteratively up to this
        precision. The default value is 1e-14
    maxNumIt : int, optional
        The maximal number of iterations. The default value
        is 50.
    method : {"CR", "RR", "NI", "FI", "IS"}, optional
        The method used to solve the matrix-quadratic
        equation (CR: cyclic reduction, RR: Ramaswami
        reduction, NI: Newton iteration, FI: functional
        iteration, IS: invariant subspace method). The 
        default is "CR".
    
    Returns
    -------
    G : matrix, shape (N,N)
        The G matrix of the M/G/1 type Markov chain.
        (G is stochastic.)
    
    References
    ----------
    .. [1] Bini, D. A., Meini, B., Steffé, S., Van Houdt,
           B. (2006, October). Structured Markov chains 
           solver: software tools. In Proceeding from the
           2006 workshop on Tools for solving structured 
           Markov chains (p. 14). ACM.

    Examples
    ========
    For Matlab:

    >>> A0 = [0.4, 0.2; 0.3, 0.4];
    >>> A1 = [0., 0.1; 0., 0.];
    >>> A2 = [0., 0.2; 0., 0.2];
    >>> A3 = [0.1, 0.; 0.1, 0.];
    >>> A = {A0, A1, A2, A3};
    >>> G = MG1FundamentalMatrix(A);
    >>> disp(G);
          0.60503      0.39497
          0.45912      0.54088

    For Mathematica:

    >>> A0 = {{0.4, 0.2},{0.3, 0.4}};
    >>> A1 = {{0., 0.1},{0., 0.}};
    >>> A2 = {{0., 0.2},{0., 0.2}};
    >>> A3 = {{0.1, 0.},{0.1, 0.}};
    >>> A = {A0, A1, A2, A3};
    >>> G = MG1FundamentalMatrix[A];
    "The evaluation of the iteration required "64" roots\n"
    "The evaluation of the iteration required "32" roots\n"
    "The evaluation of the iteration required "16" roots\n"
    "The evaluation of the iteration required "16" roots\n"
    "The evaluation of the iteration required "8" roots\n"
    "Final Residual Error for G: "1.6653345369377348*^-16
    >>> Print[G];
    {{0.6050345283244288, 0.39496547167557117},
     {0.4591222984767535, 0.5408777015232465}}

    For Python/Numpy:

    >>> A0 = ml.matrix([[0.4, 0.2],[0.3, 0.4]])
    >>> A1 = ml.matrix([[0., 0.1],[0., 0.]])
    >>> A2 = ml.matrix([[0., 0.2],[0., 0.2]])
    >>> A3 = ml.matrix([[0.1, 0.],[0.1, 0.]])
    >>> A = [A0, A1, A2, A3]
    >>> G = MG1FundamentalMatrix(A)
    The Shifted PWCR evaluation of Iteration  1  required  64  roots
    The Shifted PWCR evaluation of Iteration  2  required  32  roots
    The Shifted PWCR evaluation of Iteration  3  required  16  roots
    The Shifted PWCR evaluation of Iteration  4  required  16  roots
    The Shifted PWCR evaluation of Iteration  5  required  8  roots
    Final Residual Error for G:  1.66533453694e-16
    >>> print(G)
    [[ 0.60503  0.39497]
     [ 0.45912  0.54088]]

