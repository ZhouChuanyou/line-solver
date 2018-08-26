Representation Transformation Tools (:mod:`butools.reptrans`)
=============================================================

.. module:: butools.reptrans

To load this package, either start the :func:`BuToolsInit()` 
script, or execute

.. list-table::
    :widths: 50 50

    * - :code:`addpath('butools/reptrans')` 
      - in Matlab,
    * - :code:`<<BuTools`RepTrans``
      - in Mathematica,
    * - :code:`from butools.reptrans import *` 
      - in Python/Numpy.


Tools for representation transformation
---------------------------------------

.. list-table::
    :widths: 25 150

    * - :py:func:`SimilarityMatrix <butools.reptrans.SimilarityMatrix>`
      - Returns the matrix that transforms A1 to A2
    * - :py:func:`SimilarityMatrixForVectors <butools.reptrans.SimilarityMatrixForVectors>`
      - Returns the similarity transformation matrix that transforms a given column a to a column vector b
    * - :py:func:`TransformToMonocyclic <butools.reptrans.TransformToMonocyclic>`
      - Transforms an arbitrary matrix to a Markovian monocyclic matrix
    * - :py:func:`TransformToAcyclic <butools.reptrans.TransformToAcyclic>`
      - Transforms an arbitrary matrix to a Markovian bi-diagonal matrix
    * - :py:func:`ExtendToMarkovian <butools.reptrans.ExtendToMarkovian>`
      - Appends an appropriate Erlang tail to the representation that makes the initial vector Markovian
    * - :py:func:`FindMarkovianRepresentation <butools.reptrans.FindMarkovianRepresentation>`
      - Obtains a Markovian representation from a non-Markovian one, with keeping the size the same
    * - :py:func:`MStaircase <butools.reptrans.MStaircase>`
      - Computes a smaller representation of RAP using staircase algorithm


.. toctree::
    :hidden:

    SimilarityMatrix
    SimilarityMatrixForVectors
    TransformToMonocyclic
    TransformToAcyclic
    ExtendToMarkovian
    FindMarkovianRepresentation
    MStaircase

