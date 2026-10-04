// Stub for GTK port on macOS — the real header requires Objective-C.
#pragma once

#include <wtf/OSObjectPtr.h>

#ifndef OS_OBJECT_CLASS
#define OS_OBJECT_CLASS(name) OS_##name
#endif

namespace WTF {
template<typename> struct OSObjectTypeCastTraits;
}

// No-op macros: type-cast traits and isOSObject checks are not needed for GTK.
#define WTF_DECLARE_OS_OBJECT_TYPE_CAST_TRAITS_INTERNAL(TypeName, Suffix)
#define WTF_IMPLEMENT_IS_OS_OBJECT_FUNCTIONS_INTERNAL(TypeName, ProtocolString)
