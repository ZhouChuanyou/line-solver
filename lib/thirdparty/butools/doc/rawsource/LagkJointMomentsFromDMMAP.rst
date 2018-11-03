butools.dmap.LagkJointMomentsFromDMMAP
======================================

.. currentmodule:: butools.dmap

.. np:function:: LagkJointMomentsFromDMMAP

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`Nm = LagkJointMomentsFromDMMAP(D, K, L, prec)`
        * - Mathematica:
          - :code:`Nm = LagkJointMomentsFromDMMAP[D, K, L, prec]`
        * - Python/Numpy:
          - :code:`Nm = LagkJointMomentsFromDMMAP(D, K, L, prec)`

    Returns the lag-L joint moments of a discrete marked 
    Markovian arrival process.

    Parameters
    ----------
    D : list/cell of matrices of shape(M,M), length(N)
        The D0...DN matrices of the DMMAP to check
    K : int, optional
        The dimension of the matrix of joint moments to 
        compute. If K=0, the MxM joint moments will be 
        computed. The default value is 0
    L : int, optional
        The lag at which the joint moments are computed.
        The default value is 1
    prec : double, optional
        Numerical precision to check if the input is valid. 
        The default value is 1e-14

    Returns
    -------
    Nm : list/cell of matrices of shape(K+1,K+1), length(L)
        The matrices containing the lag-L joint moments,
        starting from moment 0.

    Examples
    --------
    For Matlab:

    >>> D0=[0.34 0 0; 0.06 0.05 0.03; 0.11 0.13 0];
    >>> D1=[0.3 0 0; 0.16 0.18 0.05; 0.15 0.04 0.09];
    >>> D2=[0 0.01 0; 0.1 0.07 0.08; 0.13 0.12 0.13];
    >>> D3=[0.35 0 0; 0 0.18 0.04; 0.06 0.03 0.01];
    >>> Nm = LagkJointMomentsFromDMMAP({D0,D1,D2,D3},4,1);
    >>> Nm{1}
          0.45395      0.68525       1.3856       3.8671       14.298
          0.68283       1.0318       2.0887       5.8339       21.579
           1.3755       2.0807       4.2171       11.789       43.629
            3.828       5.7954       11.756       32.887       121.75
           14.133       21.406       43.444       121.57       450.16
    >>> Nm{2}
         0.026281      0.03323     0.053055      0.11925      0.38427
         0.035051     0.043866     0.068917      0.15222      0.48448
         0.060653      0.07477      0.11464      0.24631      0.76824
           0.1482      0.17996      0.26901      0.56074       1.7085
          0.50589       0.6081      0.89307       1.8207       5.4486
    >>> Nm{3}
          0.51977      0.78522       1.5891        4.438       16.415
          0.78582       1.1881       2.4067       6.7254       24.884
           1.5917       2.4087       4.8838       13.657       50.551
           4.4481       6.7354       13.666       38.235       141.56
           16.458        24.93       50.601       141.61       524.37

    For Python/Numpy:

    >>> D0=ml.matrix([[0.34, 0, 0],[0.06, 0.05, 0.03],[0.11, 0.13, 0]])
    >>> D1=ml.matrix([[0.3, 0, 0],[0.16, 0.18, 0.05],[0.15, 0.04, 0.09]])
    >>> D2=ml.matrix([[0, 0.01, 0],[0.1, 0.07, 0.08],[0.13, 0.12, 0.13]])
    >>> D3=ml.matrix([[0.35, 0, 0],[0, 0.18, 0.04],[0.06, 0.03, 0.01]])
    >>> Nm=LagkJointMomentsFromDMMAP((D0,D1,D2,D3),3,1)
    >>> print(Nm[0])
    [[  0.45394628   0.68525107   1.38563721   3.86705067]
     [  0.68282502   1.03179221   2.08867835   5.83387234]
     [  1.37545474   2.08069064   4.21706252  11.78914025]
     [  3.82801963   5.79544886  11.7563803   32.88737375]]
    >>> print(Nm[1])
    [[ 0.02628103  0.03323045  0.0530552   0.11925159]
     [ 0.03505148  0.04386615  0.06891662  0.15221701]
     [ 0.06065279  0.07477024  0.11464022  0.24630982]
     [ 0.14819695  0.17996017  0.26901444  0.56073679]]
    >>> print(Nm[2])
    [[  0.51977269   0.78521582   1.58914945   4.43800313]
     [  0.78582084   1.18810084   2.4066502    6.72536789]
     [  1.59173433   2.40869961   4.88377952  13.65716585]
     [  4.44808881   6.73539376  13.66583666  38.2348084 ]]

