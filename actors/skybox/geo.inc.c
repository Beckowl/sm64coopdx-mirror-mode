#include "src/game/envfx_snow.h"

const GeoLayout skybox_3_texture_switch_opt1[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_fire_sky_0),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt2[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_underwater_city_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt3[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_clouds_2),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt4[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_mountains_3),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt5[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_desert_4),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt6[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_woods_5),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt7[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_dark_world_6),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt8[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_sky_7),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_3_texture_switch_opt9[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0_mat_override_purple_sky_8),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_NODE_START(),
		GEO_OPEN_NODE(),
			GEO_ASM(0, geo_skybox_set_color),
			GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_set_color),
			GEO_SWITCH_CASE(0, geo_skybox_set_texture),
			GEO_OPEN_NODE(),
				GEO_NODE_START(),
				GEO_OPEN_NODE(),
					GEO_DISPLAY_LIST(LAYER_FORCE, skybox_dl_mesh_layer_0),
				GEO_CLOSE_NODE(),
				GEO_BRANCH(1, skybox_3_texture_switch_opt1),
				GEO_BRANCH(1, skybox_3_texture_switch_opt2),
				GEO_BRANCH(1, skybox_3_texture_switch_opt3),
				GEO_BRANCH(1, skybox_3_texture_switch_opt4),
				GEO_BRANCH(1, skybox_3_texture_switch_opt5),
				GEO_BRANCH(1, skybox_3_texture_switch_opt6),
				GEO_BRANCH(1, skybox_3_texture_switch_opt7),
				GEO_BRANCH(1, skybox_3_texture_switch_opt8),
				GEO_BRANCH(1, skybox_3_texture_switch_opt9),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
