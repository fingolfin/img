#############################################################################
##
#W helpers.gi                                               Laurent Bartholdi
##
#Y Copyright (C) 2012, Laurent Bartholdi
##
#############################################################################
##
##  This file contains helper code for functionally recursive groups,
##  in particular related to the geometry of groups.
##
#############################################################################

#############################################################################
##
#W  Compile documentation
##
BindGlobal("PATH@", PackageInfo("img")[1].InstallationPath);
VERSION@ := Filename(DirectoriesPackageLibrary("img",""),".version");
if VERSION@<>fail then
    VERSION@ := ReadLine(InputTextFile(VERSION@));
    Remove(VERSION@); # remove \n
fi;
MakeReadOnlyGlobal("VERSION@");

BindGlobal("DOC@", function() MakeGAPDocDoc(Concatenation(PATH@,"/doc"),"img",
  ["../gap/img.gd","../gap/examples.gd","../gap/helpers.gd",
   "../gap/complex.gd","../gap/p1.gd",
   "../PackageInfo.g"],"img");
end);

BindGlobal("INSTALLPRINTERS@", function(filter)
    InstallMethod(PrintObj, [filter], function(x) Print(String(x)); end);
    InstallMethod(ViewObj, [filter], function(x) Print(ViewString(x)); end);
    InstallMethod(Display, [filter], function(x) Print(DisplayString(x)); end);
end);
#############################################################################

################################################################

BindGlobal("POSITIONID@", function(l,x)
    return PositionProperty(l,y->IsIdenticalObj(x,y));
end);

BindGlobal("INID@", function(x,l)
    return ForAny(l,y->IsIdenticalObj(x,y));
end);

UTIME@ := function()
    local v;
    v := ValueGlobal("IO_gettimeofday")();
    return v.tv_sec+1.e-6_l*v.tv_usec;
end;

LASTTIME@ := 0; TIMES@ := []; MARKTIME@ := function(n) # crude time profiling
    local t;
    t := UTIME@();
    if n=0 then LASTTIME@ := t; return; fi;
    if not IsBound(TIMES@[n]) then TIMES@[n] := 0.0_l; fi;
    TIMES@[n] := TIMES@[n]+t - LASTTIME@;
    LASTTIME@ := t;
end;

BindGlobal("MAKEP1EPS@", function()
    if ValueOption("precision")<>fail then
        @.p1eps := ValueOption("precision");
    else
        @.p1eps := Sqrt(@.reps); # error allowed on P1Map
    fi;
    @.maxratio := 100*@.ro; # maximum ratio, in triangulation, of circumradius to edge length
    if ValueOption("obstruction")<>fail then
        @.obst := ValueOption("obstruction");
    else
        @.obst := 10^-2*@.ro; # points that close are suspected to form an obstruction
    fi;
    @.fast := 10^-1*@.ro; # if spider moved that little, just wiggle it
    @.ratprec := @.reps^(3/4); # quality to achieve in rational fct.
end);

#############################################################################
##
#F Minimal spanning tree
##
BindGlobal("MINSPANTREE@", function(node,cost)
    # node is a list of pairs giving edges
    # cost is a list of real numbers giving edge's cost
    # returns [[i1,j1],...,[in,jn],tree_cost], where [ik,jk] are the
    # edges in the minimal spanning tree.
    local nnode, nedge, tree, tree_cost, new_cost, best,
          potential, arc, free, huge, e, v, w, t;
    
    nnode := Maximum(Concatenation(node));
    nedge := Length(node);
    huge := Sum(cost)+1.0_l; # acts like infinity
    
    free := List([1..nnode],x->true);
    tree := [];
    arc := [];
    
    # find the first non-zero arc
    e := First([1..nedge],e->cost[e]>0.0_l);
    free[e] := false;
    tree_cost := 0.0_l;

    for t in [1..nnode-1] do
        potential := List([1..nnode],i->huge);
        for v in [1..nnode] do
            # for each forward arc originating at node v,
            # compute the length of the path to node v.
            if not free[v] then
                for e in [1..nedge] do
                    if v in node[e] then
                        w := Sum(node[e])-v; # other vertex of edge
                        if free[w] then
                            new_cost := tree_cost + cost[e];
                            if new_cost < potential[w] then
                                potential[w] := new_cost;
                                arc[w] := [v,e];
                            fi;
                        fi;
                    fi;
                od;
            fi;
        od;
        # find the free node of minimum potential
        new_cost := huge;
        best := [0];
        for v in [1..nnode] do
            if free[v] and potential[v] < new_cost then
                new_cost := potential[v];
                best := [v,arc[v][1],arc[v][2]];
            fi;
        od;
        if best[1]>0 then
            free[best[1]] := false;
            tree_cost := tree_cost + cost[best[3]];
            Add(tree,best{[2,1]});
        fi;
    od;
    Add(tree,tree_cost);
    return tree;
end);
#############################################################################

################################################################
# external programs
BindGlobal("EXEC@", rec());
CallFuncList(function(file)
    if file<>fail then Read(file); fi;
end,[Filename(DirectoriesPackagePrograms("img"),"files.g")]);

BindGlobal("JAVAPLOT@", function(input)
    local r, s;
    CHECKEXEC@FR("appletviewer");

    s := "";
    r := [Concatenation("-J-Xmx512m -J-Djava.security.policy=",Filename(DirectoriesPackageLibrary("img","java"),"javaplot.pol")), Filename(DirectoriesPackageLibrary("img","java"),"javaplot.html")];
    if ValueOption("detach")<>fail then
        r := EXECINSHELL@FR(input,Concatenation(EXEC@.appletviewer," ",r[1]," ",r[2]),true);
    else
        r := Process(DirectoryCurrent(), EXEC@.appletviewer, input,
                     OUTPUTTEXTSTRING@FR(s), r);
    fi;
    if r<>"" and r<>0 then
        Error("JAVAPLOT: error ",r,": ",s);
    fi;
end);

#E helpers.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
