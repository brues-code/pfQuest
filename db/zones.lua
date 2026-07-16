-- Subzone placement (parent zone + center) is now read live from the client's
-- WorldMapOverlay.dbc via ClassicAPI's C_Map.GetMapOverlays (see the zone index
-- in database.lua), so the hand-scraped placement table has been removed.
--
-- This empty stub is kept so pfQuest-turtle's patchtable() has a base table to
-- merge its data-turtle entries into (those are folded into the live index and
-- take precedence). Localized zone names live in db/<locale>/zones.lua and are
-- untouched.
pfDB["zones"]["data"] = {}
