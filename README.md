# Sequence Analysis Pipeline

[![CI](https://github.com/benbarziv/sequence_analysis_pipeline/actions/workflows/ci.yml/badge.svg)](https://github.com/benbarziv/sequence_analysis_pipeline/actions/workflows/ci.yml)  
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end Snakemake workflow for DNA/RNA sequence analysis, from raw FASTQ to variant calls. This pipeline handles:

- **Automated index building** (Bowtie 2)  
- **Quality control** (FastQC)  
- **Adapter & quality trimming** (Cutadapt)  
- **Read alignment** (Bowtie 2 → SAM/BAM)  
- **BAM sorting & indexing** (SAMtools)  
- **Variant calling** (FreeBayes)  

---

## 📋 Table of Contents

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

## ✨ Features

- **Reproducible**: single command to run entire pipeline  
- **Modular**: each step defined as a Snakemake rule  
- **Configurable**: sample list & reference path in `config/config.yaml`  
- **Portable**: uses Python virtualenv & Homebrew-installed bio-tools  
- **Tested**: unit tests for core functionality (pytest)  
- **CI-ready**: GitHub Actions workflow for automated testing  

---

## 📂 Project Structure

```
sequence_analysis_pipeline/
├── config/
│   └── config.yaml         # sample list & reference FASTA
├── data/
│   ├── sample1.fastq.gz    # drop your FASTQ(s) here
│   └── reference/
│       └── genome.fa       # reference genome
├── results/                # pipeline outputs
│   ├── qc/
│   ├── trim/
│   ├── align/
│   └── variants/
├── scripts/                # Python wrappers (optional)
├── tests/                  # pytest tests
├── Snakefile               # workflow definition
├── requirements.txt        # pip dependencies
├── environment.yml         # Conda environment (optional)
├── .github/
│   └── workflows/ci.yml    # CI pipeline
└── README.md               # you are here!
```

---

## ⚙️ Prerequisites

- **macOS** (or Linux)  
- **Homebrew**  
  ```bash
  brew update
  brew install bowtie2 samtools fastqc freebayes cutadapt snakemake graphviz
  ```
- **Python 3.9+**  
- **Git**  

---

## 🚀 Installation

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
3. **(Optional) Conda**  
   ```bash
   conda env create -f environment.yml
   conda activate seq_pipeline
   ```

---

## 🛠️ Configuration

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

## ▶️ Usage

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

## 📊 Results

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

## ✅ Testing

Run unit tests:

```bash
pytest -q
```

Tests stub subprocess calls and verify outputs.

---

## 🤖 Continuous Integration

GitHub Actions at `.github/workflows/ci.yml` runs:

- `pytest -q`  
- `snakemake -n`  

Include the badge at the top to show build status.

---

## 🤝 Contributing

1. Fork & clone  
2. Create a branch (`git checkout -b feature/foo`)  
3. Commit (`git commit -am 'Add foo'`)  
4. Push & PR  

Please add tests for new functionality.

---

## 📄 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE).
