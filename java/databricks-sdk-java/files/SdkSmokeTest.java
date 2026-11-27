import com.databricks.sdk.WorkspaceClient;
import com.databricks.sdk.core.DatabricksConfig;
import com.databricks.sdk.service.compute.ClusterDetails;
import com.fasterxml.jackson.databind.ObjectMapper;

// Offline check that the SDK and its bundled dependencies load and work
// together: build a client from a config (no network call), and round-trip
// an SDK model through Jackson.
public class SdkSmokeTest {
    public static void main(String[] args) throws Exception {
        DatabricksConfig config = new DatabricksConfig()
            .setHost("https://example.cloud.databricks.com")
            .setToken("dapi-smoke-test");
        WorkspaceClient client = new WorkspaceClient(config);
        if (client.clusters() == null) {
            throw new AssertionError("no clusters API");
        }
        ObjectMapper mapper = new ObjectMapper();
        ClusterDetails in = new ClusterDetails().setClusterName("smoke").setNumWorkers(2L);
        String json = mapper.writeValueAsString(in);
        ClusterDetails out = mapper.readValue(json, ClusterDetails.class);
        if (!"smoke".equals(out.getClusterName()) || out.getNumWorkers() != 2L) {
            throw new AssertionError("round trip: " + json);
        }
        System.out.println("databricks-sdk-java smoke test OK: client for "
            + client.config().getHost() + ", cluster_name " + out.getClusterName());
    }
}
