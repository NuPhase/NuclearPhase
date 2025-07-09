#include "items/clothing/accessories_mil.dm"

#include "jobs/administration.dm"
#include "jobs/site_operations.dm"
#include "jobs/reactor_operations.dm"
#include "jobs/laboratories.dm"
#include "jobs/security.dm"

#include "outfits/_pda.dm"
#include "outfits/cargo.dm"
#include "outfits/civilian.dm"
#include "outfits/command.dm"
#include "outfits/engineering.dm"
#include "outfits/medical.dm"
#include "outfits/science.dm"
#include "outfits/security.dm"
#include "outfits/surface.dm"

#include "serenity_areas.dm"
#include "serenity_define.dm"
#include "serenity_departments.dm"
#include "serenity_jobs.dm"
#include "serenity_overmap.dm"
#include "serenity_ranks.dm"
#include "serenity_shuttles.dm"
#include "serenity_unit_testing.dm"

#ifndef DEBUG_ENVIRONMENT

#include "serenity.dmm"
#include "..\overmap\roadsegment.dmm"
#include "..\overmap_locs\datacenter.dmm"
#include "..\overmap_locs\demolished_skyscraper.dmm"
#include "..\overmap_locs\space_center.dmm"
#include "..\overmap_locs\space\icarus_body.dmm"
#include "..\overmap_locs\space\icarus_ring.dmm"
#include "..\overmap_locs\space\typhos.dmm"

#endif

#include "ghost_skyscraper.dmm"
#include "limb.dmm"

#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"

#ifndef DEBUG_ENVIRONMENT
#define USING_MAP_DATUM /datum/map/serenity
#endif