ClearAll["Global`*"]
AppendTo[$Path,"/home/gabor/github/butools/Mathematica"];
<<BuTools`
Print["---BuTools: RepTrans package test file---"//OutputForm];
Print["Enable the verbose messages with the BuToolsVerbose flag"//OutputForm];
BuTools`Verbose = True;
Print["Enable input parameter checking with the BuToolsCheckInput flag"//OutputForm];
BuTools`CheckInput = true;
On[Assert];
Print["========================================"]
Print["Testing BuTools function SimilarityMatrix"]
A1m = {{0.2, 0.8, 0.},{1.2, -0.4, 0.1},{-0.2, 0.7, 0.5}};
Print["A1m = "//OutputForm];
Print[A1m];
T = {{1., 2., -4., 6.},{0., 8., -9., 7.},{-3., 7., 8., -2.}};
Print["T = "//OutputForm];
Print[T];
Print["A2m = PseudoInverse[T].A1m.T;:"//OutputForm];
A2m = PseudoInverse[T].A1m.T;
Print["Test:"//OutputForm];
Print["-----"//OutputForm];
Print["B = SimilarityMatrix[A1m, A2m];:"//OutputForm];
B = SimilarityMatrix[A1m, A2m];
Print["err = Norm[A1m.B-B.A2m];:"//OutputForm];
err = Norm[A1m.B-B.A2m];
Print["err = "//OutputForm];
Print[err];
Assert[err<10^-7, "The resulting matrix T does not satisfy A1m*T = T*A2m!"];
Print["========================================"]
Print["Testing BuTools function TransformToAcyclic"]
Print["Input:"//OutputForm];
Print["------"//OutputForm];
A = {{-0.8, 0.8, 0.},{0.1, -0.3, 0.1},{0.2, 0., -0.5}};
Print["A = "//OutputForm];
Print[A];
Print["Test:"//OutputForm];
Print["-----"//OutputForm];
Print["B = TransformToAcyclic[A];:"//OutputForm];
B = TransformToAcyclic[A];
Print["B = "//OutputForm];
Print[B];
Print["Cm = SimilarityMatrix[A, B];:"//OutputForm];
Cm = SimilarityMatrix[A, B];
Print["err = Norm[A.Cm-Cm.B];:"//OutputForm];
err = Norm[A.Cm-Cm.B];
Print["err = "//OutputForm];
Print[err];
Assert[err<10^-7, "The original and the transformed matrix are not similar!"];
Print["========================================"]
Print["Testing BuTools function TransformToMonocyclic"]
A = {{-1, 0, 0},{0, -3, 2},{0, -2, -3}};
Print["A = "//OutputForm];
Print[A];
Print["Test:"//OutputForm];
Print["-----"//OutputForm];
Print["B = TransformToMonocyclic[A];:"//OutputForm];
B = TransformToMonocyclic[A];
Print["B = "//OutputForm];
Print[B];
Print["Cm = SimilarityMatrix[A, B];:"//OutputForm];
Cm = SimilarityMatrix[A, B];
Print["err = Norm[A.Cm-Cm.B];:"//OutputForm];
err = Norm[A.Cm-Cm.B];
Print["err = "//OutputForm];
Print[err];
Assert[err<10^-7, "The original and the transformed matrix are not similar!"];
Print["========================================"]
Print["Testing BuTools function ExtendToMarkovian"]
Print["Input:"//OutputForm];
Print["------"//OutputForm];
alpha = {0.2,0.3,0.5};
A = {{-1., 0., 0.},{0., -3., 0.6},{0., -0.6, -3.}};
B = TransformToMonocyclic[A];
Print["B = "//OutputForm];
Print[B];
Cm = SimilarityMatrix[A, B];
beta = alpha.Cm;
Print["beta = "//OutputForm];
Print[beta];
Print["Test:"//OutputForm];
Print["-----"//OutputForm];
Print["{m, M} = ExtendToMarkovian[beta, B];:"//OutputForm];
{m, M} = ExtendToMarkovian[beta, B];
Print["m = "//OutputForm];
Print[m];
Print["M = "//OutputForm];
Print[M];
Print["Cm = SimilarityMatrix[B, M];:"//OutputForm];
Cm = SimilarityMatrix[B, M];
Print["err = Norm[B.Cm-Cm.M];:"//OutputForm];
err = Norm[B.Cm-Cm.M];
Print["err = "//OutputForm];
Print[err];
Assert[err<10^-7, "The original and the transformed matrix are not similar!"];
Assert[Min[m]>-10^-14, "The initial vector is still not Markovian!"];
Print["========================================"]
Print["Testing BuTools function SimilarityMatrixForVectors"]
Print["Input:"//OutputForm];
Print["------"//OutputForm];
vecA = {{0.0},{0.3},{-1.5},{0.0}};
Print["vecA = "//OutputForm];
Print[vecA];
vecB = {{1.0},{0.2},{0.0},{1.0}};
Print["vecB = "//OutputForm];
Print[vecB];
Print["Test:"//OutputForm];
Print["-----"//OutputForm];
Print["B = SimilarityMatrixForVectors[vecA, vecB];:"//OutputForm];
B = SimilarityMatrixForVectors[vecA, vecB];
Print["B = "//OutputForm];
Print[B];
Print["err = Norm[B.vecA-vecB];:"//OutputForm];
err = Norm[B.vecA-vecB];
Print["err = "//OutputForm];
Print[err];
Assert[Norm[B.vecA-vecB]<10^-14, "The resulting matrix T does not satisfy T*vecA = vecB!"];
