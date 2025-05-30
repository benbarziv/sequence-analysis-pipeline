from setuptools import setup, find_packages

setup(
    name="sequence_analysis_pipeline",
    version="0.1.0",
    packages=find_packages(where="scripts"),
    package_dir={"": "scripts"},
    install_requires=[
        "snakemake",
        "biopython",
        "PyYAML",
        "pytest",
        "pandas",
    ],
)
