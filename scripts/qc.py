import subprocess
import os

def run_qc(fastq, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    cmd = ["fastqc", fastq, "-o", output_dir]
    subprocess.check_call(cmd)
