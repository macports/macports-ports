# Exercises the native halves of coremltools, which a pure-Python install lacks.
import os
import sys
import tempfile

import numpy as np

import coremltools as ct
import coremltools.libcoremlpython
import coremltools.libmilstoragepython
import coremltools.libmodelpackage
from coremltools._deps.kmeans1d import cluster
from coremltools.converters.mil import Builder as mb

clusters = cluster([4.0, 4.1, 1.0, 1.1, 9.0], 2)
assert len(clusters.centroids) == 2, clusters

# Weights this size are written to the model's blob file by libmilstoragepython.
weights = np.arange(64 * 64, dtype=np.float32).reshape(64, 64) / 4096.0


@mb.program(input_specs=[mb.TensorSpec(shape=(1, 64))])
def prog(x):
    return mb.matmul(x=x, y=weights, name="y")


with tempfile.TemporaryDirectory() as tmp:
    path = os.path.join(tmp, "smoke.mlpackage")
    model = ct.convert(prog, convert_to="mlprogram",
                       compute_precision=ct.precision.FLOAT32,
                       skip_model_load=True)
    model.save(path)
    blobs = [f for _, _, files in os.walk(path) for f in files if f.endswith(".bin")]
    assert blobs, "no weight blob written"

    loaded = ct.models.MLModel(path, compute_units=ct.ComputeUnit.CPU_ONLY)
    x = np.ones((1, 64), dtype=np.float32)
    y = loaded.predict({"x": x})["y"]
    assert np.allclose(y, x @ weights, rtol=1e-4), y

print("coremltools", ct.__version__, "smoke test passed on Python", sys.version.split()[0])
