from os import path

wildcard_constraints:
    sample="[A-Za-z0-9]+",
    read="[R12]+",
    part="[A-Za-z0-9]+"

extract_umis_read_head_input=lambda wildcards: units.loc[(path.split(wildcards.sample)[-1], wildcards.part), ['fq1' if wildcards.read == "R1" else "fq2"]].dropna()[0]
include: "../rules/umis/extract_umis_read_head/extract_umis_read_head.smk"

include: "../rules/umis/combine_fastq_files/combine_fastq_files.smk"

headcrop_fastq_input=lambda wildcards: units.loc[(path.split(wildcards.sample)[-1], wildcards.part), ['fq1' if wildcards.read == "R1" else "fq2"]].dropna()[0]
include: "../rules/fastq/headcrop/headcrop_fastq.smk"

trimmomatic_input_r1="fastq/{sample}.{part}.R1.headcrop%s.fastq.gz" % config['headcrop_num_bases']
trimmomatic_input_r2="fastq/{sample}.{part}.R2.headcrop%s.fastq.gz" % config['headcrop_num_bases']
include: "../rules/fastq/trimmomatic/trimmomatic.smk"

bwa_mem_input=[rules.trimmomatic.output.r1, rules.trimmomatic.output.r2]
include: "../rules/align/bwa_mem/bwa_mem.smk"

annotate_bam_with_umi_input_bam: rules.bwa_mem.output[0]
annotate_bam_with_umi_input_umi: rules.combine_fastq_files.output[0]
include: "../rules/umis/annotate_bam_with_umi/annotate_bam_with_umi.smk"

collapse_reads_input=rules.annotate_bam_with_umi.output[0]
include: "../rules/umis/collapse_reads/collapse_reads.smk"

samtools_index_output = "alignment/{sample}.{part,[A-Za-z0-9]+|[A-Za-z0-9]+[.][A-Za-z0-9]+}.bai"
include: "../rules/align/samtools/index/samtools_index.smk"

samtools_stats_output = "alignment/{sample}.{part,[A-Za-z0-9]+|[A-Za-z0-9]+[.][A-Za-z0-9]+}.stats"
include: "../rules/align/samtools/stats/samtools_stats.smk"

#fastq_from_bam_input=rules.collapse_reads.output[0]
#fastq_from_bam_output_fq1=temp("fastq/{sample}.{part}.collapsed{num_support,\d+}.fq1")
#fastq_from_bam_output_fq2=temp("fastq/{sample}.{part}.collapsed{num_support,\d+}.fq2")
#include: "../rules/fastq/fastq_from_bam/fastq_from_bam.smk"
