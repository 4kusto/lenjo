-- SPDX-FileCopyrightText: 2026 Yuki Otsuka
--
-- SPDX-License-Identifier: BSD-3

import Lenjo.Lens

namespace Lenjo

/-- An optional focuses on a part `A` that may or may not exist in `S`.
    Like a lens, but `get` can fail. -/
structure Optional (S A : Type) where
  get? : S → Option A
  set : A → S → S

namespace Optional

/-- Modify the focused value if it exists; no-op otherwise. -/
@[inline]
def over (o : Optional S A) (f : A → A) (s : S) : S :=
  match o.get? s with
  | some a => o.set (f a) s
  | none   => s

/-- Compose a `Lens` with an `Optional`: the result is an `Optional`. -/
@[inline]
def ofLens (outer : Lens S A) (inner : Optional A B) : Optional S B :=
  { get? := fun s => inner.get? (outer.get s)
    set  := fun b s => outer.set (inner.set b (outer.get s)) s }

/-- Compose two `Optional`s. -/
@[inline]
def comp (outer : Optional S A) (inner : Optional A B) : Optional S B :=
  { get? := fun s => outer.get? s >>= inner.get?
    set  := fun b s =>
      match outer.get? s with
      | some a => outer.set (inner.set b a) s
      | none   => s }

/-- Lift a `Lens` into an `Optional` (always succeeds). -/
@[inline]
def ofLensFull (l : Lens S A) : Optional S A :=
  { get? := some ∘ l.get
    set  := l.set }

/-- Focus on the value inside `Option`. -/
def some : Optional (Option A) A :=
  { get? := _root_.id
    set  := fun v _ => .some v }

/-- Focus on the nth element of an `Array`, if in bounds. -/
def arrayAt (i : Nat) : Optional (Array α) α :=
  { get? := fun a => a[i]?
    set  := fun v a => a.set! i v }

/-- Focus on a list element by index. -/
def listAt (i : Nat) : Optional (List α) α :=
  { get? := fun xs => xs[i]?
    set  := fun v xs =>
      xs.mapIdx (fun j x => if j == i then v else x) }

end Optional

end Lenjo
