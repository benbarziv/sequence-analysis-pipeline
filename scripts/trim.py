import subprocess
import os

def trim_reads(fastq, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    cmd = ["trim_galore", "--gzip", "-o", output_dir, fastq]
    subprocess.check_call(cmd)
