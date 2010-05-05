#include "config.h"

#include "types.h"

/** Return true for any variable that is a char */
bool is_signed_char(const char& a_arg) 
{ return(true); }

/** Return true for any variable that is an unsigned char */
bool is_unsigned_char(const unsigned char& a_arg) 
{ return(true); }

/** Return true for any variable that is a short */
bool is_signed_short(const short& a_arg) 
{ return(true); }

/** Return true for any variable that is an unsigned short */
bool is_unsigned_short(const unsigned short& a_arg)
{ return(true); }

/** Return true for any variable that is a int */
bool is_signed_int(const int& a_arg) 
{ return(true); }

/** Return true for any variable that is an unsigned int */
bool is_unsigned_int(const unsigned int& a_arg) 
{ return(true); }

/** Return true for any variable that is a long */
bool is_signed_long(const long& a_arg) 
{ return(true); }

/** Return true for any variable that is an unsigned long */
bool is_unsigned_long(const unsigned long& a_arg) 
{ return(true); }

/** Return true for any variable that is a long long */
bool is_signed_long_long(const long long& a_arg) 
{ return(true); }

/** Return true for any variable that is an unsigned long long */
bool is_unsigned_long_long(const unsigned long long& a_arg) 
{ return(true); }

/** Return true for any variable that is a float */
bool is_float(const float& a_arg) 
{ return(true); }

/** Return true for any variable that is a double */
bool is_double(const double& a_arg) 
{ return(true); }

/** Return true for any variable that is a bool */
bool is_bool(const bool& a_arg)
{ return(true); }

const char * type_name(const unsigned char & a_arg)
{ return("unsigned char"); }

const char * type_name(const char & a_arg)
{ return("char"); }

const char * type_name(const unsigned short & a_arg)
{ return("unsigned short"); }

const char * type_name(const short & a_arg)
{ return("short"); }

const char * type_name(const unsigned int & a_arg)
{ return("unsigned int"); }

const char * type_name(const int & a_arg)
{ return("int"); }

const char * type_name(const unsigned long & a_arg)
{ return("unsigned long"); }

const char * type_name(const long & a_arg)
{ return("long"); }

const char * type_name(const unsigned long long & a_arg)
{ return("unsigned long long"); }

const char * type_name(const long long & a_arg)
{ return("long long"); }

const char * type_name(const float & a_arg)
{ return("float"); }

const char * type_name(const double & a_arg)
{ return("double"); }

const char * type_name(const bool & a_arg)
{ return("bool"); }
