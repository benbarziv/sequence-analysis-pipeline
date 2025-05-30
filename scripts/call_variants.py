import subprocess
import os

def call_variants(bam, reference, output_vcf):
    os.makedirs(os.path.dirname(output_vcf), exist_ok=True)
    cmd = ["freebayes", "-f", reference, bam]
    with open(output_vcf, "w") as out:
        subprocess.run(cmd, stdout=out, check=True)
