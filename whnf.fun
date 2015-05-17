functor Whnf (Syn : ABT_UTIL where Operator = Operator) : WHNF =
struct
  type term = Syn.t
  exception Stuck of term

  open Operator Syn
  infix $ $$

  fun whnf x =
    case out x of
         SPREAD $ #[M, xyN] =>
           (case out (whnf M) of
                PAIR $ #[M1, M2] =>
                  let
                    val (x,yN) = unbind xyN
                    val (y, N) = unbind yN
                    val N' = subst M1 x (subst M2 y N)
                  in
                    whnf N'
                  end
              | _ => x)
       | AP $ #[M,N] =>
           (case out (whnf M) of
                 LAM $ #[xE] => whnf (subst1 xE N)
               | _ => x)
       | MATCH_UNIT $ #[M,N] =>
           (case out (whnf M) of
                 AX $ #[] => whnf N
               | _ => x)
       | _ => x


end
