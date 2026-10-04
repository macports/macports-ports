#include "config.h"
#include <wtf/darwin/OSLogPrintStream.h>
#if OS(DARWIN)
#include <cstdio>
namespace WTF {

OSLogPrintStream::OSLogPrintStream(os_log_t log, os_log_type_t type)
    : m_log(log)
    , m_logType(type)
{
}

OSLogPrintStream::~OSLogPrintStream() { }

std::unique_ptr<OSLogPrintStream> OSLogPrintStream::open(const char* subsystem, const char* category, os_log_type_t logType)
{
    return std::unique_ptr<OSLogPrintStream>(new OSLogPrintStream(os_log_create(subsystem, category), logType));
}

void OSLogPrintStream::vprintf(const char* format, va_list args)
{
    Locker locker { m_stringLock };
    char buf[512];
    std::vsnprintf(buf, sizeof(buf), format, args);
    os_log_with_type(m_log, m_logType, "%{public}s", buf);
}

} // namespace WTF
#endif
