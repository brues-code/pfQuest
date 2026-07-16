-- Zone world sizes are now read live from the client's WorldMapArea.dbc via
-- ClassicAPI's C_Map.GetMapWorldSize (see the minimap_sizes metatable in
-- map.lua), so the hand-scraped size table has been removed.
--
-- This empty stub is kept so it stays the same table object map.lua attaches
-- the lazy lookup metatable to, and so pfQuest-turtle's patchtable() has a base
-- to merge its minimap-turtle overrides into.
pfDB["minimap"] = {}
