# Sequence Analysis Pipeline

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end Snakemake workflow for DNA/RNA sequence analysis, from raw FASTQ to variant calls. This pipeline handles:

- **Automated index building** (Bowtie 2)  
- **Quality control** (FastQC)  
- **Adapter & quality trimming** (Cutadapt)  
- **Read alignment** (Bowtie 2 -> SAM/BAM)  
- **BAM sorting & indexing** (SAMtools)  
- **Variant calling** (FreeBayes)  

---

## Table of Contents

1. [Features](#features)  
2. [Project Structure](#project-structure)  
3. [Prerequisites](#prerequisites)  
4. [Installation](#installation)  
5. [Configuration](#configuration)  
6. [Usage](#usage)  
7. [Results](#results)  
8. [Testing](#testing)  
9. [Continuous Integration](#continuous-integration)  
10. [Contributing](#contributing)  
11. [License](#license)  


---

## Installation

1. **Clone**  
   ```bash
   git clone https://github.com/benbarziv/sequence_analysis_pipeline.git
   cd sequence_analysis_pipeline
   ```
2. **Python venv**  
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install --upgrade pip
   pip install -r requirements.txt
   ```
---

## Configuration

Edit `config/config.yaml`:

```yaml
samples:
  - sample1
  - sample2    # one per FASTQ basename

reference: "data/reference/genome.fa"
```

- Place your compressed FASTQ(s) in `data/` named `<sample>.fastq.gz`.  
- Put your uncompressed FASTA in `data/reference/`.  

---

## Usage

Run the full pipeline:

```bash
snakemake --cores 4
```

- **Dry-run**:  
  ```bash
  snakemake -n
  ```
- **Visualize DAG**:  
  ```bash
  snakemake --dag | dot -Tpng > workflow.png
  open workflow.png
  ```

---

## Results

Outputs live under `results/`:

- `qc/` — FastQC reports (`*.html`, `*.zip`)  
- `trim/` — trimmed FASTQs  
- `align/` — SAM/BAM files  
- `variants/` — VCF files  

Quick checks:

```bash
# QC
open results/qc/sample1_fastqc.html

# Alignment stats
samtools flagstat results/align/sample1_sorted.bam

# Variant count
grep -v '^#' results/variants/sample1.vcf | wc -l
```

---

## Testing

Run unit tests:

```bash
pytest -q
```

Tests stub subprocess calls and verify outputs.

---

## Continuous Integration

GitHub Actions at `.github/workflows/ci.yml` runs:

- `pytest -q`  
- `snakemake -n`  

Include the badge at the top to show build status.

---


## License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE).
