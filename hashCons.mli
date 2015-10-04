open Core.Std

type 'a hash_consed = private {
  node: 'a;
  tag:  int;
  hkey: int;
} with sexp, compare

module type HashedType = sig
  type t with sexp, compare
  val equal: t -> t -> bool
  val hash:  t -> int
end

module Make(H: HashedType): sig
  type t
  val create: int -> t
  val hashcons: t -> H.t -> H.t hash_consed
end
