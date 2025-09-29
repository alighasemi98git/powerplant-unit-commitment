Sets
    i       "Units"     /1,2,3,4/
    t       "Time periods" /t1*t5/;

Alias (t, tp, tpp);

Parameters
    Demand(t)     "Expected demand (MW)"
       / t1 50
         t2 65
         t3 85
         t4 75
         t5 60 /
    Duration(t)   "Duration of each period (hours)"
       / t1 5
         t2 5
         t3 5
         t4 5
         t5 4 /;

Table UnitData(i,*)
        InitialCost   RunningCost   MinLevel   MaxLevel
    1       15            2.6          10         50
    2       15            2.6          12         45
    3       20            2.3          15         55
    4        1            6.5           2         35;

Parameters
    InitialCost(i), RunningCost(i), MinLevel(i), MaxLevel(i);

InitialCost(i) = UnitData(i, 'InitialCost');
RunningCost(i) = UnitData(i, 'RunningCost');
MinLevel(i) = UnitData(i, 'MinLevel');
MaxLevel(i) = UnitData(i, 'MaxLevel');

Variables
    U(i,t)    "Binary, 1 if unit i is on in period t"
    P(i,t)    "Power produced by unit i in period t (MW)"
    S(i,t)    "Binary, 1 if unit i is started in period t"
    S_warm(i,t) "Binary, 1 if warm start"
    S_cold(i,t) "Binary, 1 if cold start"
    TotalCost "Total cost (kkr)";

Binary Variables U, S, S_warm, S_cold;
Positive Variable P;

Equations
    DemandCon(t)        "Demand must be met"
    Unit4Con(t)         "Unit 4 can only run if Unit 2 or 3 is running"
    MinCon(i,t)         "Minimum production level"
    MaxCon(i,t)         "Maximum production level"
    Consecutive(i,t)     "Max 3 consecutive runs (t1-t4)"
    Startup1(i,t)       "Startup definition lower bound"
    Startup2(i,t)       "Startup definition upper bound 1"
    Startup3(i,t)       "Startup definition upper bound 2"
    Warm1(i,t)          "Warm start constraints 1"
    Warm2(i,t)          "Warm start constraints 2"
    Warm3(i,t)          "Warm start constraints 3"
    Cold1(i,t)          "Cold start constraints 1"
    Cold2(i,t)          "Cold start constraints 2"
    Cold3(i,t)          "Cold start constraints 3"
    Obj                 "Total cost objective";

DemandCon(t).. sum(i, P(i,t)) =g= Demand(t);

Unit4Con(t).. U('4',t) =l= U('2',t) + U('3',t);

MinCon(i,t).. P(i,t) =g= U(i,t) * MinLevel(i);
MaxCon(i,t).. P(i,t) =l= U(i,t) * MaxLevel(i);


Consecutive(i,t).. sum(tp$(ord(tp) >= ord(t) and ord(tp) <= ord(t) + 3 or ord(tp) <= (ord(t) + 3 - card(t))), u(i,tp)) =L= 3;


Startup1(i,t).. S(i,t) =g= U(i,t) - U(i,t--1);
Startup2(i,t).. S(i,t) =l= U(i,t);
Startup3(i,t).. S(i,t) =l= 1 - U(i,t--1);

Warm1(i,t).. S_warm(i,t) =l= S(i,t);
Warm2(i,t).. S_warm(i,t) =l= U(i,t--2);
Warm3(i,t).. S_warm(i,t) =g= S(i,t) + U(i,t--2) - 1;

Cold1(i,t).. S_cold(i,t) =l= S(i,t);
Cold2(i,t).. S_cold(i,t) =l= 1 - U(i,t--2);
Cold3(i,t).. S_cold(i,t) =g= S(i,t) - U(i,t--2);

Obj.. TotalCost =e= sum((i,t), S_warm(i,t)*InitialCost(i) + S_cold(i,t)*1.5*InitialCost(i))
                + sum((i,t), P(i,t)*RunningCost(i)*Duration(t));

Model PowerPlan /all/;
Solve PowerPlan using MIP minimizing TotalCost;

Display U.l, P.l, TotalCost.l;