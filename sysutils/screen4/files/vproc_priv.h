#ifndef _VPROC_PRIVATE_H_
#define _VPROC_PRIVATE_H_
/*
 * Copyright (c) 2006 Apple Computer, Inc. All rights reserved.
 *
 * @APPLE_APACHE_LICENSE_HEADER_START@
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * @APPLE_APACHE_LICENSE_HEADER_END@
 */

#include <Availability.h>
#include <sys/types.h>
#include <sys/cdefs.h>
#include <sys/syslog.h>
#include <sys/time.h>
#include <stdbool.h>
#include <launch.h>
#include <vproc.h>

#ifndef VPROC_HAS_TRANSACTIONS
	#define VPROC_HAS_TRANSACTIONS
#endif

__BEGIN_DECLS

#pragma GCC visibility push(default)

/* DO NOT use this. This is a hack for 'launchctl' */
#define VPROC_MAGIC_UNLOAD_SIGNAL	0x4141504C
/* DO NOT use this. This is a hack for 'loginwindow' */
#define VPROC_MAGIC_TRYKILL_SIGNAL	0x6161706C

typedef enum {
	VPROC_GSK_LAST_EXIT_STATUS = 1,
	VPROC_GSK_GLOBAL_ON_DEMAND,
	VPROC_GSK_MGR_UID,
	VPROC_GSK_MGR_PID,
	VPROC_GSK_IS_MANAGED,
	VPROC_GSK_BASIC_KEEPALIVE,
	VPROC_GSK_START_INTERVAL,
	VPROC_GSK_IDLE_TIMEOUT,
	VPROC_GSK_EXIT_TIMEOUT,
	VPROC_GSK_ENVIRONMENT,
	VPROC_GSK_ALLJOBS,
	VPROC_GSK_GLOBAL_LOG_MASK,
	VPROC_GSK_GLOBAL_UMASK,
	VPROC_GSK_ABANDON_PROCESS_GROUP,
	VPROC_GSK_TRANSACTIONS_ENABLED,
	VPROC_GSK_WEIRD_BOOTSTRAP,
	VPROC_GSK_WAITFORDEBUGGER,
} vproc_gsk_t;

typedef unsigned int vproc_flags_t;
/* For _vproc_kickstart_by_label() -- instructs launchd to kickstart the job to stall before exec(2). */
#define VPROCFLAG_STALL_JOB_EXEC	1 << 1

vproc_t vprocmgr_lookup_vproc(const char *label);
vproc_t vproc_retain(vproc_t vp);
void vproc_release(vproc_t vp);

vproc_err_t vproc_swap_integer(vproc_t vp, vproc_gsk_t key, int64_t *inval, int64_t *outval);
vproc_err_t vproc_swap_complex(vproc_t vp, vproc_gsk_t key, launch_data_t inval, launch_data_t *outval);

vproc_err_t _vproc_get_last_exit_status(int *wstatus);
vproc_err_t _vproc_set_global_on_demand(bool val);

typedef void (*_vprocmgr_log_drain_callback_t)(struct timeval *when, pid_t from_pid, pid_t about_pid, uid_t sender_uid, gid_t sender_gid, int priority, const char *from_name, const char *about_name, const char *session_name, const char *msg);

vproc_err_t _vprocmgr_log_drain(vproc_t vp, pthread_mutex_t *optional_mutex_around_callback, _vprocmgr_log_drain_callback_t func);

vproc_err_t _vproc_send_signal_by_label(const char *label, int sig);
vproc_err_t _vproc_kickstart_by_label(const char *label, pid_t *out_pid, mach_port_t *out_port_name, mach_port_t *out_obsrvr_port, vproc_flags_t flags);
vproc_err_t _vproc_wait_by_label(const char *label, int *out_wstatus);

void _vproc_log(int pri, const char *msg, ...) __attribute__((format(printf, 2, 3)));
void _vproc_log_error(int pri, const char *msg, ...) __attribute__((format(printf, 2, 3)));
void _vproc_logv(int pri, int err, const char *msg, va_list ap) __attribute__((format(printf, 3, 0)));

#define VPROCMGR_SESSION_LOGINWINDOW	"LoginWindow"
#define VPROCMGR_SESSION_BACKGROUND		"Background"
#define VPROCMGR_SESSION_AQUA			"Aqua"
#define VPROCMGR_SESSION_STANDARDIO		"StandardIO"
#define VPROCMGR_SESSION_SYSTEM			"System"

vproc_err_t _vprocmgr_move_subset_to_user(uid_t target_user, const char *session_type);
vproc_err_t _vprocmgr_switch_to_session(const char *target_session, vproc_flags_t flags);
vproc_err_t _vprocmgr_detach_from_console(vproc_flags_t flags);

void _vproc_standby_begin(void)																__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
void _vproc_standby_end(void)																__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
size_t _vproc_standby_count(void)															__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
size_t _vproc_standby_timeout(void)															__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);

kern_return_t _vproc_transaction_count_for_pid(pid_t p, int32_t *count, bool *condemned)	__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
bool _vproc_pid_is_managed(pid_t p)															__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
void _vproc_transaction_try_exit(int status)												__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
void _vproc_transaction_begin(void)															__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
void _vproc_transaction_end(void)															__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);
size_t _vproc_transaction_count(void)														__OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_NA);

#pragma GCC visibility pop

__END_DECLS

#endif
