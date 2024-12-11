configfile: "./config/config.yaml"

# Define the directory containing the FASTQ files
sample_dir = config['sample_dir']

# Define the directory to store the results in
output_dir = config['output_dir']

# Define the sample extension
extension = config['extension']

# Define patterns to match specific files
samples = glob_wildcards(f"{sample_dir}/{{sample}}{extension}.fastq.gz").sample

rule fastqc_not_merged:
    input:
        fq1_1=f"{sample_dir}/{{sample}}_1_1.fastq.gz",
        fq1_2=f"{sample_dir}/{{sample}}_1_2.fastq.gz",
        fq2_1=f"{sample_dir}/{{sample}}_2_1.fastq.gz",
        fq2_2=f"{sample_dir}/{{sample}}_2_2.fastq.gz",
    output:
        report1_1=f"{output_dir}/fastqc/{{sample}}_1_1_fastqc.html"
    conda:
        "../envs/fastqc.yaml"
    log:
        log = "logs/fastqc/{sample}.log",
    envmodules:
        "/apps/modules/modulefiles/tools/java/12.0.2"
        "/apps/modules/modulefiles/tools/fastqc/0.11.9"
    params:
        output_dir = output_dir,
        log_dir = "logs/fastqc",
        threads = 10
    shell:
        """
        mkdir -p {params.output_dir}/fastqc {params.log_dir}
        fastqc {input} -o {params.output_dir}/fastqc > {log.log} 2>&1
        """


rule fastqc_merged:
    input:
        fqF=f"{sample_dir}/{{sample}}_mergedF.fastq.gz",
        fqR=f"{sample_dir}/{{sample}}_mergedR.fastq.gz"
    output:
        reportF=f"{output_dir}/fastqc/{{sample}}_mergedF_fastqc.html",
        reportR=f"{output_dir}/fastqc/{{sample}}_mergedR_fastqc.html"
    conda:
        "../envs/fastqc.yaml"
    log:
        logF = "logs/fastqc/{sample}_F.log",
        logR = "logs/fastqc/{sample}_R.log",
    envmodules:
        "/apps/modules/modulefiles/tools/java/12.0.2"
        "/apps/modules/modulefiles/tools/fastqc/0.11.9"
    params:
        output_dir = output_dir,
        log_dir = "logs/fastqc",
        threads = 10
    shell:
        """
        mkdir -p {params.output_dir}/fastqc {params.log_dir}
        fastqc {input.fqF} -o {params.output_dir}/fastqc > {log.logF} 2>&1
        fastqc {input.fqR} -o {params.output_dir}/fastqc > {log.logR} 2>&1
        """