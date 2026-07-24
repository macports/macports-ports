import open3d as o3d
import numpy as np

def create_unicorn_mermaid_point_cloud():
    """
    Creates a stylized unicorn mermaid point cloud with:
    - Horse/unicorn head and upper body
    - Horn
    - Mermaid tail
    - Colorful gradient
    """
    points = []
    colors = []

    # 1. Create the head (ellipsoid)
    for i in range(2000):
        theta = np.random.uniform(0, 2 * np.pi)
        phi = np.random.uniform(0, np.pi)
        r = np.random.uniform(0.8, 1.0)

        x = 0.6 * r * np.sin(phi) * np.cos(theta)
        y = 0.5 * r * np.sin(phi) * np.sin(theta) + 2.0
        z = 0.7 * r * np.cos(phi)

        points.append([x, y, z])
        colors.append([0.9, 0.7, 0.8])  # Pink-ish color

    # 2. Create the snout
    for i in range(800):
        t = np.random.uniform(0, 1)
        theta = np.random.uniform(0, 2 * np.pi)
        r = 0.3 * (1 - t * 0.5)

        x = r * np.cos(theta)
        y = 1.5 + t * 0.5
        z = 0.8 + t * 0.4

        points.append([x, y, z])
        colors.append([0.95, 0.8, 0.85])

    # 3. Create the horn (spiral)
    for i in range(1500):
        t = i / 1500.0
        theta = t * 8 * np.pi
        r = 0.15 * (1 - t)

        x = r * np.cos(theta)
        y = 2.5 + t * 1.5
        z = -0.3 + r * np.sin(theta)

        points.append([x, y, z])
        # Rainbow gradient for horn
        colors.append([1.0 - t, 0.5 + t * 0.5, t])

    # 4. Create the neck and upper body
    for i in range(2500):
        t = np.random.uniform(0, 1)
        theta = np.random.uniform(0, 2 * np.pi)
        r = 0.4 + t * 0.2

        x = r * np.cos(theta)
        y = 1.5 - t * 1.5
        z = r * np.sin(theta)

        points.append([x, y, z])
        colors.append([0.85, 0.65 + t * 0.2, 0.75])

    # 5. Create the mermaid tail (fish-like)
    for i in range(3000):
        t = np.random.uniform(0, 1)
        theta = np.random.uniform(0, 2 * np.pi)

        # Tail gets wider then narrows
        r = 0.5 * np.sin(t * np.pi) * (1 + 0.3 * np.cos(theta))

        x = r * np.cos(theta)
        y = -t * 3.0
        z = r * np.sin(theta)

        points.append([x, y, z])
        # Gradient from pink to blue/green (mermaid scales)
        colors.append([0.3 + t * 0.4, 0.6 + t * 0.3, 0.7 + t * 0.2])

    # 6. Create tail fins
    for i in range(1500):
        t = np.random.uniform(0, 1)
        side = np.random.choice([-1, 1])

        x = side * (0.5 + t * 0.8)
        y = -3.0 - t * 0.5
        z = np.random.uniform(-0.3, 0.3)

        points.append([x, y, z])
        colors.append([0.2, 0.7, 0.8])  # Turquoise fins

    # 7. Add sparkles/magic particles
    for i in range(500):
        x = np.random.uniform(-2, 2)
        y = np.random.uniform(-3, 4)
        z = np.random.uniform(-2, 2)

        points.append([x, y, z])
        colors.append([1.0, 1.0, 0.8])  # Golden sparkles

    # Create Open3D point cloud
    pcd = o3d.geometry.PointCloud()
    pcd.points = o3d.utility.Vector3dVector(np.array(points))
    pcd.colors = o3d.utility.Vector3dVector(np.array(colors))

    return pcd

def main():
    # Create the unicorn mermaid point cloud
    print("Creating unicorn mermaid point cloud...")
    unicorn_mermaid = create_unicorn_mermaid_point_cloud()

    # Estimate normals for better visualization
    unicorn_mermaid.estimate_normals(
        search_param=o3d.geometry.KDTreeSearchParamHybrid(radius=0.1, max_nn=30)
    )

    # Optional: Apply statistical outlier removal for cleaner visualization
    unicorn_mermaid, ind = unicorn_mermaid.remove_statistical_outlier(
        nb_neighbors=20, std_ratio=2.0
    )

    print(f"Point cloud has {len(unicorn_mermaid.points)} points")

    # Visualize
    print("Launching visualization...")
    o3d.visualization.draw_geometries(
        [unicorn_mermaid],
        window_name="Unicorn Mermaid Point Cloud",
        width=1024,
        height=768,
        left=50,
        top=50,
        point_show_normal=False
    )

    # Optional: Save the point cloud
    if False:
        o3d.io.write_point_cloud("unicorn_mermaid.ply", unicorn_mermaid)
        print("Point cloud saved as 'unicorn_mermaid.ply'")

if __name__ == "__main__":
    main()
