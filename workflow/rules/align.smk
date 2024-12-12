# We will align with BWA version 0.7.17
configfile: "./config/config.yaml"

# Define the directory containing the FASTQ files
sample_dir = config['sample_dir']

# Define the directory to store the results in
output_dir = config['output_dir']

rule align:
    input:
        fq="results/trimmed/{sample}_trimmed.fastq.gz",
        genome=config["genome"]
    output:
        bam="results/aligned/{sample}.bam"
    conda:
        "../envs/bwa.yaml"
    log:
        "logs/align/{sample}.log"
    shell:
        "bowtie2 -x {input.genome} -U {input.fq} | samtools view -b > {output.bam} 2> {log}"