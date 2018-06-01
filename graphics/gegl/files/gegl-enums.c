


/* This is a generated file, do not edit directly */

#include "config.h"
#include <glib-object.h>
#include "gegl-enums.h"

/* enumerations from "./gegl-enums.h" */
GType
gegl_sampler_type_get_type (void)
{
  static GType etype = 0;
  if (etype == 0) {
    static const GEnumValue values[] = {
      { GEGL_SAMPLER_NEAREST, "nearest", "nearest" },
      { GEGL_SAMPLER_LINEAR, "linear", "linear" },
      { GEGL_SAMPLER_CUBIC, "cubic", "cubic" },
      { GEGL_SAMPLER_LOHALO, "lohalo", "lohalo" },
      { 0, NULL, NULL }
    };
    etype = g_enum_register_static ("GeglSamplerType", values);
  }
  return etype;
}

GType
gegl_abyss_policy_get_type (void)
{
  static GType etype = 0;
  if (etype == 0) {
    static const GEnumValue values[] = {
      { GEGL_ABYSS_NONE, "none", "none" },
      { GEGL_ABYSS_CLAMP, "clamp", "clamp" },
      { GEGL_ABYSS_LOOP, "loop", "loop" },
      { GEGL_ABYSS_BLACK, "black", "black" },
      { GEGL_ABYSS_WHITE, "white", "white" },
      { 0, NULL, NULL }
    };
    etype = g_enum_register_static ("GeglAbyssPolicy", values);
  }
  return etype;
}




