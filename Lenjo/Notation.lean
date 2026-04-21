-- SPDX-FileCopyrightText: 2026 Yuki Otsuka
--
-- SPDX-License-Identifier: BSD-3

import Lenjo.Lens
import Lenjo.Optional

namespace Lenjo

-- Lens composition: `outer ⊚ inner`
infixl:60 " ⊚ " => Lens.comp

-- View: `s ^. l` extracts the focused value from `s`
infixl:80 " ^. " => fun s (l : Lens _ _) => l.get s

-- Set (curried): `(l .= v) s` sets the focused field to `v` in `s`
notation:70 l " .= " v => fun s => Lens.set l v s

-- Modify (curried): `(l %~ f) s` applies `f` to the focused field in `s`
notation:70 l " %~ " f => fun s => Lens.over l f s

-- Optional view: `s ^? o` returns `Option` of the focused value
infixl:80 " ^? " => fun s (o : Optional _ _) => o.get? s

-- Optional set (curried): `(o .?= v) s`
notation:70 o " .?= " v => fun s => Optional.set o v s

-- Optional modify (curried): `(o %?~ f) s`
notation:70 o " %?~ " f => fun s => Optional.over o f s

end Lenjo
