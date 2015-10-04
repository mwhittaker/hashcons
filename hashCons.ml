open Core.Std

type 'a hash_consed = {
  node: 'a;
  tag:  int;
  hkey: int;
} with sexp, compare

module type HashedType = sig
  type t with sexp, compare
  val equal: t -> t -> bool
  val hash:  t -> int
end

module Make(H: HashedType) = struct
  module Key = struct
    module T = struct
      type t = H.t with sexp
      let compare = H.compare
      let hash = H.hash
    end
    include T
    include Hashable.Make (T)
  end

  let get_id : unit -> int =
    let id = ref 0 in
    fun () -> (incr id; !id)

  type t = (H.t, H.t hash_consed) Hashtbl.t

  let create n =
    Key.Table.create () ~size:13

  let hashcons t x =
    match Hashtbl.find t x with
    | Some y -> y
    | None -> begin
      let y = {
        node = x;
        tag  = get_id ();
        hkey = H.hash x;
      } in
      ignore (Hashtbl.add t ~key:x ~data:y);
      y
    end
end
