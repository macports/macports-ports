/* stub epoxy/egl.h for macOS — EGL is not available on this platform.
 * Provides type definitions and no-op stubs so that WebKit EGL source files
 * compile. At runtime, EGL code paths are never taken on macOS.
 *
 * Type definitions follow the Khronos EGL 1.5 specification.
 */
#pragma once

#include <stdint.h>
#include <stddef.h>
#include <epoxy/gl.h>

#ifdef __cplusplus
extern "C" {
#endif

/* EGL basic types */
typedef unsigned int EGLBoolean;
typedef unsigned int EGLenum;
typedef int32_t EGLint;
typedef intptr_t EGLAttrib;
typedef void *EGLDisplay;
typedef void *EGLConfig;
typedef void *EGLSurface;
typedef void *EGLContext;
typedef void *EGLImage;
typedef void *EGLImageKHR;
typedef void *EGLSync;
typedef void *EGLSyncKHR;
typedef void *EGLClientBuffer;
typedef void *EGLDeviceEXT;
typedef void (*__eglMustCastToProperFunctionPointerType)(void);
typedef uint64_t EGLNativeWindowType;
typedef void *EGLNativeDisplayType;

/* EGL constants */
#define EGL_FALSE                       0
#define EGL_TRUE                        1
#define EGL_SUCCESS                     0x3000
#define EGL_NOT_INITIALIZED             0x3001
#define EGL_BAD_ACCESS                  0x3002
#define EGL_BAD_ALLOC                   0x3003
#define EGL_BAD_ATTRIBUTE               0x3004
#define EGL_BAD_CONFIG                  0x3005
#define EGL_BAD_CONTEXT                 0x3006
#define EGL_BAD_CURRENT_SURFACE         0x3007
#define EGL_BAD_DISPLAY                 0x3008
#define EGL_BAD_MATCH                   0x3009
#define EGL_BAD_NATIVE_PIXMAP           0x300A
#define EGL_BAD_NATIVE_WINDOW           0x300B
#define EGL_BAD_PARAMETER               0x300C
#define EGL_BAD_SURFACE                 0x300D
#define EGL_CONTEXT_LOST                0x300E
#define EGL_NONE                        0x3038
#define EGL_DEFAULT_DISPLAY             ((EGLNativeDisplayType)0)
#define EGL_NO_CONTEXT                  ((EGLContext)0)
#define EGL_NO_DISPLAY                  ((EGLDisplay)0)
#define EGL_NO_SURFACE                  ((EGLSurface)0)
#define EGL_NO_IMAGE                    ((EGLImage)0)
#define EGL_NO_IMAGE_KHR                ((EGLImageKHR)0)
#define EGL_NO_SYNC                     ((EGLSync)0)

#define EGL_ALPHA_SIZE                  0x3021
#define EGL_BLUE_SIZE                   0x3022
#define EGL_GREEN_SIZE                  0x3023
#define EGL_RED_SIZE                    0x3024
#define EGL_DEPTH_SIZE                  0x3025
#define EGL_STENCIL_SIZE               0x3026
#define EGL_SURFACE_TYPE                0x3033
#define EGL_RENDERABLE_TYPE             0x3040
#define EGL_HEIGHT                      0x3056
#define EGL_WIDTH                       0x3057
#define EGL_EXTENSIONS                  0x3055
#define EGL_VERSION                     0x3054
#define EGL_VENDOR                      0x3053

#define EGL_PBUFFER_BIT                 0x0001
#define EGL_PIXMAP_BIT                  0x0002
#define EGL_WINDOW_BIT                  0x0004

#define EGL_OPENGL_ES_API               0x30A0
#define EGL_OPENGL_API                  0x30A2
#define EGL_OPENGL_ES_BIT               0x0001
#define EGL_OPENGL_ES2_BIT              0x0004
#define EGL_CONTEXT_CLIENT_VERSION      0x3098

#define EGL_DRAW                        0x3059
#define EGL_READ                        0x305A

#define EGL_FOREVER                     0xFFFFFFFFFFFFFFFFull
#define EGL_FOREVER_KHR                 0xFFFFFFFFFFFFFFFFull
#define EGL_SYNC_FENCE_KHR              0x30F9
#define EGL_SYNC_NATIVE_FENCE_ANDROID   0x3144
#define EGL_SYNC_NATIVE_FENCE_FD_ANDROID 0x3145

/* Extension tokens */
#define EGL_PLATFORM_SURFACELESS_MESA   0x31DD
#define EGL_PIXEL_LAYOUT                0 /* placeholder */

/* EGL_EXT_image_dma_buf_import */
#define EGL_LINUX_DMA_BUF_EXT           0x3270
#define EGL_LINUX_DRM_FOURCC_EXT        0x3271
#define EGL_DMA_BUF_PLANE0_FD_EXT      0x3272
#define EGL_DMA_BUF_PLANE0_OFFSET_EXT  0x3273
#define EGL_DMA_BUF_PLANE0_PITCH_EXT   0x3274
#define EGL_DMA_BUF_PLANE1_FD_EXT      0x3275
#define EGL_DMA_BUF_PLANE1_OFFSET_EXT  0x3276
#define EGL_DMA_BUF_PLANE1_PITCH_EXT   0x3277
#define EGL_DMA_BUF_PLANE2_FD_EXT      0x3278
#define EGL_DMA_BUF_PLANE2_OFFSET_EXT  0x3279
#define EGL_DMA_BUF_PLANE2_PITCH_EXT   0x327A
/* EGL_EXT_image_dma_buf_import_modifiers */
#define EGL_DMA_BUF_PLANE0_MODIFIER_LO_EXT 0x3443
#define EGL_DMA_BUF_PLANE0_MODIFIER_HI_EXT 0x3444
#define EGL_DMA_BUF_PLANE1_MODIFIER_LO_EXT 0x3445
#define EGL_DMA_BUF_PLANE1_MODIFIER_HI_EXT 0x3446
#define EGL_DMA_BUF_PLANE2_MODIFIER_LO_EXT 0x3447
#define EGL_DMA_BUF_PLANE2_MODIFIER_HI_EXT 0x3448
#define EGL_DMA_BUF_PLANE3_FD_EXT      0x3440
#define EGL_DMA_BUF_PLANE3_OFFSET_EXT  0x3441
#define EGL_DMA_BUF_PLANE3_PITCH_EXT   0x3442
#define EGL_DMA_BUF_PLANE3_MODIFIER_LO_EXT 0x3449
#define EGL_DMA_BUF_PLANE3_MODIFIER_HI_EXT 0x344A

/* Platform / device extension tokens */
#define EGL_PLATFORM_WAYLAND_EXT        0x31D8
#define EGL_PLATFORM_WAYLAND_KHR        0x31D8
#define EGL_PLATFORM_X11_KHR           0x31D5
#define EGL_DEVICE_EXT                  0x322C
#define EGL_DRM_DEVICE_FILE_EXT         0x3233
#define EGL_DRM_RENDER_NODE_FILE_EXT    0x3377

/* EGL_KHR_gl_texture_2D_image */
#define EGL_GL_TEXTURE_2D               0x30B1
#define EGL_GL_TEXTURE_2D_KHR           0x30B1

/* EGL function stubs — all return failure/null */
static inline EGLint eglGetError(void) { return EGL_NOT_INITIALIZED; }
static inline EGLDisplay eglGetDisplay(EGLNativeDisplayType id) { (void)id; return EGL_NO_DISPLAY; }
static inline EGLDisplay eglGetPlatformDisplay(EGLenum platform, void *native, const EGLAttrib *attrs)
    { (void)platform; (void)native; (void)attrs; return EGL_NO_DISPLAY; }
static inline EGLDisplay eglGetPlatformDisplayEXT(EGLenum platform, void *native, const EGLint *attrs)
    { (void)platform; (void)native; (void)attrs; return EGL_NO_DISPLAY; }
static inline EGLBoolean eglInitialize(EGLDisplay d, EGLint *maj, EGLint *min)
    { (void)d; (void)maj; (void)min; return EGL_FALSE; }
static inline EGLBoolean eglTerminate(EGLDisplay d) { (void)d; return EGL_FALSE; }
static inline const char *eglQueryString(EGLDisplay d, EGLint name) { (void)d; (void)name; return NULL; }
static inline EGLBoolean eglChooseConfig(EGLDisplay d, const EGLint *a, EGLConfig *c, EGLint cs, EGLint *n)
    { (void)d; (void)a; (void)c; (void)cs; (void)n; return EGL_FALSE; }
static inline EGLBoolean eglGetConfigAttrib(EGLDisplay d, EGLConfig c, EGLint a, EGLint *v)
    { (void)d; (void)c; (void)a; (void)v; return EGL_FALSE; }
static inline EGLBoolean eglBindAPI(EGLenum api) { (void)api; return EGL_FALSE; }
static inline EGLenum eglQueryAPI(void) { return EGL_OPENGL_ES_API; }
static inline EGLContext eglCreateContext(EGLDisplay d, EGLConfig c, EGLContext s, const EGLint *a)
    { (void)d; (void)c; (void)s; (void)a; return EGL_NO_CONTEXT; }
static inline EGLBoolean eglDestroyContext(EGLDisplay d, EGLContext c)
    { (void)d; (void)c; return EGL_FALSE; }
static inline EGLBoolean eglMakeCurrent(EGLDisplay d, EGLSurface dr, EGLSurface rd, EGLContext c)
    { (void)d; (void)dr; (void)rd; (void)c; return EGL_FALSE; }
static inline EGLContext eglGetCurrentContext(void) { return EGL_NO_CONTEXT; }
static inline EGLDisplay eglGetCurrentDisplay(void) { return EGL_NO_DISPLAY; }
static inline EGLSurface eglGetCurrentSurface(EGLint r) { (void)r; return EGL_NO_SURFACE; }
static inline EGLSurface eglCreateWindowSurface(EGLDisplay d, EGLConfig c, EGLNativeWindowType w, const EGLint *a)
    { (void)d; (void)c; (void)w; (void)a; return EGL_NO_SURFACE; }
static inline EGLSurface eglCreatePbufferSurface(EGLDisplay d, EGLConfig c, const EGLint *a)
    { (void)d; (void)c; (void)a; return EGL_NO_SURFACE; }
static inline EGLBoolean eglDestroySurface(EGLDisplay d, EGLSurface s) { (void)d; (void)s; return EGL_FALSE; }
static inline EGLBoolean eglSwapBuffers(EGLDisplay d, EGLSurface s) { (void)d; (void)s; return EGL_FALSE; }
static inline EGLImage eglCreateImage(EGLDisplay d, EGLContext c, EGLenum t, EGLClientBuffer b, const EGLAttrib *a)
    { (void)d; (void)c; (void)t; (void)b; (void)a; return EGL_NO_IMAGE; }
static inline EGLImageKHR eglCreateImageKHR(EGLDisplay d, EGLContext c, EGLenum t, EGLClientBuffer b, const EGLint *a)
    { (void)d; (void)c; (void)t; (void)b; (void)a; return EGL_NO_IMAGE_KHR; }
static inline EGLBoolean eglDestroyImage(EGLDisplay d, EGLImage i) { (void)d; (void)i; return EGL_FALSE; }
static inline EGLBoolean eglDestroyImageKHR(EGLDisplay d, EGLImageKHR i) { (void)d; (void)i; return EGL_FALSE; }
static inline EGLSync eglCreateSync(EGLDisplay d, EGLenum t, const EGLAttrib *a)
    { (void)d; (void)t; (void)a; return EGL_NO_SYNC; }
static inline EGLSyncKHR eglCreateSyncKHR(EGLDisplay d, EGLenum t, const EGLint *a)
    { (void)d; (void)t; (void)a; return (EGLSyncKHR)0; }
static inline EGLBoolean eglDestroySync(EGLDisplay d, EGLSync s) { (void)d; (void)s; return EGL_FALSE; }
static inline EGLBoolean eglDestroySyncKHR(EGLDisplay d, EGLSyncKHR s) { (void)d; (void)s; return EGL_FALSE; }
static inline EGLint eglClientWaitSync(EGLDisplay d, EGLSync s, EGLint f, uint64_t t)
    { (void)d; (void)s; (void)f; (void)t; return EGL_FALSE; }
static inline EGLint eglClientWaitSyncKHR(EGLDisplay d, EGLSyncKHR s, EGLint f, uint64_t t)
    { (void)d; (void)s; (void)f; (void)t; return EGL_FALSE; }
static inline EGLBoolean eglWaitSync(EGLDisplay d, EGLSync s, EGLint f)
    { (void)d; (void)s; (void)f; return EGL_FALSE; }
static inline EGLBoolean eglWaitSyncKHR(EGLDisplay d, EGLSyncKHR s, EGLint f)
    { (void)d; (void)s; (void)f; return EGL_FALSE; }
static inline EGLint eglDupNativeFenceFDANDROID(EGLDisplay d, EGLSyncKHR s)
    { (void)d; (void)s; return -1; }
static inline __eglMustCastToProperFunctionPointerType eglGetProcAddress(const char *name)
    { (void)name; return 0; }
static inline EGLBoolean eglQueryDmaBufFormatsEXT(EGLDisplay d, EGLint max, EGLint *fmts, EGLint *n)
    { (void)d; (void)max; (void)fmts; (void)n; return EGL_FALSE; }
static inline EGLBoolean eglQueryDmaBufModifiersEXT(EGLDisplay d, EGLint fmt, EGLint max, uint64_t *m, EGLBoolean *e, EGLint *n)
    { (void)d; (void)fmt; (void)max; (void)m; (void)e; (void)n; return EGL_FALSE; }
static inline EGLBoolean eglQueryDisplayAttribEXT(EGLDisplay d, EGLint attr, EGLAttrib *val)
    { (void)d; (void)attr; (void)val; return EGL_FALSE; }
static inline const char *eglQueryDeviceStringEXT(EGLDeviceEXT dev, EGLint name)
    { (void)dev; (void)name; return NULL; }
static inline EGLBoolean eglExportDMABUFImageQueryMESA(EGLDisplay d, EGLImage img, int *fourcc, int *nplanes, uint64_t *modifiers)
    { (void)d; (void)img; (void)fourcc; (void)nplanes; (void)modifiers; return EGL_FALSE; }
static inline EGLBoolean eglExportDMABUFImageMESA(EGLDisplay d, EGLImage img, int *fds, int *strides, int *offsets)
    { (void)d; (void)img; (void)fds; (void)strides; (void)offsets; return EGL_FALSE; }

/* epoxy-style wrappers (libepoxy prefixes EGL functions with epoxy_) */
#define epoxy_eglGetError eglGetError
#define epoxy_eglGetDisplay eglGetDisplay
#define epoxy_eglGetPlatformDisplay eglGetPlatformDisplay
#define epoxy_eglGetPlatformDisplayEXT eglGetPlatformDisplayEXT
#define epoxy_eglInitialize eglInitialize
#define epoxy_eglTerminate eglTerminate
#define epoxy_eglQueryString eglQueryString
#define epoxy_eglChooseConfig eglChooseConfig
#define epoxy_eglGetConfigAttrib eglGetConfigAttrib
#define epoxy_eglBindAPI eglBindAPI
#define epoxy_eglCreateContext eglCreateContext
#define epoxy_eglDestroyContext eglDestroyContext
#define epoxy_eglMakeCurrent eglMakeCurrent
#define epoxy_eglGetCurrentContext eglGetCurrentContext
#define epoxy_eglGetCurrentDisplay eglGetCurrentDisplay
#define epoxy_eglGetCurrentSurface eglGetCurrentSurface
#define epoxy_eglCreateWindowSurface eglCreateWindowSurface
#define epoxy_eglCreatePbufferSurface eglCreatePbufferSurface
#define epoxy_eglDestroySurface eglDestroySurface
#define epoxy_eglSwapBuffers eglSwapBuffers
#define epoxy_eglCreateImage eglCreateImage
#define epoxy_eglCreateImageKHR eglCreateImageKHR
#define epoxy_eglDestroyImage eglDestroyImage
#define epoxy_eglDestroyImageKHR eglDestroyImageKHR
#define epoxy_eglCreateSync eglCreateSync
#define epoxy_eglCreateSyncKHR eglCreateSyncKHR
#define epoxy_eglDestroySync eglDestroySync
#define epoxy_eglDestroySyncKHR eglDestroySyncKHR
#define epoxy_eglClientWaitSync eglClientWaitSync
#define epoxy_eglClientWaitSyncKHR eglClientWaitSyncKHR
#define epoxy_eglWaitSync eglWaitSync
#define epoxy_eglWaitSyncKHR eglWaitSyncKHR
#define epoxy_eglDupNativeFenceFDANDROID eglDupNativeFenceFDANDROID
#define epoxy_eglGetProcAddress eglGetProcAddress
#define epoxy_eglQueryDmaBufFormatsEXT eglQueryDmaBufFormatsEXT
#define epoxy_eglQueryDmaBufModifiersEXT eglQueryDmaBufModifiersEXT

/* Additional type aliases used by some extension code */
#ifndef EGLAPIENTRYP
#define EGLAPIENTRYP *
#endif

typedef EGLImage (EGLAPIENTRYP PFNEGLCREATEIMAGEPROC)(EGLDisplay, EGLContext, EGLenum, EGLClientBuffer, const EGLAttrib*);
typedef EGLBoolean (EGLAPIENTRYP PFNEGLDESTROYIMAGEPROC)(EGLDisplay, EGLImage);
typedef EGLImageKHR (EGLAPIENTRYP PFNEGLCREATEIMAGEKHRPROC)(EGLDisplay, EGLContext, EGLenum, EGLClientBuffer, const EGLint*);
typedef EGLBoolean (EGLAPIENTRYP PFNEGLDESTROYIMAGEKHRPROC)(EGLDisplay, EGLImageKHR);

#ifdef __cplusplus
}
#endif
