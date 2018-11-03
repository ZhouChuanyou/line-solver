butools.queues.MAPMAP1
======================

.. currentmodule:: butools.queues

.. np:function:: MAPMAP1

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`Ret = MAPMAP1(D0, D1, S0, S1, ...)`
        * - Mathematica:
          - :code:`Ret = MAPMAP1[D0, D1, S0, S1, ...]`
        * - Python/Numpy:
          - :code:`Ret = MAPMAP1(D0, D1, S0, S1, ...)`

    Returns various performane measures of a continuous time
    MAP/MAP/1 queue.

    In a MAP/MAP/1 queue both the arrival and the service
    processes are characterized by Markovian arrival 
    processes.

    Parameters
    ----------
    D0 : matrix, shape(N,N)
        The transitions of the arrival MAP not accompanied by
        job arrivals
    D1 : matrix, shape(N,N)
        The transitions of the arrival MAP accompanied by
        job arrivals
    S0 : matrix, shape(N,N)
        The transitions of the service MAP not accompanied by
        job service
    S1 : matrix, shape(N,N)
        The transitions of the service MAP accompanied by
        job service
    further parameters : 
        The rest of the function parameters specify the options
        and the performance measures to be computed.

        The supported performance measures and options in this 
        function are:

        +----------------+--------------------+----------------------------------------+
        | Parameter name | Input parameters   | Output                                 |
        +================+====================+========================================+
        | "ncMoms"       | Number of moments  | The moments of the number of customers |
        +----------------+--------------------+----------------------------------------+
        | "ncDistr"      | Upper limit K      | The distribution of the number of      |
        |                |                    | customers from level 0 to level K-1    |
        +----------------+--------------------+----------------------------------------+
        | "ncDistrMG"    | None               | The vector-matrix parameters of the    |
        |                |                    | matrix-geometric distribution of the   |
        |                |                    | number of customers in the system      |
        +----------------+--------------------+----------------------------------------+
        | "ncDistrDPH"   | None               | The vector-matrix parameters of the    |
        |                |                    | matrix-geometric distribution of the   |
        |                |                    | number of customers in the system,     |
        |                |                    | converted to a discrete PH             |
        |                |                    | representation                         |
        +----------------+--------------------+----------------------------------------+
        | "stMoms"       | Number of moments  | The sojourn time moments               |
        +----------------+--------------------+----------------------------------------+
        | "stDistr"      | A vector of points | The sojourn time distribution at the   |
        |                |                    | requested points (cummulative, cdf)    |
        +----------------+--------------------+----------------------------------------+
        | "stDistrME"    | None               | The vector-matrix parameters of the    |
        |                |                    | matrix-exponentially distributed       |
        |                |                    | sojourn time distribution              |
        +----------------+--------------------+----------------------------------------+
        | "stDistrPH"    | None               | The vector-matrix parameters of the    |
        |                |                    | matrix-exponentially distributed       |
        |                |                    | sojourn time distribution, converted   |
        |                |                    | to a continuous PH representation      |
        +----------------+--------------------+----------------------------------------+
        | "prec"         | The precision      | Numerical precision used as a stopping |
        |                |                    | condition when solving the             |
        |                |                    | matrix-quadratic equation              |
        +----------------+--------------------+----------------------------------------+
        
        (The quantities related to the number of customers in 
        the system include the customer in the server, and the 
        sojourn time related quantities include the service 
        times as well)

    Returns
    -------
    Ret : list of the performance measures
        Each entry of the list corresponds to a performance 
        measure requested. If there is just a single item, 
        then it is not put into a list.
   
    Notes
    -----
    "ncDistrMG" and "stDistrME" behave much better numerically than 
    "ncDistrDPH" and "stDistrPH".

    Examples
    ========    

