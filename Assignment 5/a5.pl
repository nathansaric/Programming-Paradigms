% Nathan Saric - 04/19/2022

/*
 * Q1: Student ID
 */
student_id(20099897).
% second_student_id(  ).
% if in a group, uncomment the above line and put the other student ID here

/*
  In this version of classical propositional logic,
  we have the following possible Formulas:

  top                        % truth
  v(PropVar)                 % atomic propositions (Atom(...) in a3)
  and(Formula, Formula)      % conjunction
  or(Formula, Formula)       % disjunction
  implies(Formula, Formula)  % implication
  not(Formula)               % negation

  Some example atomic formulas:

    v(a)
    v(b)
    v(c)
    v(d)
    v(e)
*/

/*
Q2: Disjunctive Normal Form

A formula psi is in disjunctive normal form (DNF) iff

   psi is a disjunction ("or") of phi1 ... phiN, where
   each phi is a conjunction ("and") of literals, where
   a literal is a variable or the negation of a variable.

Q2a.
Write Prolog predicates  conjlit( Phi) and
                         dnf( Psi)
where
  literal( Phi)  is true iff Phi is either v(_) or not(v(_))

  conjlit( Phi)  is true iff Phi is a literal,
                             or Phi is  and( Phi1, Phi2)
                             where both Phi1 and Phi2 are conjunctions of literals

  dnf( Psi)      is true iff Psi is a conjunction of literals,
                             or Psi is  or( Psi1, Psi2)
                             where both Psi1 and Psi2 are in DNF.

All of these predicates only need to work in the "input moding":
  you can assume that Phi is concrete data, not a Prolog variable.

We have written literal for you.
*/

literal(v(_)).
literal(not(v(_))).

conjlit(Phi) :- literal(Phi).
conjlit(Phi) :- 
  Phi = and(Phi1, Phi2),
  conjlit(Phi1),
  conjlit(Phi2).

dnf(Psi) :- conjlit(Psi).
dnf(Psi) :-
  Psi = or(Psi1, Psi2),
  dnf(Psi1),
  dnf(Psi2).

/*
Q2b. Converting to DNF

In this question, you will implement one part of an algorithm to convert
formulas to disjunctive normal form: applying the "material implication"
law
       P -> Q  ≡  ¬P \/ Q
That is,
       P implies Q   iff   (not P) or Q.

Define a predicate

       materialize( Phi1, Phi2)

where, given a concrete formula Phi1, 'materialize' "returns" a formula Phi2
in which all  implies(P, Q) in Phi1  are replaced with  or(not(P), Q),
recursively.

For example:

      ?- materialize( implies(implies(v(a), v(b)), v(c)), Result).
      Result = or(not(or(not(v(a)), v(b))), v(c))

This query should return exactly one solution (the one shown above).

You may use cuts if you wish.

You may change the starter code (the  not  case), if you want.
*/

materialize(implies(P, Q), or(not(P1), Q1)) :- materialize(P, P1), materialize(Q, Q1).
materialize(and(P, Q), and(P1, Q1))         :- materialize(P, P1), materialize(Q, Q1).
materialize(or(P, Q), or(P1, Q1))           :- materialize(P, P1), materialize(Q, Q1).
materialize(not(P), not(P1))                :- materialize(P, P1).
materialize(v(P), v(P)).
materialize(top, top).

/*
  Q2c:
  Consider the query

    ?- materialize(P,  or(not(or(not(v(a)), v(b))), v(c))).

  where, reversed from Q2b, the first argument is a Prolog variable and the second argument is a concrete formula.
  
  Depending on how you implemented materialize, this query may give one, two, or maybe even more solutions.

  Q2b only cares about the "moding" where Phi1 is concrete and Phi2 is a variable,
  so returning only one solution may be correct; returning more than one solution may be correct.

  Explain why your implementation behaves the way it does.

  Hint: The answer may depend on whether, and how, you used cuts.
*/

/* Write your explanation here:
   When given the query:

   ?- materialize(P,  or(not(or(not(v(a)), v(b))), v(c))).

   materialize returns the following:

   P = implies(implies(v(a), v(b)), v(c)) ;
   P = implies(or(not(v(a)), v(b)), v(c)) ;
   P = or(not(implies(v(a), v(b))), v(c)) ;
   P = or(not(or(not(v(a)), v(b))), v(c)).

   The predicate attempts to find all possible solutions for P that satisfy the query.
   Note that since materiaize was implemented without using cuts, all possibles solutions are outputted. 
      1. The first solution applies the material implication law twice, to the outer and inner 'implies'.
      2. The second solution only applies the material implication law to the outer 'implies'.
      3. The third solution only applies the material implication law to the inner 'implies'.
      4. The fourth solution does not apply the material implication law and simply returns the RHS.

   Essentially, materialize, in the context of this query, is recursively applying the material implication law to the RHS as such:
   ¬P \/ Q ≡ P -> Q  

   That is,
   (not P) or Q   iff   P implies Q.
*/

/*
Q3: Tiny Theorem Prover
*/

/*
  prove(Ctx, P, Rules):
    true if, assuming everything in Ctx is true,
     the formula p is true according to the rules given in a5.pdf,
     using the rules listed in Rules.
     (The listing of rules *roughly* corresponds to the rules you would write
     down in a CISC 204-style proof, with the following rough correspondence:

        premise          use_assumption
        copy             use_assumption
        ->i              implies_right
        ->e              implies_left
        /\i              and_right
        /\e1, /\e2       and_left
        top i            top_right
     )
     
  This is the cool part:
    *each rule becomes a Prolog clause*.

  There is no "problem solving" where someone (like the instructor)
    figures out a strategy for applying Left and Right rules without getting
    into an infinite loop.

  In Prolog, we can write one clause for each logical rule, and it "just works".
*/

/*                          P in Ctx
                          ––––––––––––
 rule 'UseAssumption'       Ctx |- P
*/

prove(Ctx, P, [use_assumption]) :- member(P, Ctx).

/*                       ––––––––––
  rule 'Top-Right'       Ctx |- top
*/

prove( _, top, [top_right]).

/*
  We will use append "backwards":
  instead of taking concrete lists
  provided in a query, we take a concrete *appended* list Ctx
  and use append to "split up" the Ctx.
*/

/*
Q3a:
  Write Prolog clauses that correspond to the rules

    And-Right,
    Implies-Right.
*/

/*
  rule 'And-Right'
               Ctx |- Q1     Ctx |- Q2
               -----------------------
  CONCLUSION:    Ctx |- and(Q1, Q2)
*/

prove(Ctx, and(Q1, Q2), R) :- 
  prove(Ctx, Q1, RulesQ1),
  prove(Ctx, Q2, RulesQ2),
  append(RulesQ1, RulesQ2, RulesQ),
  append(RulesQ, [and_right], R).

/*
  rule 'Implies-Right'
                  [P | Ctx] |- Q
               -------------------------
  CONCLUSION:     Ctx |- implies(P, Q)
*/

prove(Ctx, implies(P1, Q1), R) :- 
  prove([P1 | Ctx], Q1, RulesQ1),
  append(RulesQ1, [implies_right], R).

/*
  rule 'And-Left'
                 Ctx1 ++ [P1, P2] ++ Ctx2 |- Q
               ----------------------------------
  CONCLUSION:  Ctx1 ++ [and(P1, P2)] ++ Ctx2 |- Q
*/

prove(Ctx, Q, R) :-
  append(Ctx1, [and(P1, P2) | Ctx2], Ctx),
  append(Ctx1, [P1 | [P2 | Ctx2]], CtxP12),
  prove(CtxP12, Q, Rules),
  append(Rules, [and_left], R).

/*
  Q3b: Implies-Left
*/

/*
  rule 'Implies-Left'
               Ctx1 ++ Ctx2 |- P1     Ctx1 ++ [P2] ++ Ctx2 |- Q
               ------------------------------------------------
   CONCLUSION:     Ctx1 ++ [implies(P1, P2)] ++ Ctx2 |- Q
*/

prove(Ctx, Q, R) :-
  append(Ctx1, [implies(P1, P2) | Ctx2], Ctx),
  append(Ctx1, Ctx2, Ctx12),
  append(Ctx1, [P2 | Ctx2], CtxP2),
  prove(Ctx12, P1, RulesP1),
  prove(CtxP2, Q, RulesQ),
  append(RulesP1, RulesQ, Rules),
  append(Rules, [implies_left], R).

/*
  ?- prove([implies(v(b), v(h))], implies(v(b), v(h)), R).
  R = [use_assumption]
   % CISC 204-style proof:
   %    1. implies(v(b), v(h))     premise       use_assumption
   % 
  R = [use_assumption, use_assumption, implies_left, implies_right]
   % CISC 204-style proof:
   %     ____________________________________
   % 1  | v(b)                    assumption |
   % 2  | implies(v(b), v(h))     premise    |  [use_assumption,
   % 3  | v(b)                    copy 1     |   use_assumption,
   % 4  | v(h)                    ->e 2, 3   |   implies_left,
   %    |____________________________________|
   % 5   implies(v(b), v(h))      ->i 1-4        implies_right]
   %     
  false.

  ?- prove([v(d)], implies(and(v(b), v(b)), v(d)), R).
  R = [use_assumption, implies_right] 
  R = [use_assumption, and_left, implies_right] 
  false.

  ?- prove([implies(and(v(b), v(e)), v(d))], implies(v(b), v(h)), R).
  false.

  ?- prove([and(and(v(a), v(b)), and(v(d), (v(e))))], v(d), R).
  R = [use_assumption, and_left, and_left, and_left] 
  R = [use_assumption, and_left, and_left] 
  R = [use_assumption, and_left, and_left, and_left] 
  false.
*/
