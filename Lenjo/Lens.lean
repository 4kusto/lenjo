-- SPDX-FileCopyrightText: 2026 Yuki Otsuka
--
-- SPDX-License-Identifier: BSD-3

namespace Lenjo

/-- A lens focuses on a part `A` within a whole `S`,
    providing lawful get and set operations. -/
structure Lens (S A : Type) where
  get : S → A
  set : A → S → S

namespace Lens

/-- Modify the focused value in-place. -/
@[inline]
def over (l : Lens S A) (f : A → A) (s : S) : S :=
  l.set (f (l.get s)) s

/-- Compose two lenses. `outer ⊚ inner` focuses on `inner`'s target
    within the field that `outer` focuses on. -/
@[inline]
def comp (outer : Lens S A) (inner : Lens A B) : Lens S B :=
  { get := inner.get ∘ outer.get
    set := fun b s => outer.set (inner.set b (outer.get s)) s }

/-- The identity lens: focuses on the whole structure. -/
def id : Lens S S :=
  { get := _root_.id
    set := fun s _ => s }

/-- Lift a lens to operate inside a Functor context (e.g. `Option`). -/
def liftOption (l : Lens S A) : Lens (Option S) (Option A) :=
  { get := Option.map l.get
    set := fun oa os => match oa, os with
      | some a, some s => some (l.set a s)
      | _, _ => os }

/-- Focus on the first element of a pair. -/
def fst : Lens (A × B) A :=
  { get := Prod.fst
    set := fun a (_, b) => (a, b) }

/-- Focus on the second element of a pair. -/
def snd : Lens (A × B) B :=
  { get := Prod.snd
    set := fun b (a, _) => (a, b) }

end Lens

end Lenjo
