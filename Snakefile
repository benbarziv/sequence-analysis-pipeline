# Snakefile

import os
from snakemake.io import expand

configfile: "config/config.yaml"

# List of samples and reference FASTA
SAMPLES = config["samples"]
REF     = config["reference"]

# Strip “.fa” (or “.fasta”) to get the index prefix
PREFIX, ext = os.path.splitext(REF)
INDEX_FILES = [f"{PREFIX}.{i}.bt2" for i in (1, 2, 3, 4)]

rule all:
    input:
        # 1) the Bowtie2 index files
        INDEX_FILES,
        # 2) FastQC reports
        expand("results/qc/{sample}_fastqc.html", sample=SAMPLES),
        # 3) Final VCFs
        expand("results/variants/{sample}.vcf", sample=SAMPLES)

rule build_index:
    """
    Build Bowtie2 index from the reference FASTA.
    Produces PREFIX.1.bt2 through PREFIX.4.bt2
    """
    input:
        fa = REF
    output:
        INDEX_FILES
    threads: 4
    shell:
        "bowtie2-build {input.fa} {PREFIX}"

rule fastqc:
    input:
        "data/{sample}.fastq.gz"
    output:
        html="results/qc/{sample}_fastqc.html",
        zip ="results/qc/{sample}_fastqc.zip"
    shell:
        "fastqc {input} -o results/qc"

rule trim:
    """
    Trim adapters/low‐quality bases with Cutadapt.
    """
    input:
        "data/{sample}.fastq.gz"
    output:
        "results/trim/{sample}_trimmed.fastq.gz"
    shell:
        "cutadapt -q 20 -o {output} {input}"



rule align:
    input:
        reads="results/trim/{sample}_trimmed.fastq.gz",
        # depend on the index files so they’re built first
        idx=INDEX_FILES
    output:
        "results/align/{sample}.sam"
    threads: 4
    params:
        prefix=PREFIX
    shell:
        "bowtie2 -x {params.prefix} -U {input.reads} -S {output}"

rule index_fasta:
    input:
        fa = REF
    output:
        fai = REF + ".fai"
    shell:
        "samtools faidx {input.fa}"


rule sam_to_bam:
    input:
        "results/align/{sample}.sam"
    output:
        "results/align/{sample}.bam"
    shell:
        "samtools view -Sb {input} > {output}"

rule sort_bam:
    input:
        "results/align/{sample}.bam"
    output:
        "results/align/{sample}_sorted.bam"
    shell:
        "samtools sort {input} -o {output}"

rule call_variants:
    input:
        bam = "results/align/{sample}_sorted.bam",
        ref = REF,
        fai = REF + ".fai"
    output:
        "results/variants/{sample}.vcf"
    shell:
        "freebayes -f {input.ref} {input.bam} > {output}"
