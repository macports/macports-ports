#include <grpc/grpc.h>
int main() {
    grpc_init();
    grpc_shutdown();
    return GRPC_STATUS_OK;
}
