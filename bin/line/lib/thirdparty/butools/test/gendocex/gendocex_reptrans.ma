ClearAll["Global`*"]
AppendTo[$Path,"/home/gabor/github/butools/Mathematica"];
<<BuTools`
Print["---BuTools: RepTrans package test file---"//OutputForm];
Print["Enable the verbose messages with the BuToolsVerbose flag"//OutputForm];
BuTools`Verbose = True;
Print["Enable input parameter checking with the BuToolsCheckInput flag"//OutputForm];
BuTools`CheckInput = true;
On[Assert];
tmpOut = $Output;
stream = OpenWrite["/home/gabor/github/butools/test/docex/RepTrans_mathematica.docex", FormatType -> InputForm, PageWidth -> Infinity];
$Output = {stream};
Unprotect[Print];
Print[args___] := Block[{$inMsg = True, result, str},
   If[MatrixQ[args],
       str = "{";
       Do[str = StringJoin[str, ToString[args[[r]], FormatType -> InputForm]]; 
            If[r < Length[args], str = StringJoin[str, ",\n "]], {r, Length[args]}];
            str = StringJoin[str, "}"];
            Print[str//OutputForm],
            result = Print[args],
            result = Print[args]
        ]] /; ! TrueQ[$inMsg];
Print["=== SimilarityMatrix ==="]
Print[">>> A1m = {{0.2, 0.8, 0.},{1.2, -0.4, 0.1},{-0.2, 0.7, 0.5}};"//OutputForm];
A1m = {{0.2, 0.8, 0.},{1.2, -0.4, 0.1},{-0.2, 0.7, 0.5}};
Print[">>> T = {{1., 2., -4., 6.},{0., 8., -9., 7.},{-3., 7., 8., -2.}};"//OutputForm];
T = {{1., 2., -4., 6.},{0., 8., -9., 7.},{-3., 7., 8., -2.}};
Print[">>> A2m = PseudoInverse[T].A1m.T;"//OutputForm];
A2m = PseudoInverse[T].A1m.T;
Print[">>> B = SimilarityMatrix[A1m, A2m];"//OutputForm];
B = SimilarityMatrix[A1m, A2m];
Print[">>> err = Norm[A1m.B-B.A2m];"//OutputForm];
err = Norm[A1m.B-B.A2m];
Print[">>> Print[err];"//OutputForm];
Print[err];
Print["=== TransformToAcyclic ==="]
Print[">>> A = {{-0.8, 0.8, 0.},{0.1, -0.3, 0.1},{0.2, 0., -0.5}};"//OutputForm];
A = {{-0.8, 0.8, 0.},{0.1, -0.3, 0.1},{0.2, 0., -0.5}};
Print[">>> B = TransformToAcyclic[A];"//OutputForm];
B = TransformToAcyclic[A];
Print[">>> Print[B];"//OutputForm];
Print[B];
Print[">>> Cm = SimilarityMatrix[A, B];"//OutputForm];
Cm = SimilarityMatrix[A, B];
Print[">>> err = Norm[A.Cm-Cm.B];"//OutputForm];
err = Norm[A.Cm-Cm.B];
Print[">>> Print[err];"//OutputForm];
Print[err];
Print["=== TransformToMonocyclic ==="]
Print[">>> A = {{-1, 0, 0},{0, -3, 2},{0, -2, -3}};"//OutputForm];
A = {{-1, 0, 0},{0, -3, 2},{0, -2, -3}};
Print[">>> B = TransformToMonocyclic[A];"//OutputForm];
B = TransformToMonocyclic[A];
Print[">>> Print[B];"//OutputForm];
Print[B];
Print[">>> Cm = SimilarityMatrix[A, B];"//OutputForm];
Cm = SimilarityMatrix[A, B];
Print[">>> err = Norm[A.Cm-Cm.B];"//OutputForm];
err = Norm[A.Cm-Cm.B];
Print[">>> Print[err];"//OutputForm];
Print[err];
Print["=== ExtendToMarkovian ==="]
Print[">>> alpha = {0.2,0.3,0.5};"//OutputForm];
alpha = {0.2,0.3,0.5};
Print[">>> A = {{-1., 0., 0.},{0., -3., 0.6},{0., -0.6, -3.}};"//OutputForm];
A = {{-1., 0., 0.},{0., -3., 0.6},{0., -0.6, -3.}};
Print[">>> B = TransformToMonocyclic[A];"//OutputForm];
B = TransformToMonocyclic[A];
Print[">>> Print[B];"//OutputForm];
Print[B];
Print[">>> Cm = SimilarityMatrix[A, B];"//OutputForm];
Cm = SimilarityMatrix[A, B];
Print[">>> beta = alpha.Cm;"//OutputForm];
beta = alpha.Cm;
Print[">>> Print[beta];"//OutputForm];
Print[beta];
Print[">>> {m, M} = ExtendToMarkovian[beta, B];"//OutputForm];
{m, M} = ExtendToMarkovian[beta, B];
Print[">>> Print[m];"//OutputForm];
Print[m];
Print[">>> Print[M];"//OutputForm];
Print[M];
Print[">>> Cm = SimilarityMatrix[B, M];"//OutputForm];
Cm = SimilarityMatrix[B, M];
Print[">>> err = Norm[B.Cm-Cm.M];"//OutputForm];
err = Norm[B.Cm-Cm.M];
Print[">>> Print[err];"//OutputForm];
Print[err];
Print["=== SimilarityMatrixForVectors ==="]
Print[">>> vecA = {{0.0},{0.3},{-1.5},{0.0}};"//OutputForm];
vecA = {{0.0},{0.3},{-1.5},{0.0}};
Print[">>> vecB = {{1.0},{0.2},{0.0},{1.0}};"//OutputForm];
vecB = {{1.0},{0.2},{0.0},{1.0}};
Print[">>> B = SimilarityMatrixForVectors[vecA, vecB];"//OutputForm];
B = SimilarityMatrixForVectors[vecA, vecB];
Print[">>> Print[B];"//OutputForm];
Print[B];
Print[">>> err = Norm[B.vecA-vecB];"//OutputForm];
err = Norm[B.vecA-vecB];
Print[">>> Print[err];"//OutputForm];
Print[err];
$Output = tmpOut;Close[stream];

