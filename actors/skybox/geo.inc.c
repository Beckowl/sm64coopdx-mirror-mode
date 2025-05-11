#include "src/game/envfx_snow.h"

const GeoLayout skybox_skybox_obj__invisible_[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt1[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_ocean_0),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt2[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_fiery_sky_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt3[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_underwater_city_2),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt4[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_clouds_3),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt5[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_icy_mountains_4),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt6[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_desert_5),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt7[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_dark_woods_6),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt8[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_dark_world_7),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt9[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_sky_8),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_visibility_switch_opt2_skybox_texture_switch_opt10[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1_mat_override_purple_sky_9),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_skybox_obj__textured_[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_SWITCH_CASE(0, geo_skybox_set_texture),
		GEO_OPEN_NODE(),
			GEO_NODE_START(),
			GEO_OPEN_NODE(),
				GEO_DISPLAY_LIST(LAYER_OPAQUE, skybox_switch_option_textured_skybox_dl_mesh_layer_1),
			GEO_CLOSE_NODE(),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt1),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt2),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt3),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt4),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt5),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt6),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt7),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt8),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt9),
			GEO_BRANCH(1, skybox_visibility_switch_opt2_skybox_texture_switch_opt10),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout skybox_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_SWITCH_CASE(0, geo_skybox_set_visibility),
		GEO_OPEN_NODE(),
			GEO_NODE_START(),
			GEO_OPEN_NODE(),
				GEO_ANIMATED_PART(LAYER_OPAQUE, 0, 0, 0, NULL),
			GEO_CLOSE_NODE(),
			GEO_BRANCH(1, skybox_skybox_obj__invisible_),
			GEO_BRANCH(1, skybox_skybox_obj__textured_),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
