import os
import tempfile
from scripts.qc import run_qc

def test_run_qc(tmp_path, monkeypatch):
    # monkeypatch fastqc call to skip real execution
    def fake_call(cmd):
        out_dir = cmd[-1]
        open(os.path.join(out_dir, "dummy.html"), "w").close()
    monkeypatch.setattr("subprocess.check_call", lambda cmd: fake_call(cmd))

    fastq = tmp_path / "sample.fastq.gz"
    fastq.write_bytes(b"")  # empty file stub
    out = tmp_path / "qc_out"
    run_qc(str(fastq), str(out))
    assert (out / "dummy.html").exists()
