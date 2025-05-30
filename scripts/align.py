import subprocess
import os

def align_reads(fastq, reference, output_sam):
    os.makedirs(os.path.dirname(output_sam), exist_ok=True)
    cmd = ["bowtie2", "-x", reference, "-U", fastq, "-S", output_sam]
    subprocess.check_call(cmd)
