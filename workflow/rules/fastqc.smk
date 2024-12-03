configfile: "./config/config.yaml"

# Define the directory containing the FASTQ files
sample_dir = config["sample_dir"]

# Define patterns to match specific files
samples = glob_wildcards(f"{sample_dir}/{{sample}}_mergedF.fastq.gz").sample

rule fastqc:
    input:
        fq=f"{sample_dir}/{{sample}}.fastq.gz"
    output:
        report="results/qc/{sample}_fastqc.html"
    log:
        "logs/fastqc/{sample}.log"
    shell:
        "fastqc {input.fq} -o results/qc > {log} 2>&1"