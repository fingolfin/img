#############################################################################
##
#W img.gd                                                   Laurent Bartholdi
##
#H   @(#)$Id$
##
#Y Copyright (C) 2006, Laurent Bartholdi
##
#############################################################################
##
##  Iterated monodromy groups
##
#############################################################################

#############################################################################
##
#M IMGMachine
##
## <#GAPDoc Label="IMGMachine">
## <ManSection>
##   <Filt Name="IsIMGMachine" Arg="m"/>
##   <Filt Name="IsPolynomialFRMachine" Arg="m"/>
##   <Filt Name="IsPolynomialIMGMachine" Arg="m"/>
##   <Description>
##     The categories of <E>IMG</E> and <E>polynomial</E> machines.
##     IMG machines are group FR machines
##     with an additional element, their attribute <Ref Attr="IMGRelator"/>;
##     see <Ref Oper="AsIMGMachine"/>.
##
##     <P/> A polynomial machine is a group FR machine with a distinguished
##     state (which must be a generator of the stateset), stored as the
##     attribute <Ref Attr="AddingElement"/>; see
##     <Ref Oper="AsPolynomialFRMachine"/>. If it is normalized, in the sense
##     that the wreath recursion of the adding element <C>a</C> is
##     <C>[[a,1,...,1],[d,1,...,d-1]]</C>, then the basepoint is assumed
##     to be at <M>+\infty</M>; the element <C>a</C> describes a
##     clockwise loop around infinity; the <M>k</M>th preimage of the basepoint
##     is at <M>\exp(2i\pi(k-1)/d)\infty</M>, for <M>k=1,\dots,d</M>; and
##     there is a direct connection from basepoint <M>k</M> to <M>k+1</M> for
##     all <M>k=1,\dots,d-1</M>.
##
##     <P/> The last category is the intersection of the first two.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="IMGMachineNC" Arg="fam, group, trans, out, rel"/>
##   <Returns>An IMG FR machine.</Returns>
##   <Description>
##     This function creates, without checking its arguments, a new
##     IMG machine in family <A>fam</A>, stateset <A>group</A>, with
##     transitions and output <A>trans,out</A>, and IMG relator <A>rel</A>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="AsIMGMachine" Arg="m[,w]"/>
##   <Returns>An IMG FR machine.</Returns>
##   <Description>
##     This function creates a new IMG FR machine, starting from a group
##     FR machine <A>m</A>. If a state <C>w</C> is specified, and that
##     state defines the trivial FR element, then it is used
##     as <Ref Attr="IMGRelator"/>; if the state <C>w</C> is non-trivial, then
##     a new generator <C>f</C> is added to <A>m</A>, equal to the
##     inverse of <C>w</C>; and the IMG relator is chosen to be <C>w*f</C>.
##     Finally, if no relator is specified, and the product (in some ordering)
##     of the generators is trivial, then that product is used as IMG
##     relator. In other cases, the method returns <K>fail</K>.
##
##     <P/> Note that IMG elements and FR elements are compared differently
##     (see the example below); namely, an FR element is trivial precisely
##     when it acts trivially on sequences. An IMG element is trivial
##     precisely when a finite number of applications of free cancellation,
##     the IMG relator, and the decomposition map, result in trivial elements
##     of the underlying free group.
##
##     <P/> A standard FR machine can be recovered from an IMG FR machine
##     by <Ref Oper="AsGroupFRMachine"/>, <Ref Oper="AsMonoidFRMachine"/>,
##     and <Ref Oper="AsSemigroupFRMachine"/>.
## <Example><![CDATA[
## gap> m := UnderlyingFRMachine(BasilicaGroup);
## <Mealy machine on alphabet [ 1 .. 2 ] with 3 states>
## gap> g := AsGroupFRMachine(m);
## <FR machine with alphabet [ 1 .. 2 ] on Group( [ f1, f2 ] )>
## gap> AsIMGMachine(g,Product(GeneratorsOfFRMachine(g)));
## <FR machine with alphabet [ 1 .. 2 ] on Group( [ f1, f2, t ] )/[ f1*f2*t ]>
## gap> Display(last);
##  G  |              1         2
## ----+-----------------+---------+
##  f1 |          <id>,2      f2,1
##  f2 |          <id>,1      f1,2
##   t | f2^-1*f1*f2*t,2   f1^-1,1
## ----+-----------------+---------+
## Relator: f1*f2*t
## gap> g := AsGroupFRMachine(GuptaSidkiMachine);
## <FR machine with alphabet [ 1 .. 3 ] on Group( [ f1, f2 ] )>
## gap> m := AsIMGMachine(g,GeneratorsOfFRMachine(g)[1]);
## <FR machine with alphabet [ 1 .. 3 ] on Group( [ f1, f2, t ] )/[ f1*t ]>
## gap> x := FRElement(g,2)^3; IsOne(x);
## <3|identity ...>
## true
## gap> x := FRElement(m,2)^3; IsOne(x);
## <3#f2^3>
## false
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="IMGRelator" Arg="m"/>
##   <Returns>The relator of the IMG FR machine.</Returns>
##   <Description>
##     This attribute stores the product of generators that is trivial.
##     In essence, it records an ordering of the generators whose
##     product is trivial in the punctured sphere's fundamental group.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="CleanedIMGMachine" Arg="m"/>
##   <Returns>A cleaned-up version of <A>m</A>.</Returns>
##   <Description>
##     This command attempts to shorten the length of the transitions in
##     <A>m</A>, and ensure (if possible) that the product along every cycle
##     of the states of a generator is a conjugate of a generator. It returns
##     the new machine.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="NewSemigroupFRMachine" Arg="..."/>
##   <Attr Name="NewMonoidFRMachine" Arg="..."/>
##   <Attr Name="NewGroupFRMachine" Arg="..."/>
##   <Attr Name="NewIMGMachine" Arg="..."/>
##   <Returns>A new FR machine, based on string descriptions.</Returns>
##   <Description>
##     This command constructs a new FR or IMG machine, in a format similar to
##     <Ref Func="FRGroup"/>; namely, the arguments are strings of the form
##     "gen=&lt;word-1,...,word-d&gt;perm"; each <C>word-i</C> is a word in the
##     generators; and <C>perm</C> is a transformation,
##     either written in disjoint cycle or in images notation.
##
##     <P/>Except in the semigroup case, <C>word-i</C> is allowed to be the
##     empty string; and the "&lt;...&gt;" may be skipped altogether.
##     In the group or IMG case, each <C>word-i</C> may also contain inverses.
##
##     <P/>In the IMG case, an extra final argument is allowed, which is a word
##     in the generators, and describes the IMG relation. If absent,
##     <Package>FR</Package> will attempt to find such a relation.
##         
##     <P/>The following examples construct realizable foldings of the
##     polynomial <M>z^3+i</M>, following Cui's arguments.         
## <Example><![CDATA[
## gap> fold1 := NewIMGMachine("a=<,,b,,,B>(1,2,3)(4,5,6)","b=<,,b*a/b,,,B*A/B>",
##      "A=<,,b*a,,,B*A>(3,6)","B=(1,6,5,4,3,2)");
## gap> <FR machine with alphabet [ 1, 2, 3, 4, 5, 6 ] on Group( [ a, b, A, B ] )/[ a*B*A*b ]>                                
## gap> fold2 := NewIMGMachine("a=<,,b,,,B>(1,2,3)(4,5,6)","b=<,,b*a/b,,,B*A/B>",
##      "A=(1,6)(2,5)(3,4)","B=<B*A,,,b*a,,>(1,4)(2,6)(3,5)");;
## gap> RationalFunction(fold1); RationalFunction(fold2);
## ...
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="AsIMGElement" Arg="e"/>
##   <Filt Name="IsIMGElement" Arg="e"/>
##   <Description>
##     The category of <E>IMG elements</E>, namely FR elements of an IMG
##     machine. See <Ref Oper="AsIMGMachine"/> for details.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareAttribute("IMGRelator",IsGroupFRMachine);
DeclareSynonym("IsIMGMachine",IsGroupFRMachine and HasIMGRelator);
DeclareAttribute("AsIMGMachine",IsFRMachine);
DeclareOperation("AsIMGMachine",[IsFRMachine,IsWord]);
DeclareGlobalFunction("NewSemigroupFRMachine");
DeclareGlobalFunction("NewMonoidFRMachine");
DeclareGlobalFunction("NewGroupFRMachine");
DeclareGlobalFunction("NewIMGMachine");

DeclareOperation("IMGMachineNC", [IsFamily,IsGroup,IsList,IsList,IsAssocWord]);

DeclareCategory("IsIMGElement",IsGroupFRElement);
DeclareCategoryCollections("IsIMGElement");
DeclareAttribute("AsIMGElement",IsGroupFRElement);
#############################################################################

#############################################################################
##
#M PolynomialMachine
##
## <#GAPDoc Label="PolynomialFRMachine">
## <ManSection>
##   <Prop Name="IsKneadingMachine" Arg="m"/>
##   <Prop Name="IsPlanarKneadingMachine" Arg="m"/>
##   <Returns>Whether <A>m</A> is a (planar) kneading machine.</Returns>
##   <Description>
##     A <E>kneading machine</E> is a special kind of Mealy machine, used
##     to describe postcritically finite complex polynomials. It is a
##     machine such that its set of permutations is "treelike" (see
##     <Cite Key="MR2162164" Where="§6.7"/>) and such that each non-trivial
##     state occurs exactly once among the outputs.
##
##     <P/> Furthermore, this set of permutations is <E>treelike</E> if
##     there exists an ordering of the states that their product in that
##     order <M>t</M> is an adding machine; i.e. such that <M>t</M>'s
##     activity is a full cycle, and the product of its states along that
##     cycle is conjugate to <M>t</M>. This element <M>t</M> represents the
##     Carathéodory loop around infinity.
## <Example><![CDATA[
## gap> M := BinaryKneadingMachine("0");
## BinaryKneadingMachine("0*")
## gap> Display(M);
##    |  1     2
## ---+-----+-----+
##  a | c,2   b,1
##  b | a,1   c,2
##  c | c,1   c,2
## ---+-----+-----+
## gap> IsPlanarKneadingMachine(M);
## true
## gap> IsPlanarKneadingMachine(GrigorchukMachine);
## false
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="AsPolynomialFRMachine" Arg="m [,adder]"/>
##   <Oper Name="AsPolynomialIMGMachine" Arg="m [,adder [,relator]]"/>
##   <Returns>A polynomial FR machine.</Returns>
##   <Description>
##     The first function creates a new polynomial FR machine, starting from
##     a group or Mealy machine. A <E>polynomial</E> machine is one that
##     has a distinguished adding element, <Ref Attr="AddingElement"/>.
##
##     <P/> If the argument is a Mealy machine, it must be planar (see
##     <Ref Prop="IsPlanarKneadingMachine"/>). If the argument is a group
##     machine, its permutations must be treelike, and its outputs must be
##     such that, up to conjugation, each non-trivial state appears
##     exactly once as the product along all cycles of all states.
##
##     <P/> If a second argument <A>adder</A> is supplied, it is checked to
##     represent an adding element, and is used as such.
##
##     <P/> The second function creates a new polynomial IMG machine, i.e.
##     a polynomial FR machine with an extra relation among the generators.
##     the optional second argument may be an adder (if <A>m</A> is an IMG
##     machine) or a relator (if <A>m</A> is a polynomial FR machine). Finally,
##     if <A>m</A> is a group FR machine, two arguments, an adder and a relator,
##     may be specified.
##
##     <P/> A machine without the extra polynomial / IMG information may be
##     recovered using <Ref Oper="AsGroupFRMachine"/>.
## <Example><![CDATA[
## gap> M := PolynomialIMGMachine(2,[1/7],[]);; SetName(StateSet(M),"F"); M;
## <FR machine with alphabet [ 1, 2 ] and adder f4 on F/[ f4*f3*f2*f1 ]>
## gap> Mi := AsIMGMachine(M);
## <FR machine with alphabet [ 1, 2 ] on F/[ f4*f3*f2*f1 ]>
## gap> Mp := AsPolynomialFRMachine(M);
## <FR machine with alphabet [ 1, 2 ] and adder f4 on F>
## gap> Mg := AsGroupFRMachine(M);
## <FR machine with alphabet [ 1, 2 ] on F>
## gap>
## gap> AsPolynomialIMGMachine(Mg);
## <FR machine with alphabet [ 1, 2 ] and adder f4 on F/[ f4*f3*f2*f1 ]>
## gap> AsPolynomialIMGMachine(Mi);
## <FR machine with alphabet [ 1, 2 ] and adder f4 on F/[ f4*f3*f2*f1 ]>
## gap> AsPolynomialIMGMachine(Mp);
## <FR machine with alphabet [ 1, 2 ] and adder f4 on F/[ f4*f3*f2*f1 ]>
## gap> AsIMGMachine(Mg);
## <FR machine with alphabet [ 1, 2 ] on F4/[ f1*f4*f3*f2 ]>
## gap> AsPolynomialFRMachine(Mg);
##<FR machine with alphabet [ 1, 2 ] and adder f4 on F4>
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="AddingElement" Arg="m" Label="FR machine"/>
##   <Returns>The relator of the IMG FR machine.</Returns>
##   <Description>
##     This attribute stores the product of generators that is an
##     adding machine.
##     In essence, it records an ordering of the generators whose
##     product corresponds to the Carathéodory loop around infinity.
##
##     <P/> The following example illustrates Wittner's shared mating
##     of the airplane and the rabbit. In the machine <C>m</C>, an
##     airplane is represented by <C>Group(a,b,c)</C> and a rabbit is
##     represented by <C>Group(x,y,z)</C>; in the machine <C>newm</C>,
##     it is the other way round. The effect of <C>CleanedIMGMachine</C>
##     was to remove unnecessary instances of the IMG relator from
##     <C>newm</C>'s recursion.
## <Example><![CDATA[
## gap> f := FreeGroup("a","b","c","x","y","z");;
## gap> AssignGeneratorVariables(f);
## gap> m := AsIMGMachine(FRMachine(f,[[a^-1,b*a],[One(f),c],[a,One(f)],[z*y*x,
##        x^-1*y^-1],[One(f),x],[One(f),y]],[(1,2),(),(),(1,2),(),()]));;
## gap> Display(m);
##  G |      1             2   
## ---+---------+-------------+
##  a |  a^-1,2         b*a,1  
##  b |  <id>,1           c,2  
##  c |     a,1        <id>,2  
##  x | z*y*x,2   x^-1*y^-1,1  
##  y |  <id>,1           x,2  
##  z |  <id>,1           y,2  
## ---+---------+-------------+
## Relator: z*y*x*c*b*a
## gap> iso := GroupHomomorphismByImages(f,f,[a,b^(y^-1),c^(x^-1*y^-1*a^-1),x^(b*a*z*a^-1),y,z^(a^-1)],[a,b,c,x,y,z]);;
## gap> newm := CleanedIMGMachine(ChangeFRMachineBasis(m^iso,[a^-1*y^-1,y^-1*a^-1*c^-1]));;
## gap> Display(newm);
##  G |          1         2   
## ---+-------------+---------+
##  a | a^-1*c^-1,2   c*a*b,1  
##  b |      <id>,1       c,2  
##  c |         a,1    <id>,2  
##  x |       z*x,2    x^-1,1  
##  y |      <id>,1       x,2  
##  z |         y,1    <id>,2  
## ---+-------------+---------+
## Relator: c*a*b*y*z*x
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareProperty("IsKneadingMachine",IsFRMachine);
DeclareProperty("IsPlanarKneadingMachine",IsFRMachine);
InstallTrueMethod(IsBoundedFRMachine,IsKneadingMachine);
InstallTrueMethod(IsLevelTransitive,IsKneadingMachine);
DeclareAttribute("CleanedIMGMachine",IsIMGMachine);

DeclareAttribute("AddingElement",IsGroupFRMachine);
DeclareSynonym("IsPolynomialFRMachine",IsGroupFRMachine and HasAddingElement);
DeclareAttribute("AsPolynomialFRMachine",IsFRMachine);
DeclareOperation("AsPolynomialFRMachine",[IsFRMachine,IsWord]);

DeclareAttribute("AsPolynomialIMGMachine",IsFRMachine);
DeclareOperation("AsPolynomialIMGMachine",[IsFRMachine,IsWord]);
DeclareOperation("AsPolynomialIMGMachine",[IsFRMachine,IsWord,IsWord]);
DeclareSynonym("IsPolynomialIMGMachine",IsIMGMachine and IsPolynomialFRMachine);
#############################################################################

#############################################################################
##
#M Operations
##
## <#GAPDoc Label="IMGOperations">
## <ManSection>
##   <Oper Name="PolynomialFRMachine" Arg="d,per[,pre]"/>
##   <Oper Name="PolynomialIMGMachine" Arg="d,per[,pre[,formal]]"/>
##   <Oper Name="PolynomialMealyMachine" Arg="d,per[,pre]"/>
##   <Returns>An IMG FR machine.</Returns>
##   <Description>
##     This function creates a group, IMG or Mealy machine that describes
##     a topological polynomial. The polynomial is described symbolically
##     in the language of <E>external angles</E>. For more details, see
##     <Cite Key="MR762431"/> and <Cite Key="MR812271"/> (in the quadratic
##      case), <Cite Key="MR1149891"/> (in the preperiodic case), and
##     <Cite Key="math.DS/9305207"/> (in the general case).
##
##     <P/> <A>d</A> is the degree of the polynomial. <A>per</A> and
##     <A>pre</A> are lists of angles or preangles. In what follows,
##     angles are rational numbers, considered modulo 1.  Each entry in
##     <A>per</A> or <A>pre</A> is either a rational (interpreted as an
##     angle), or a list of angles <M>[a_1,\ldots,a_i]</M> such that
##     <M>da_1=\ldots=da_i</M>. The angles in <A>per</A> are angles landing
##     at the root of a Fatou component, and the angles in <A>pre</A> land
##     on the Julia set.
##
##     <P/> Note that, for IMG machines, the last generator of the machine
##     produced is an adding machine, representing a loop going
##     counterclockwise around infinity (in the compactification of
##     <M>\mathbb C</M> by a disk, this loop goes <E>clockwise</E> around
##     that disk).
##
##     <P/> In constructing a polynomial IMG machine, one may specify a
##     boolean flag <A>formal</A>, which defaults to <K>true</K>. In
##     a <E>formal</E> recursion, distinct angles give distinct generators;
##     while in a non-formal recursion, distinct angles, which land at the
##     same point in the Julia set, give a single generator. The simplest
##     example where this occurs is angle <M>5/12</M> in the quadratic
##     family, in which angles <M>1/3</M> and <M>2/3</M> land at the same
##     point -- see the example below.
##
##     <P/> The attribute <C>Correspondence(m)</C> records the angles
##     landing on the generators: <C>Correspondence(m)[i]</C> is a list
##     <C>[a,s]</C> where <M>a</M> is an angle landing on generator <C>i</C>
##     and <M>s</M> is <K>"Julia"</K> or <K>"Fatou"</K>.
##
##     <P/> If only one list of angles is supplied, then <Package>FR</Package>
##     guesses that all angles with denominator coprime to <A>n</A> are
##     Fatou, and all the others are Julia.
##
##     <P/> The inverse operation, reconstructing the angles from the IMG
##     machine, is <Ref Oper="SupportingRays"/>.
## <Example><![CDATA[
## gap> PolynomialIMGMachine(2,[0],[]); # the adding machine
## <FR machine with alphabet [ 1 .. 2 ] on Group( [ f1, f2 ] )/[ f2*f1 ]>
## gap> Display(last);
##  G  |     1        2
## ----+--------+--------+
##  f1 | <id>,2     f1,1
##  f2 |   f2,2   <id>,1
## ----+--------+--------+
## Relator: f2*f1
## gap> Display(PolynomialIMGMachine(2,[1/3],[])); # the Basilica
##  G  |      1         2
## ----+---------+---------+
##  f1 | f1^-1,2   f2*f1,1
##  f2 |    f1,1    <id>,2
##  f3 |    f3,2    <id>,1
## ----+---------+---------+
## Relator: f3*f2*f1
## gap> Display(PolynomialIMGMachine(2,[],[1/6])); # z^2+I
##  G  |            1         2
## ----+---------------+---------+
##  f1 | f1^-1*f2^-1,2   f2*f1,1
##  f2 |          f1,1      f3,2
##  f3 |          f2,1    <id>,2
##  f4 |          f4,2    <id>,1
## ----+---------------+---------+
## Relator: f4*f3*f2*f1
## gap> PolynomialIMGMachine(2,[],[5/12]);
## gap> PolynomialIMGMachine(2,[],[5/12]);
## <FR machine with alphabet [ 1, 2 ] and adder f5 on Group( [ f1, f2, f3, f4, f5 ] )/[ f5*f4*f3*f2*f1 ]>
## gap> Correspondence(last);
## [ [ 1/3, "Julia" ], [ 5/12, "Julia" ], [ 2/3, "Julia" ], [ 5/6, "Julia" ] ]
## gap> PolynomialIMGMachine(2,[],[5/12],false);
## <FR machine with alphabet [ 1, 2 ] and adder f4 on Group( [ f1, f2, f3, f4 ] )/[ f4*f3*f2*f1 ]>
## gap> Correspondence(last);
## [ [ [ 1/3, 2/3 ], "Julia" ], [ [ 5/12 ], "Julia" ], [ [ 5/6 ], "Julia" ] ]
## ]]></Example>
##     The following construct the examples in Poirier's paper:
## <Listing><![CDATA[
## PoirierExamples := function(arg)
##     if arg=[1] then
##         return PolynomialIMGMachine(2,[1/7],[]);
##     elif arg=[2] then
##         return PolynomialIMGMachine(2,[],[1/2]);
##     elif arg=[3,1] then
##         return PolynomialIMGMachine(2,[],[5/12]);
##     elif arg=[3,2] then
##         return PolynomialIMGMachine(2,[],[7/12]);
##     elif arg=[4,1] then
##         return PolynomialIMGMachine(3,[[3/4,1/12],[1/4,7/12]],[]);
##     elif arg=[4,2] then
##         return PolynomialIMGMachine(3,[[7/8,5/24],[5/8,7/24]],[]);
##     elif arg=[4,3] then
##         return PolynomialIMGMachine(3,[[1/8,19/24],[3/8,17/24]],[]);
##     elif arg=[5] then
##         return PolynomialIMGMachine(3,[[3/4,1/12],[3/8,17/24]],[]);
##     elif arg=[6,1] then
##         return PolynomialIMGMachine(4,[],[[1/4,3/4],[1/16,13/16],[5/16,9/16]]);
##     elif arg=[6,2] then
##         return PolynomialIMGMachine(4,[],[[1/4,3/4],[3/16,15/16],[7/16,11/16]]);
##     elif arg=[7] then
##         return PolynomialIMGMachine(5,[[0,4/5],[1/5,2/5,3/5]],[[1/5,4/5]]);
##     elif arg=[9,1] then
##         return PolynomialIMGMachine(3,[[0,1/3],[5/9,8/9]],[]);
##     elif arg=[9,2] then
##         return PolynomialIMGMachine(3,[[0,1/3]],[[5/9,8/9]]);
##     else
##         Error("Unknown Poirier example ",arg);
##     fi;
## end;
## ]]></Listing>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="SupportingRays" Arg="m"/>
##   <Returns>A <C>[degree,fatou,julia]</C> description of <A>m</A>.</Returns>
##   <Description>
##     This operation is the inverse of <Ref Oper="PolynomialIMGMachine"/>:
##     it computes a choice of angles, describing landing rays on Fatou/Julia
##     critical points.
##
##     <P/> If there does not exist a complex realization, namely if the
##     machine is obstructed, then this command returns an obstruction, as
##     a record. The field <K>minimal</K> is set to false, and a proper
##     sub-machine is set as the field <K>submachine</K>. The field
##     <K>homomorphism</K> gives an embedding of the stateset of
##     <K>submachine</K> into the original machine, and <K>relation</K> is
##     the equivalence relation on the set of generators of <A>m</A> that
##     describes the pinching.
## <Example><![CDATA[
## gap> r := PolynomialIMGMachine(2,[1/7],[]);
## <FR machine with alphabet [ 1, 2 ] and adder f4 on Group( [ f1, f2, f3, f4 ] )/[ f4*f3*f2*f1 ]>
## gap> F := StateSet(r);; SetName(F,"F");
## gap> SupportingRays(r);
## [ 2, [ [ 1/7, 9/14 ] ], [  ] ] # actually returns the angle 2/7
## gap> # now CallFuncList(PolynomialIMGMachine,last) would return the machine r
## gap> twist := GroupHomomorphismByImages(F,F,GeneratorsOfGroup(F),[F.1^(F.2*F.1),F.2^F.1,F.3,F.4])^-1;
## [ f1, f2, f3, f4 ] -> [ f1*f2*f1^-1, f2*f1*f2*f1^-1*f2^-1, f3, f4 ]
## gap> List([-5..5],i->2*SupportingRays(r*twist^i)[2][1][1]);
## [ 4/7, 5/7, 4/7, 4/7, 5/7, 2/7, 4/7, 4/7, 2/7, 4/7, 4/7 ]
## gap> r := PolynomialIMGMachine(2,[],[1/6]);;
## gap> F := StateSet(r);;
## gap> twist := GroupHomomorphismByImages(F,F,GeneratorsOfGroup(F),[F.1,F.2^(F.3*F.2),F.3^F.2,F.4]);;
## gap> SupportingRays(r);
## [ 2, [  ], [ [ 1/12, 7/12 ] ] ]
## gap> SupportingRays(r*twist);
## [ 2, [  ], [ [ 5/12, 11/12 ] ] ]
## gap> SupportingRays(r*twist^2);
## rec(
##   transformation := [ [ f1, f2^-1*f3^-1*f2^-1*f3^-1*f2*f3*f2*f3*f2, f2^-1*f3^-1*f2^-1*f3*f2*f3*f2,
##           f4 ] -> [ f1, f2, f3, f4 ],
##       [ f1^-1*f2^-1*f1^-1*f2^-1*f1*f2*f1*f2*f1, f1^-1*f2^-1*f1^-1*f2*f1*f2*f1, f3, f4 ] ->
##         [ f1, f2, f3, f4 ],
##       [ f1^-1*f2^-1*f3^-1*f2*f1*f2^-1*f3*f2*f1, f2, f2*f1^-1*f2^-1*f3*f2*f1*f2^-1, f4 ] ->
##         [ f1, f2, f3, f4 ], [ f1, f3*f2*f3^-1, f3, f4 ] -> [ f1, f2, f3, f4 ],
##       [ f1, f2, f2*f3*f2^-1, f4 ] -> [ f1, f2, f3, f4 ],
##       [ f1, f3*f2*f3^-1, f3, f4 ] -> [ f1, f2, f3, f4 ],
##       [ f1, f2, f2*f3*f2^-1, f4 ] -> [ f1, f2, f3, f4 ],
##       [ f1, f3*f2*f3^-1, f3, f4 ] -> [ f1, f2, f3, f4 ] ], machine := <FR machine with alphabet
##     [ 1, 2 ] and adder f4 on Group( [ f1, f2, f3, f4 ] )/[ f4*f3*f2*f1 ]>, minimal := false,
##   submachine := <FR machine with alphabet [ 1, 2 ] and adder f3 on Group( [ f1, f2, f3 ] )>,
##   homomorphism := [ f1, f2, f3 ] -> [ f1, f2*f3, f4 ],
##   relation := <equivalence relation on <object> >, niter := 8 )
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="AsGroupFRMachine" Arg="f" Label="endomorphism"/>
##   <Attr Name="AsMonoidFRMachine" Arg="f" Label="endomorphism"/>
##   <Attr Name="AsSemigroupFRMachine" Arg="f" Label="endomorphism"/>
##   <Returns>An FR machine.</Returns>
##   <Description>
##     This function creates an FR machine on a 1-letter alphabet,
##     that represents the endomorphism <A>f</A>. It is specially useful
##     when combined with products of machines; indeed the usual product
##     of machines corresponds to composition of endomorphisms.
## <Example><![CDATA[
## gap> f := FreeGroup(2);;
## gap> h := GroupHomomorphismByImages(f,f,[f.1,f.2],[f.2,f.1*f.2]);
## [ f1, f2 ] -> [ f2, f1*f2 ]
## gap> m := AsGroupFRMachine(h);
## <FR machine with alphabet [ 1 ] on Group( [ f1, f2 ] )>
## gap> mm := TensorProduct(m,m);
## <FR machine with alphabet [ 1 ] on Group( [ f1, f2 ] )>
## gap> Display(mm);
##  G  |         1
## ----+------------+
##  f1 |    f1*f2,1
##  f2 | f2*f1*f2,1
## ----+------------+
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="NormalizedPolynomialFRMachine" Arg="m"/>
##   <Attr Name="NormalizedPolynomialIMGMachine" Arg="m"/>
##   <Returns>A polynomial FR machine.</Returns>
##   <Description>
##     This function returns a new FR machine, in which the adding element
##     has been put into a standard form <M>t=[t,1,\dots,1]s</M>, where
##     <M>s</M> is the long cycle <M>i\mapsto i-1</M>.
##
##     <P/> For the first command, the machine returned is an FR machine;
##     for the second, it is an IMG machine.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="SimplifiedIMGMachine" Arg="m"/>
##   <Returns>A simpler IMG machine.</Returns>
##   <Description>
##     This function returns a new IMG machine, with hopefully simpler
##     transitions. The simplified machine is obtained by applying
##     automorphisms to the stateset. The sequence of automorphisms
##     (in increasing order) is stored as a correspondence; namely,
##     if <C>n=SimplifiedIMGMachine(m)</C>, then
##     <C>m^Product(Correspondence(n))=n</C>.
## <Example><![CDATA[
## gap> r := PolynomialIMGMachine(2,[1/7],[]);;
## gap> F := StateSet(r);; SetName(F,"F");
## gap> twist := GroupHomomorphismByImages(F,F,GeneratorsOfGroup(F),[F.1^(F.2*F.1),F.2^F.1,F.3,F.4]);;
## gap> m := r*twist;; Display(m);
##  G  |                     1            2
## ----+------------------------+------------+
##  f1 |          f1^-1*f2^-1,2   f3*f2*f1,1
##  f2 | f1^-1*f2^-1*f1*f2*f1,1       <id>,2
##  f3 |          f1^-1*f2*f1,1       <id>,2
##  f4 |                   f4,2       <id>,1
## ----+------------------------+------------+
## Adding element: f4
## Relator: f4*f3*f2*f1
## gap> n := SimplifiedIMGMachine(m);
## <FR machine with alphabet [ 1, 2 ] and adder f4 on F>
## gap> Display(n);
##  G  |            1            2
## ----+---------------+------------+
##  f1 | f2^-1*f1^-1,2   f1*f2*f3,1
##  f2 |        <id>,1         f1,2
##  f3 |        <id>,1         f2,2
##  f4 |          f4,2       <id>,1
## ----+---------------+------------+
## Adding element: f4
## Relator: f4*f1*f2*f3
## gap> n = m^Product(Correspondence(n));
## true
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="Mating" Arg="m1,m2 [,formal]"/>
##   <Returns>An IMG FR machine.</Returns>
##   <Description>
##     This function "mates" two polynomial IMG machines.
##
##     <P/> The mating is defined as follows: one removes a disc around
##     the adding machine in <A>m1</A> and <A>m2</A>; one applies complex
##     conjugation to <A>m2</A>; and one glues the hollowed spheres along
##     their boundary circle.
##
##     <P/> The optional argument <A>formal</A>, which defaults to
##     <K>true</K>, specifies whether a <E>formal</E> mating should be done;
##     in a non-formal mating, generators of <A>m1</A> and <A>m2</A> which
##     have identical angle should be treated as a single generator. A
##     non-formal mating is of course possible only if the machines are
##     realizable -- see <Ref Oper="SupportingRays"/>.
##
##     <P/> The attribute <C>Correspondence</C> is a pair of homomorphisms,
##     from the statesets of <A>m1,m2</A> respectively to the stateset of the
##     mating.
## <Example><![CDATA[
## gap> # the Tan-Shishikura examples
## gap> z := Indeterminate(MPC_PSEUDOFIELD);;
## gap> a := RootsFloat((z-1)*(3*z^2-2*z^3)+1);;
## gap> c := RootsFloat((z^3+z)^3+z);;
## gap> am := List(a,a->IMGMachine((a-1)*(3*z^2-2*z^3)+1));;
## gap> cm := List(c,c->IMGMachine(z^3+c));;
## gap> m := ListX(am,cm,Mating);;
## gap> # m[2] is realizable
## gap> RationalFunction(m[2]);
## ((1.66408+I*0.668485)*z^3+(-2.59772+I*0.627498)*z^2+(-1.80694-I*0.833718)*z
##   +(1.14397-I*1.38991))/((-1.52357-I*1.27895)*z^3+(2.95502+I*0.234926)*z^2
##   +(1.61715+I*1.50244)*z+1)
## gap> # m[6] is obstructed
## gap> RationalFunction(m[6]);
## rec( matrix := [ [ 1/2, 1 ], [ 1/2, 0 ] ], machine := <FR machine with alphabet
##     [ 1, 2, 3 ] on Group( [ f1, f2, f3, g1, g2, g3 ] )/[ f2*f3*f1*g1*g3*g2 ]>,
##   obstruction := [ f1^-1*f3^-1*f2^-1*f1*f2*f3*f1*g2^-1*g3^-1*f1^-1*f3^-1*f2^-1,
##       f2*f3*f1*f2*f3*f1*g2*f1^-1*f3^-1*f2^-1*f1^-1*f3^-1 ],
##   spider := <spider on <triangulation with 8 vertices, 36 edges and
##     12 faces> marked by GroupHomomorphismByImages( Group( [ f1, f2, f3, g1, g2, g3
##      ] ), Group( [ f1, f2, f3, f4, f5 ] ), [ f1, f2, f3, g1, g2, g3 ],
##     [ f1*f4*f2^-1*f1*f4^-1*f1^-1, f1*f4*f2^-1*f1*f4*f5^-1*f1^-1*f2*f4^-1*f1^-1,
##       f1*f4*f2^-1*f1*f5*f1^-1*f2*f4^-1*f1^-1, f2*f4^-1*f1^-1*f2*f1*f4*f2^-1,
##       f2*f4^-1*f3*f2^-1, f2*f4^-1*f1^-1*f3^-1*f4*f2^-1 ] )> )
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareAttribute("AsGroupFRMachine",IsGroupHomomorphism);
DeclareAttribute("AsMonoidFRMachine",IsMagmaHomomorphism);
DeclareAttribute("AsSemigroupFRMachine",IsMagmaHomomorphism);

DeclareOperation("PolynomialMealyMachine",[IsPosInt,IsList,IsList]);
DeclareOperation("PolynomialFRMachine",[IsPosInt,IsList,IsList]);
DeclareOperation("PolynomialIMGMachine",[IsPosInt,IsList,IsList]);
DeclareOperation("PolynomialIMGMachine",[IsPosInt,IsList,IsList,IsBool]);
DeclareOperation("PolynomialMealyMachine",[IsPosInt,IsList]);
DeclareOperation("PolynomialFRMachine",[IsPosInt,IsList]);
DeclareOperation("PolynomialIMGMachine",[IsPosInt,IsList]);
DeclareOperation("PolynomialIMGMachine",[IsPosInt,IsList,IsBool]);

DeclareAttribute("NormalizedPolynomialFRMachine",IsPolynomialFRMachine);
DeclareAttribute("NormalizedPolynomialIMGMachine",IsPolynomialFRMachine);
DeclareAttribute("SimplifiedIMGMachine",IsIMGMachine);
DeclareAttribute("SupportingRays",IsGroupFRMachine);
DeclareOperation("Mating",[IsPolynomialFRMachine,IsPolynomialFRMachine]);
DeclareOperation("Mating",[IsPolynomialFRMachine,IsPolynomialFRMachine,IsBool]);
#############################################################################

#############################################################################
##
#M Automorphisms of FR machines
##
## <#GAPDoc Label="AutomorphismsFRMachines">
## <ManSection>
##   <Attr Name="AutomorphismVirtualEndomorphism" Arg="v"/>
##   <Attr Name="AutomorphismIMGMachine" Arg="m"/>
##   <Returns>A description of the pullback map on Teichmüller space.</Returns>
##   <Description>
##     Let <A>m</A> be an IMG machine, thought of as a biset for the
##     fundamental group <M>G</M> of a punctured sphere. Let <M>M</M> denote
##     the automorphism of the surface, seen as a group of outer
##     automorphisms of <M>G</M> that fixes the conjugacy classes of punctures.
##
##     <P/> Choose an alphabet letter <A>a</A>, and consider the
##     virtual endomorphism <M>v:G_a\to G</M>. Let <M>H</M> denote the
##     subgroup of <M>M</M> that fixes all conjugacy classes of <M>G_a</M>.
##     then there is an induced virtual endomorphism <M>\alpha:H\to M</M>,
##     defined by <M>t^\alpha=v^{-1}tv</M>. This is the homomorphism
##     computed by the first command. Its source and range are in fact
##     groups of automorphisms of range of <A>v</A>.
##
##     <P/> The second command constructs an FR machine associated with
##     <A>\alpha</A>. Its stateset is a free group generated by elementary
##     Dehn twists of the generators of <A>G</A>.
##
## <Example><![CDATA[
## gap> z := Indeterminate(COMPLEX_FIELD);;
## gap> # a Sierpinski carpet map without multicurves
## gap> m := IMGMachine((z^2-z^-2)/2/COMPLEX_I);
## <FR machine with alphabet [ 1, 2, 3, 4 ] on Group( [ f1, f2, f3, f4 ] )/[ f3*f2*f1*f4 ]>
## gap> AutomorphismIMGMachine(i);
## <FR machine with alphabet [ 1, 2 ] on Group( [ x1, x2, x3, x4, x5, x6 ] )>
## gap> Display(last);
##  G  |     1        2
## ----+--------+--------+
##  x1 | <id>,2   <id>,1  
##  x2 | <id>,1   <id>,2  
##  x3 | <id>,2   <id>,1  
##  x4 | <id>,2   <id>,1  
##  x5 | <id>,1   <id>,2  
##  x6 | <id>,2   <id>,1  
## ----+--------+--------+
## gap> # the original rabbit problem
## gap> m := PolynomialIMGMachine(2,[1/7],[]);;
## gap> v := VirtualEndomorphism(m,1);;
## gap> a := AutomorphismVirtualEndomorphism(v);
## MappingByFunction( <group with 20 generators>, <group with 6 generators>, function( a ) ... end )
## gap> Source(a).1;
## [ f1, f2, f3, f4 ] -> [ f3*f2*f1*f2^-1*f3^-1, f2, f3, f3*f2*f1^-1*f2^-1*f3^-1*f2^-1*f3^-1 ]
## gap> Image(a,last);
## [ f1, f2, f3, f4 ] -> [ f1, f2, f2*f1*f3*f1^-1*f2^-1, f3^-1*f1^-1*f2^-1 ]
## gap> # so last2*m is equivalent to m*last
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareOperation("AutomorphismVirtualEndomorphism",[IsGroupHomomorphism]);
DeclareOperation("AutomorphismIMGMachine",[IsIMGMachine]);
#############################################################################

#############################################################################
##
#M ChangeFRMachineBasis
##
## <#GAPDoc Label="ChangeFRMachineBasis">
## <ManSection>
##   <Oper Name="ComplexConjugate" Arg="m"/>
##   <Returns>An FR machine with inverted states.</Returns>
##   <Description>
##     This function constructs an FR machine whose generating states are
##     the inverses of the original states. If <A>m</A> came from a complex
##     rational map <M>f(z)</M>, this would construct the machine of the
##     conjugate map <M>\overline{f(\overline z)}</M>.
## <Example><![CDATA[
## gap> a := PolynomialIMGMachine(2,[1/7]);
## <FR machine with alphabet [ 1, 2 ] and adder FRElement(...,f4) on <object>/[ f4*f3*f2*f1 ]>
## gap> Display(a);
##  G  |            1            2
## ----+---------------+------------+
##  f1 | f1^-1*f2^-1,2   f3*f2*f1,1
##  f2 |          f1,1       <id>,2
##  f3 |          f2,1       <id>,2
##  f4 |          f4,2       <id>,1
## ----+---------------+------------+
## Adding element: FRElement(...,f4)
## Relator: f4*f3*f2*f1
## gap> Display(ComplexConjugate(a));
##  G  |            1                     2
## ----+---------------+---------------------+
##  f1 | f1*f2*f3*f4,2   f4^-1*f2^-1*f1^-1,1
##  f2 |          f1,1      <identity ...>,2
##  f3 |          f2,1      <identity ...>,2
##  f4 |          f4,2      <identity ...>,1
## ----+---------------+---------------------+
## Adding element: FRElement(...,f4)
## Relator: f1*f2*f3*f4
## gap> ExternalAngle(a);
## {2/7}
## gap> ExternalAngle(ComplexConjugate(a));
## {6/7}
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="BraidTwists" Arg="m"/>
##   <Returns>Automorphisms of <A>m</A>'s stateset that preserve its relator.</Returns>
##   <Description>
##     This function returns a list of (positive and negative) free group automorphisms, that are
##     such that conjugating <A>m</A> by these automorphisms preserves its IMG relator.
##     <P/>
##     These are in fact the generators of Artin's braid group.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="RotatedSpider" Arg="m, [p]"/>
##   <Returns>A polynomial FR machine with rotated spider at infinity.</Returns>
##   <Description>
##     This function constructs an isomorphic polynomial FR machine, but with
##     a different numbering of the spider legs at infinity. This rotation is
##     accomplished by conjugating by <C>adder^p</C>, where <C>adder</C> is the
##     adding element of <A>m</A>, and <A>p</A>, the rotation parameter, is
##     <M>1</M> by default.
## <Example><![CDATA[
## gap> a := PolynomialIMGMachine(3,[1/4]);
## <FR machine with alphabet [ 1, 2, 3 ] and adder FRElement(...,f3) on <object>/[ f3*f2*f1 ]>
## gap> Display(a);
##  G  |      1        2         3
## ----+---------+--------+---------+
##  f1 | f1^-1,2   <id>,3   f2*f1,1
##  f2 |    f1,1   <id>,2    <id>,3
##  f3 |    f3,3   <id>,1    <id>,2
## ----+---------+--------+---------+
## Adding element: FRElement(...,f3)
## Relator: f3*f2*f1
## gap> Display(RotatedSpider(a));
##  G  |     1            2               3
## ----+--------+------------+---------------+
##  f1 | <id>,2   f2*f1*f3,3   f3^-1*f1^-1,1
##  f2 | <id>,1       <id>,2   f3^-1*f1*f3,3
##  f3 |   f3,3       <id>,1          <id>,2
## ----+--------+------------+---------------+
## Adding element: FRElement(...,f3)
## Relator: f3*f2*f1
## gap> ExternalAngle(a);
## {3/8}
## gap> List([1..10],i->ExternalAngle(RotatedSpider(a,i)));
## [ {7/8}, {1/4}, {7/8}, {1/4}, {7/8}, {1/4}, {7/8}, {1/4}, {7/8}, {1/4} ]
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
#DeclareAttribute("ComplexConjugate", IsFRMachine); # already declared for arithmetic objects
DeclareAttribute("BraidTwists", IsIMGMachine);
DeclareOperation("RotatedSpider", [IsPolynomialFRMachine]);
DeclareOperation("RotatedSpider", [IsPolynomialFRMachine, IsInt]);
#############################################################################

#############################################################################
##
#E MarkedSpheres
##
## <#GAPDoc Label="MarkedSpheres">
## <ManSection>
##   <Filt Name="IsSphereTriangulation"/>
##   <Filt Name="IsMarkedSphere"/>
##   <Attr Name="Spider" Arg="ratmap" Label="r"/>
##   <Attr Name="Spider" Arg="machine" Label="m"/>
##   <Description>
##     The category of triangulated spheres (points in Moduli space),
##     or of marked, triangulated spheres (points in Teichmüller space).
##
##     <P/> Various commands have an attribudte <C>Spider</C>, which records
##     this point in Teichmüller space.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="RationalFunction" Arg="[z,] m"/>
##   <Returns>A rational function.</Returns>
##   <Description>
##   This command runs a modification of Hubbard and Schleicher's
##   "spider algorithm" <Cite Key="MR1315537"/> on the IMG FR machine <A>m</A>.
##   It either returns a rational function <C>f</C> whose associated machine
##   is <A>m</A>; or a record describing the Thurston obstruction to
##   realizability of <C>f</C>.
##
##   <P/> This obstruction record <C>r</C> contains a list <C>r.multicurve</C>
##   of conjugacy classes in <C>StateSet(m)</C>, which represent
##   short multicurves; a matrix <C>r.mat</C>, and a spider <C>r.spider</C>
##   on which the obstruction was discovered.
##
##   <P/> If a rational function is returned, it has preset attributes
##   <C>Spider(f)</C> and <C>IMGMachine(f)</C> which is a simplified
##   version of <A>m</A>. This rational function is also normalized so that
##   its post-critical points have barycenter=0 and has two post-critical
##   points at infinity and on the positive real axis.
##   Furthermore, if <A>m</A> is polynomial-like, then the returned map is
##   a polynomial.
##
##   <P/> The command accepts the following options, to return a map in a given normalization: <List>
##   <Mark><C>RationalFunction(m:param:=IsPolynomial)</C></Mark>
##         <Item>returns <M>f=z^d+A_{d-2}z^{d-2}+\cdots+A_0</M>;</Item>
##   <Mark><C>RationalFunction(m:param:=IsBicritical)</C></Mark>
##         <Item>returns <M>f=((pz+q)/(rz+s)^d</M>, with
##               <M>1</M>postcritical;</Item>
##   <Mark><C>RationalFunction(m:param:=n)</C></Mark>
##         <Item>returns <M>f=1+a/z+b/z^2</M> or <M>f=a/(z^2+2z)</M>
##               if <C>n=2</C>.</Item>
##   </List>
## <Example><![CDATA[
## gap> m := PolynomialIMGMachine(2,[1/3],[]);
## <FR machine with alphabet [ 1, 2 ] on Group( [ f1, f2, f3 ] )/[ f3*f2*f1 ]>
## gap> RationalFunction(m);
## 0.866025*z^2+(-1)*z+(-0.288675)
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="Draw" Arg="s" Label="spider"/>
##   <Description>
##     This command plots the spider <A>s</A> in a separate X window.
##     It displays the complex sphere, big dots at the post-critical
##     set (feet of the spider), and the arcs and dual arcs
##     of the triangulation connecting the feet.
##
##     <P/> If the option <K>julia:=&lt;gridsize&gt;</K> (if no grid size
##     is specified, it is 500 by default), then the Julia set of the
##     map associated with the spider is also displayed. Points attracted
##     to attracting cycles are coloured in pastel tones, and unattracted
##     points are coloured black.
##
##     <P/> If the option <K>noarcs</K> is specified, the printing of the
##    arcs and dual arcs is disabled.
##
##     <P/> The options <K>upper</K>, <K>lower</K> and <K>detach</K>
##     also apply.
##   </Description>
## </ManSection>

## <ManSection>
##   <Oper Name="FRMachine" Arg="f" Label="rational function"/>
##   <Oper Name="IMGMachine" Arg="f" Label="rational function"/>
##   <Returns>An IMG FR machine.</Returns>
##   <Description>
##   This function computes a triangulation of the sphere, on the
##   post-critical set of <A>f</A>, and lifts it through the map <A>f</A>.
##   the action of the fundamental group of the punctured sphere is
##   then read into an IMG fr machine <C>m</C>, which is returned.
##
##   <P/> This machine has a preset attribute <C>Spider(m)</C>.
##
##   <P/> An approximation of the Julia set of <A>f</A> can be computed,
##   and plotted on the spider, with the form <C>IMGMachine(f:julia)</C>
##   or <C>IMGMachine(f:julia:=gridsize)</C>.
## <Example><![CDATA[
## gap> z := Indeterminate(COMPLEX_FIELD);;
## gap> IMGMachine(z^2-1);
## <FR machine with alphabet [ 1, 2 ] on Group( [ f1, f2, f3 ] )/[ f2*f1*f3 ]>
## gap> Display(last);
##  G  |            1        2
## ----+---------------+--------+
##  f1 |          f2,2   <id>,1
##  f2 | f3^-1*f1*f3,1   <id>,2
##  f3 |        <id>,2     f3,1
## ----+---------------+--------+
## Relator: f2*f1*f3
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="FindThurstonObstruction" Arg="list"/>
##   <Returns>A description of the obstruction corresponding to <A>list</A>, or <K>fail</K>.</Returns>
##   <Description>
##     This method accepts a list of IMG elements on the same underlying
##     machine, and treats these as representatives of conjugacy classes
##     defining (part of) a multicurve. It computes whether these
##     curves, when supplemented with their lifts under the recursion,
##     constitute a Thurston obstruction, by computing its transition matrix.
##
##     <P/> The method either returns <K>fail</K>, if there is no obstruction,
##     or a record with as fields <C>matrix,machine,obstruction</C> giving
##     respectively the transition matrix, a simplified machine, and the
##     curves that constitute a minimal obstruction.
## <Example><![CDATA[
## gap> r := PolynomialIMGMachine(2,[],[1/6]);;
## gap> F := StateSet(r);;
## gap> twist := GroupHomomorphismByImages(F,F,GeneratorsOfGroup(F),[F.1,F.2^(F.3*F.2),F.3^F.2,F.4]);;
## gap> SupportingRays(r*twist^-1);
## rec( machine := <FR machine with alphabet [ 1, 2 ] on F/[ f4*f1*f2*f3 ]>,
##      twist := [ f1, f2, f3, f4 ] -> [ f1, f3^-1*f2*f3, f3^-1*f2^-1*f3*f2*f3, f4 ],
##      obstruction := "Dehn twist" )
## gap> FindThurstonObstruction([FRElement(last.machine,[2,3])]);
## rec( matrix := [ [ 1 ] ], machine := <FR machine with alphabet [ 1, 2 ] on F/[ f4*f1*f2*f3 ]>, obstruction := [ f1^-1*f4^-1 ] )
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareCategory("IsMarkedSphere", IsObject);
BindGlobal("SPIDER_FAMILY",
        NewFamily("MarkedSpheres", IsMarkedSphere));
BindGlobal("TYPE_SPIDER",
        NewType(SPIDER_FAMILY, IsMarkedSphere));

DeclareOperation("Draw", [IsMarkedSphere]);
DeclareAttribute("VERTICES@", IsMarkedSphere);
DeclareAttribute("SPIDERRELATOR@", IsMarkedSphere);
DeclareAttribute("TREEBOUNDARY@", IsMarkedSphere);
DeclareAttribute("NFFUNCTION@", IsMarkedSphere);

DeclareAttribute("Spider", IsFRMachine);
DeclareAttribute("Spider", IsP1Map);
DeclareAttribute("IMGORDERING@", IsIMGMachine);

DeclareOperation("P1Map", [IsFRMachine]);
DeclareAttribute("RationalFunction", IsFRMachine);
DeclareOperation("RationalFunction", [IsRingElement, IsFRMachine]);
DeclareAttribute("FRMachine", IsUnivariateRationalFunction);
DeclareAttribute("IMGMachine", IsUnivariateRationalFunction);
DeclareProperty("IsBicritical", IsObject);

DeclareOperation("FindThurstonObstruction", [IsIMGElementCollection]);
#############################################################################

#############################################################################
##
#E The Hurwitz problem
##
## <#GAPDoc Label="Hurwitz">
## <ManSection>
##   <Oper Name="HurwitzMap" Arg="spider, monodromy"/>
##   <Returns>A record describing a Hurwitz map.</Returns>
##   <Description>
##     If <A>spider</A> is a spider, marked by a group <M>G</M>, and
##     <A>monodromy</A> is a homomorphism from <M>G</M> to a permutation
##     group, this function computes a rational map whose critical values
##     are the vertices of <A>spider</A> and whose monodromy about these
##     critical values is given by <A>monodromy</A>.
##
##     <P/> The returned data are in a record with a field <C>degree</C>, the
##     degree of the map; two fields <C>map</C> and <C>post</C>, describing the
##     desired <M>\mathbb P^1</M>-map --- <C>post</C> is a Möbius
##     transformation, and the composition of <C>map</C> and <C>post</C> is
##     the desired map; and lists <C>zeros</C>, <C>poles</C>
##     and <C>cp</C> describing the zeros, poles and critical points of the
##     map. Each entry in these lists is a record with entries <C>degree</C>,
##     <C>pos</C> and <C>to</C> giving, for each point in the source of
##     <C>map</C>, the local degree and the vertex in <A>spider</A> it maps to.
##
##     <P/> This function requires external programs in the subdirectory
##     "hurwitz" to have been compiled.
## <Example><![CDATA[
## gap> # we'll construct 2d-2 points on the equator, and permutations
## gap> # in order (1,2),...,(d-1,d),(d-1,d),...,(1,2) for these points.
## gap> # first, the spider.
## gap> d := 20;;
## gap> z := List([0..2*d-3], i->P1Point(Exp(i*PMCOMPLEX.constants.2IPI/(2*d-2))));;
## gap> spider := TRIVIALSPIDER@FR(z);;
## gap> g := FreeGroup(2*d-2);;
## gap> IMGMARKING@FR(spider,g);
## gap> # next, the permutation representation
## gap> perms := List([1..d-1],i->(i,i+1));;
## gap> Append(perms,Reversed(perms));
## gap> perms := GroupHomomorphismByImages(g,SymmetricGroup(d),GeneratorsOfGroup(g),perms);;
## gap> # now compute the map
## gap> HurwitzMap(spider,perms);
## rec( cp := [ rec( degree := 2, pos := <1.0022-0.0099955i>, to := <vertex 19[ 9, 132, 13, 125 ]> ), 
##       rec( degree := 2, pos := <1.0022-0.0099939i>, to := <vertex 20[ 136, 128, 129, 11 ]> ), 
##       rec( degree := 2, pos := <1.0039-0.0027487i>, to := <vertex 10[ 73, 74, 16, 82 ]> ), 
##       rec( degree := 2, pos := <1.0006-0.0027266i>, to := <vertex 29[ 185, 20, 179, 21 ]> ), 
##       rec( degree := 2, pos := <1.0045-7.772e-05i>, to := <vertex 9[ 24, 77, 17, 72 ]> ), 
##       rec( degree := 2, pos := <1.1739+0.33627i>, to := <vertex 2[ 31, 32, 41, 28 ]> ), 
##       rec( degree := 2, pos := <1.0546+0.12276i>, to := <vertex 3[ 37, 38, 33, 46 ]> ), 
##       rec( degree := 2, pos := <1.026+0.061128i>, to := <vertex 4[ 43, 39, 52, 45 ]> ), 
##       rec( degree := 2, pos := <1.0148+0.03305i>, to := <vertex 5[ 49, 44, 58, 51 ]> ), 
##       rec( degree := 2, pos := <1.0098+0.018122i>, to := <vertex 6[ 55, 50, 64, 57 ]> ), 
##       rec( degree := 2, pos := <1.0071+0.0093947i>, to := <vertex 7[ 61, 62, 71, 59 ]> ), 
##       rec( degree := 2, pos := <1.0055+0.0037559i>, to := <vertex 8[ 67, 68, 63, 69 ]> ), 
##       rec( degree := 2, pos := <1.0035-0.0047633i>, to := <vertex 11[ 79, 75, 88, 81 ]> ), 
##       rec( degree := 2, pos := <1.0031-0.0062329i>, to := <vertex 12[ 85, 80, 94, 87 ]> ), 
##       rec( degree := 2, pos := <1.0029-0.0073311i>, to := <vertex 13[ 91, 86, 100, 93 ]> ), 
##       rec( degree := 2, pos := <1.0027-0.008187i>, to := <vertex 14[ 97, 92, 106, 99 ]> ), 
##       rec( degree := 2, pos := <1.0026-0.008824i>, to := <vertex 15[ 103, 98, 112, 105 ]> ), 
##       rec( degree := 2, pos := <1.0025-0.0092966i>, to := <vertex 16[ 109, 104, 118, 111 ]> ), 
##       rec( degree := 2, pos := <1.0024-0.0096345i>, to := <vertex 17[ 115, 110, 124, 117 ]> ), 
##       rec( degree := 2, pos := <1.0023-0.0098698i>, to := <vertex 18[ 121, 116, 122, 123 ]> ), 
##       rec( degree := 2, pos := <1.0021-0.0098672i>, to := <vertex 21[ 133, 127, 142, 135 ]> ), 
##       rec( degree := 2, pos := <1.002-0.0096298i>, to := <vertex 22[ 139, 134, 148, 141 ]> ), 
##       rec( degree := 2, pos := <1.002-0.0092884i>, to := <vertex 23[ 145, 140, 154, 147 ]> ), 
##       rec( degree := 2, pos := <1.0019-0.0088147i>, to := <vertex 24[ 151, 146, 160, 153 ]> ), 
##       rec( degree := 2, pos := <1.0017-0.008166i>, to := <vertex 25[ 157, 152, 166, 159 ]> ), 
##       rec( degree := 2, pos := <1.0016-0.0073244i>, to := <vertex 26[ 163, 158, 172, 165 ]> ), 
##       rec( degree := 2, pos := <1.0014-0.0061985i>, to := <vertex 27[ 169, 164, 178, 171 ]> ), 
##       rec( degree := 2, pos := <1.0011-0.0047031i>, to := <vertex 28[ 175, 170, 176, 177 ]> ), 
##       rec( degree := 2, pos := <0.99908+0.0038448i>, to := <vertex 31[ 187, 183, 196, 189 ]> ), 
##       rec( degree := 2, pos := <0.99759+0.0094326i>, to := <vertex 32[ 193, 188, 202, 195 ]> ), 
##       rec( degree := 2, pos := <0.99461+0.018114i>, to := <vertex 33[ 199, 194, 208, 201 ]> ), 
##       rec( degree := 2, pos := <0.98944+0.032796i>, to := <vertex 34[ 205, 200, 214, 207 ]> ), 
##       rec( degree := 2, pos := <0.9772+0.058259i>, to := <vertex 35[ 211, 206, 220, 213 ]> ), 
##       rec( degree := 2, pos := <0.94133+0.11243i>, to := <vertex 36[ 217, 212, 226, 219 ]> ), 
##       rec( degree := 2, pos := <0.79629+0.23807i>, to := <vertex 37[ 223, 224, 225, 221 ]> ), 
##       rec( degree := 2, pos := <1+0i>, to := <vertex 30[ 181, 182, 6, 190 ]> ) ], degree := 20, 
##   map := <((-0.32271060393507572-4.3599244721894763i_z)*z^20+(3.8941736874493795+78.415744809040405\
## i_z)*z^19+(-16.808157937605603-665.79436908026275i_z)*z^18+(2.6572296014719168+3545.861245383101i_z\
## )*z^17+(316.57668022762243-13273.931613611372i_z)*z^16+(-1801.6631038749117+37090.818733740503i_z)*\
## z^15+(5888.6033008259928-80172.972599556582i_z)*z^14+(-13500.864941314803+137069.10015838256i_z)*z^\
## 13+(23251.436304923012-187900.36507913063i_z)*z^12+(-31048.192131502536+208077.63047409133i_z)*z^11\
## +(32639.349270133433-186578.17493860485i_z)*z^10+(-27155.791223040047+135145.40893002271i_z)*z^9+(1\
## 7836.343164500577-78489.005444299968i_z)*z^8+(-9153.842142530224+36053.895961137248i_z)*z^7+(3598.6\
## 408777659944-12810.65497539577i_z)*z^6+(-1047.541279063196+3397.470068169695i_z)*z^5+(212.906725643\
## 0024-633.29691376653466i_z)*z^4+(-26.989372105307872+74.040615571896637i_z)*z^3+(1.6073346640110264\
## -4.0860733899027055i_z)*z^2)/(z^18+(-18.034645372692019-0.45671993287358581i_z)*z^17+(153.540499397\
## 49956+7.7811506405054889i_z)*z^16+(-819.9344323563339-62.384270590463998i_z)*z^15+(3077.71530771320\
## 75+312.59552100187739i_z)*z^14+(-8623.1225834872057-1096.4398001099003i_z)*z^13+(18689.34396825033+\
## 2856.8568878158458i_z)*z^12+(-32038.568184053798-5725.9186424029094i_z)*z^11+(44038.148375498437+90\
## 17.0162876593004i_z)*z^10+(-48898.555649389084-11295.156285052604i_z)*z^9+(43964.579894637543+11318\
## .997395732025i_z)*z^8+(-31931.403449371515-9074.2344933443364i_z)*z^7+(18595.347261301522+5786.6036\
## 424805825i_z)*z^6+(-8565.0823844971637-2899.3353634270734i_z)*z^5+(3051.6919509143086+1117.44496422\
## 99487i_z)*z^4+(-811.56293104533825-319.93036282549667i_z)*z^3+(151.69784956523344+64.11787684283315\
## 5i_z)*z^2+(-17.785127700028404-8.0311759305108268i_z)*z+(0.98427999507354302+0.47338721325094818i_z\
## ))>, poles := [ rec( degree := 1, pos := <0.99517+0.30343i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0021+0.11512i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0028+0.05702i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0026+0.030964i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0025+0.016951i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0024+0.0085784i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0024+0.003208i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0023-0.00046905i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0023-0.0030802i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0023-0.0049913i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0023-0.0064163i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0074855i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0082954i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0089048i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0093543i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0096742i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0098869i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0099988i>, to := <vertex 1[ 26, 27, 1, 34 ]> ), 
##       rec( degree := 2, pos := <P1infinity>, to := <vertex 1[ 26, 27, 1, 34 ]> ) ], 
##   post := <((-0.91742065452766763+0.99658449300666985i_z)*z+(0.74087581626192234-1.1339948562200648\
## i_z))/((-0.75451451285920013+0.96940026593933015i_z)*z+(0.75451451285920013-0.96940026593933015i_z)\
## )>, zeros := [ rec( degree := 1, pos := <0.92957+0.28362i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <0.99173+0.11408i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <0.99985+0.056874i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0014+0.030945i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.002+0.016938i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022+0.0085785i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022+0.0032076i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.00046827i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0030802i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0049908i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.006416i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0074855i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0082953i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0089047i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0093542i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0096742i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0098869i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 1, pos := <1.0022-0.0099988i>, to := <vertex 38[ 30, 3, 228, 7 ]> ), 
##       rec( degree := 2, pos := <0+0i>, to := <vertex 38[ 30, 3, 228, 7 ]> ) ] )
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="DessinByPermutations" Arg="s0,s1[,sinf]"/>
##   <Returns>A rational map (see <Ref Oper="HurwitzMap"/>) with monodromies <A>s,t</A>.</Returns>
##   <Description>
##     This command computes the Hurwitz map associated with the spider
##     <M>[0,1]\cup[1,\infty]</M>; the monodromy representation is by
##     the permutation <A>s0</A> at <M>0</M> and <A>s1</A> at <M>1</M>. The
##     optional third argument <A>sinf</A> is the monodromy at <M>\infty</M>,
##     and must equal <M>s_0^{-1}s_1^{-1}</M>.
##
##     <P/> The data is returned as a record, with entries <C>degree</C>,
##     <C>map</C>, <C>post</C>, and lists <C>poles</C>, <C>zeros</C>, and
##     <C>above1</C>. Each entry in the list is a record with entries
##     <C>pos</C> and <C>degree</C>.
## <Example><![CDATA[
## gap> DessinByPermutations((1,2),(2,3));
## rec( above1 := [ rec( degree := 2, pos := <1+0i> ),
##                  rec( degree := 1, pos := <-0.5-1.808e-14i> ) ],
##      degree := 3, 
##      map := <(-1.9999999999946754+2.1696575743432764e-13i_z)*z^3+(2.9999999999946754-2.1696575743432764e-13i_z)*z^2>,
##      poles := [ rec( degree := 3, pos := <P1infinity> ) ],
##      post := <z>, 
##      zeros := [ rec( degree := 1, pos := <1.5+5.4241e-14i> ),
##                 rec( degree := 2, pos := <0+0i> ) ] )
## gap> # the Cui example
## gap> DessinByPermutations((1,3,12,4)(5,9)(6,7)(10,13,11)(2,8),
##            (1,5,13,6)(7,10)(2,3)(8,11,12)(4,9),
##            (1,7,11,2)(3,8)(4,5)(9,12,13)(6,10));
## rec( 
##   above1 := [ rec( degree := 2, pos := <1.9952-0.79619i> ), 
##       rec( degree := 2, pos := <0.43236-0.17254i> ), rec( degree := 2, pos := <-0.9863-0.16498i> ),
##       rec( degree := 3, pos := <-0.12749-0.99184i> ), rec( degree := 4, pos := <1+0i> ) ], 
##   degree := 13, 
##   map := <((-6.9809917616400366e-12+0.13002709490708636i_z)*z^13+(-0.68172329304137969-0.8451761169\
## 2062078i_z)*z^12+(4.0903397584184269+0.30979932084028583i_z)*z^11+(-6.3643009040280925+7.5930410215\
## 99336i_z)*z^10+(-5.1732765988942884-16.738910009700096i_z)*z^9+(21.528087032174511+6.11354599010482\
## 5i_z)*z^8+(-15.258776392407746+13.657687016998921i_z)*z^7+(-1.6403496019814323-13.453316297094229i_\
## z)*z^6+(4.4999999996894351+3.3633290741375781i_z)*z^5+(-0.99999999990279009+2.5538451239904557e-11i\
## _z)*z^4)/(z^9+(-4.4999999999400613+3.3633290744267983i_z)*z^8+(1.6403496020557891-13.45331629745540\
## 7i_z)*z^7+(15.258776391831654+13.657687016903173i_z)*z^6+(-21.528087030670253+6.1135459892162567i_z\
## )*z^5+(5.1732765986730511-16.738910007513041i_z)*z^4+(6.3643009027133139+7.593041020468557i_z)*z^3+\
## (-4.0903397575324512+0.30979932067785648i_z)*z^2+(0.68172329288354727-0.8451761166966415i_z)*z+(5.0\
## 734454343833585e-12+0.13002709487107747i_z))>, 
##   poles := [ rec( degree := 2, pos := <1.6127-0.49018i> ), 
##       rec( degree := 2, pos := <0.5-0.04153i> ), rec( degree := 2, pos := <-0.61269-0.49018i> ), 
##       rec( degree := 3, pos := <0.5-0.43985i> ), rec( degree := 4, pos := <P1infinity> ) ], 
##   post := <-z+1._z>, 
##   zeros := [ rec( degree := 2, pos := <1.9863-0.16498i> ), 
##       rec( degree := 3, pos := <1.1275-0.99184i> ), rec( degree := 2, pos := <0.56764-0.17254i> ), 
##       rec( degree := 2, pos := <-0.99516-0.79619i> ), rec( degree := 4, pos := <0+0i> ) ] )
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareOperation("HurwitzMap", [IsMarkedSphere,IsGroupHomomorphism]);
DeclareOperation("DessinByPermutations", [IsPerm,IsPerm]);
DeclareOperation("DessinByPermutations", [IsPerm,IsPerm,IsPerm]);
#############################################################################

#############################################################################
##
#E DBRationalIMGGroup
##
## <#GAPDoc Label="DBRationalIMGGroup">
## <ManSection>
##   <Func Name="DBRationalIMGGroup" Arg="sequence/map"/>
##   <Returns>An IMG group from Dau's database.</Returns>
##   <Description>
##     This function returns the iterated monodromy group from a database
##     of groups associated to quadratic rational maps. This database has
##     been compiled by Dau Truong Tan <Cite Key="tan:database"/>.
##
##     <P/> When called with no arguments, this command returns the database
##     contents in raw form.
##
##     <P/> The argments can be a sequence; the first integer is the size
##     of the postcritical set, the second argument is an index for the
##     postcritical graph, and sometimes a third argument distinguishes
##     between maps with same post-critical graph.
##
##     <P/> If the argument is a rational map, the command returns the
##     IMG group of that map, assuming its canonical quadratic rational form
##     form exists in the database.
## <Example><![CDATA[
## gap> DBRationalIMGGroup(z^2-1);
## IMG((z-1)^2)
## gap> DBRationalIMGGroup(z^2+1); # not post-critically finite
## fail
## gap> DBRationalIMGGroup(4,1,1);
## IMG((z/h+1)^2|2h^3+2h^2+2h+1=0,h~-0.64)
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="PostCriticalMachine" Arg="f"/>
##   <Returns>The Mealy machine of <A>f</A>'s post-critical orbit.</Returns>
##   <Description>
##     This function constructs a Mealy machine <C>P</C> on the alphabet
##     <C>[1]</C>, which describes the post-critical set of <A>f</A>.
##     It is in fact an oriented graph with constant out-degree 1. It is
##     most conveniently passed to <Ref Oper="Draw"/>.
##
##     <P/> The attribute <C>Correspondence(P)</C> is the list of values
##     associated with the stateset of <C>P</C>.
## <Example><![CDATA[
## gap> z := Indeterminate(Rationals,"z");;
## gap> m := PostCriticalMachine(z^2);
## <Mealy machine on alphabet [ 1 ] with 2 states>
## gap> Display(m);
##    |  1
## ---+-----+
##  a | a,1
##  b | b,1
## ---+-----+
## gap> Correspondence(m);
## [ 0, infinity ]
## gap> m := PostCriticalMachine(z^2-1);; Display(m); Correspondence(m);
##    |  1
## ---+-----+
##  a | c,1
##  b | b,1
##  c | a,1
## ---+-----+
## [ -1, infinity, 0 ]
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="Mandel" Arg="[map]"/>
##   <Returns>Calls the external program <File>mandel</File>.</Returns>
##   <Description>
##     This function starts the external program <File>mandel</File>, by Wolf Jung.
##     The program is searched for along the standard PATH; alternatively,
##     its location can be set in the string variable EXEC@FR.mandel.
##
##     <P/> When called with no arguments, this command returns starts
##     <File>mandel</File> in its default mode. With a rational map as argument, it
##     starts <File>mandel</File> pointing at that rational map.
##
##     <P/> More information on <File>mandel</File> can be found
##     at <URL>http://www.mndynamics.com</URL>.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareGlobalFunction("PostCriticalMachine");
DeclareGlobalFunction("DBRationalIMGGroup");
DeclareGlobalFunction("Mandel");
#############################################################################

#############################################################################
##
#E Conversions
##
## <#GAPDoc Label="Conversions">
## <ManSection>
##   <Attr Name="KneadingSequence" Arg="angle" Label="angle"/>
##   <Returns>The kneading sequence associated with <A>angle</A>.</Returns>
##   <Description>
##     This function converts a rational angle to a kneading sequence, to
##     describe a quadratic polynomial.
##
##     <P/> If <A>angle</A> is in <M>[1/7,2/7]</M> and the option
##     <C>marked</C> is set, the kneading sequence is decorated with markings
##     in A,B,C.
## <Example><![CDATA[
## gap> KneadingSequence(1/7);
## [ 1, 1 ]
## gap> KneadingSequence(1/5:marked);
## [ "A1", "B1", "B0" ]
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="AllInternalAddresses" Arg="n"/>
##   <Returns>Internal addresses of maps with period up to <A>n</A>.</Returns>
##   <Description>
##     This function returns internal addresses for all periodic points of
##     period up to <A>n</A> under angle doubling. These internal addresses
##     describe the prominent hyperbolic components along the path from the
##     landing point to the main cardioid in the Mandelbrot set; this is a
##     list of length <C>3k</C>, with at position <C>3i+1,3i+2</C> the
##     left and right angles, respectively, and at position <C>3i+3</C> the
##     period of that component. For example,
##     <C>[ 3/7, 4/7, 3, 1/3, 2/3, 2 ]</C> describes the airplane: a 
##     polynomial with landing angles <M>[3/7,4/7]</M> of period <M>3</M>;
##     and such that there is a polynomial with landing angles <M>[1/3,2/3]</M>
##     and period <M>2</M>.
## <Example><![CDATA[
## gap> AllInternalAddresses(3);
## [ [  ], [ [ 1/3, 2/3, 2 ] ], 
## [ [ 1/7, 2/7, 3 ], [ 3/7, 4/7, 3, 1/3, 2/3, 2 ], [ 5/7, 6/7, 3 ] ] ]
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="ExternalAnglesRelation" Arg="degree, n"/>
##   <Returns>An equivalence relation on the rationals.</Returns>
##   <Description>
##     This function returns the equivalence relation on <C>Rationals</C>
##     identifying all pairs of external angles that land at a
##     common point of period up to <A>n</A> under angle multiplication by
##     by <A>degree</A>.
## <Example><![CDATA[
## gap> ExternalAnglesRelation(2,3);
## <equivalence relation on Rationals >
## gap> EquivalenceRelationPartition(last);
## [ [ 1/7, 2/7 ], [ 1/3, 2/3 ], [ 3/7, 4/7 ], [ 5/7, 6/7 ] ]
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="ExternalAngle" Arg="machine"/>
##   <Returns>The external angle identifying <A>machine</A>.</Returns>
##   <Description>
##     In case <A>machine</A> is the IMG machine of a unicritical
##     polynomial, this function computes the external angle landing at the
##     critical value. More precisely, it computes the equivalence class of
##     that external angle under <Ref Func="ExternalAnglesRelation"/>.
## <Example><![CDATA[
## gap> ExternalAngle(PolynomialIMGMachine(2,[1/7])); # the rabbit
## {2/7}
## gap> Elements(last);
## [ 1/7, 2/7 ]
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareAttribute("KneadingSequence", IsRat);
DeclareGlobalFunction("AllInternalAddresses");
DeclareGlobalFunction("ExternalAngle");
DeclareGlobalFunction("ExternalAnglesRelation");
#############################################################################

#E img.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
