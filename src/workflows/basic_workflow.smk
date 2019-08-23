from os import path

wildcard_constraints:
    sample="^[A-Za-z0-9-]+$",
    read="^[R12]+$",
    part="^[A-Za-z0-9]+$"

trimmomatic_input_r1=lambda wildcards: units.loc[(path.split(wildcards.sample)[-1], wildcards.part), ['fq1']].dropna()[0]
trimmomatic_input_r2=lambda wildcards: units.loc[(path.split(wildcards.sample)[-1], wildcards.part), ['fq2']].dropna()[0]
include: "../rules/fastq/trimmomatic/trimmomatic.smk"

bwa_mem_input=[rules.trimmomatic.output.r1, rules.trimmomatic.output.r2]
include: "../rules/align/bwa_mem/bwa_mem.smk"

samtools_index_input = rules.bwa_mem.output[0]
include: "../rules/align/samtools/index/samtools_index.smk"

samtools_stats_input = rules.bwa_mem.output[0]
include: "../rules/align/samtools/stats/samtools_stats.smk"
