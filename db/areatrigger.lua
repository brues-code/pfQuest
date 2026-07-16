-- Area-trigger geometry is now read live from the client's AreaTrigger.dbc via
-- ClassicAPI's C_Map.GetAreaTriggerInfo (see pfDatabase:SearchAreaTriggerID),
-- so the hand-scraped coordinate table has been removed.
--
-- This empty stub is kept so pfQuest-turtle's patchtable() has a valid base
-- table to merge its data-turtle entries into.
pfDB["areatrigger"]["data"] = {}
