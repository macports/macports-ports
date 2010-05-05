#include "config.h"

#include "error.h"
#include "rmath.h"

/** Return the largest possible number that a float may hold. */
template<>
const float max_limit<float>()
{
	return(FLT_MAX);
}

/** Return the smallest positive number that a float may hold.
 *
 * Caveat: This is in contrast to other types, where min_limit<T>() will return
 * either 0 or the largest possible negative number that the type may hold.  If
 * you are looking for the largest possible negative number for any given type,
 * use lowest_value<T>() instead.
 */
template<>
const float min_limit<float>()
{
	return(FLT_MIN);
}

/** Return the largest possible number that a double may hold. */
template<>
const double max_limit<double>()
{
	return(DBL_MAX);
}

/** Return the smallest positive number that a double may hold.
 *
 * Caveat: This is in contrast to other types, where min_limit<T>() will return
 * either 0 or the largest possible negative number that the type may hold.  If
 * you are looking for the largest possible negative number for any given type,
 * use lowest_value<T>() instead.
 */
template<>
const double min_limit<double>()
{
	return(DBL_MIN);
}
