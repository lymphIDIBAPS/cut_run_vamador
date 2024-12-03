configfile: "./config/config.yaml"

# Define the directory containing the FASTQ files
sample_dir = config["sample_dir"]

## merge_technical_replicates: merge data from L1_F and L2_F

if config["technical_duplicates"] == "yes":
    rule merge_technical_replicates:
        input:
            L1_F = "{sample_dir}/{sample}_1_1.fastq.gz",
            L2_F = "{sample_dir}/{sample}_2_1.fastq.gz",
            L1_R = "{sample_dir}/{sample}_1_2.fastq.gz",
            L2_R = "{sample_dir}/{sample}_2_2.fastq.gz",
        output:
            merged_F = "{sample_dir}/{sample}_mergedF.fastq.gz",
            merged_R = "{sample_dir}/{sample}_mergedR.fastq.gz",
        params:
            sample_dir = sample_dir
        shell:
            """
            mkdir -p {sample_dir}
            cat {input.L1_F} {input.L2_F} > {output.merged_F}
            cat {input.L1_R} {input.L2_R} > {output.merged_R}
            """