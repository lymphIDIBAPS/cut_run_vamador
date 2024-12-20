# We will align with BWA version 0.7.17
configfile: "./config/config.yaml"

# Define the directory containing the FASTQ files
sample_dir = config['sample_dir']

# Define the directory to store the results in
output_dir = config['output_dir']

# Define the directory to grab the genome information from
genome_dir = config['path_to_genome']

rule bwa_index:
    input: 
        genome = f"{genome_dir}/Homo_sapiens.GRCh37.dna.primary_assembly.fa"
    output:
        genome_amb = f"{genome_dir}/Homo_sapiens.GRCh37.dna.primary_assembly.fa.amb",
        genome_ann = f"{genome_dir}/Homo_sapiens.GRCh37.dna.primary_assembly.fa.ann",
        genome_bwt = f"{genome_dir}/Homo_sapiens.GRCh37.dna.primary_assembly.fa.bwt",
        genome_pac = f"{genome_dir}/Homo_sapiens.GRCh37.dna.primary_assembly.fa.pac",
        genome_sa = f"{genome_dir}/Homo_sapiens.GRCh37.dna.primary_assembly.fa.sa"
    conda:
        "../envs/bwa.yaml"
    envmodules:
        "/apps/modules/modulefiles/tools/bwa/0.7.17"
    shell:
        """
        bwa index {input.genome}
        """

rule bwa_mem:
    input:
        fq = "results/trimmed/{sample}_trimmed.fastq.gz",
        genome_amb = f"{genome_dir}/Homo_sapiens.GRCh37.dna.primary_assembly.fa.amb"
    output:
        bam = "results/mapped/{sample}.bam"
    conda:
        "../envs/bwa.yaml"
    log:
        "logs/bwa_mem/{sample}.log"
    envmodules:
        "/apps/modules/modulefiles/tools/bwa/0.7.17"
    params:
        extra = r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sorting = "none",  # Can be 'none', 'samtools' or 'picard'.
        sort_order = "queryname",  # Can be 'queryname' or 'coordinate'.
        sort_extra = ""  # Extra args for samtools/pic
    shell:
        """
        bwa mem -t {snakemake.threads} {extra} {index} {snakemake.input.reads} | + pipe_cmd {log}
        """