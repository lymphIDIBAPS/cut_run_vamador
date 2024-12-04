configfile: "./config/config.yaml"

# Define the directory containing the FASTQ files
sample_dir = config['sample_dir']

# Define the directory to store the results in
output_dir = config['output_dir']

# Define the sample extension
extension = config['extension']

# Define patterns to match specific files
samples = glob_wildcards(f"{sample_dir}/{{sample}}{extension}.fastq.gz").sample


rule fastqc:
    input:
        fqF=f"{sample_dir}/{{sample}}_mergedF.fastq.gz",
        fqR=f"{sample_dir}/{{sample}}_mergedR.fastq.gz"
    output:
        reportF=f"{output_dir}/fastqc/{{sample}}_F_fastqc.html",
        reportR=f"{output_dir}/fastqc/{{sample}}_R_fastqc.html"
    log:
        "logs/fastqc/{sample}.log"
    params:
        output_dir = output_dir,
        log_dir = "logs/fastqc"
    shell:
        """
        mkdir -p {params.output_dir}/fastqc {params.log_dir}
        fastqc {input.fqF} -o {params.output_dir}/fastqc > {log} 2>&1
        fastqc {input.fqR} -o {params.output_dir}/fastqc > {log} 2>&1
        """