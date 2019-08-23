# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__="Patrik Smeds"
__copyright__ = "Copyright 2019, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"


_collapse_reads_input = "alignment/{sample}.{part}.sorted.bam"
try:
    _collapse_reads_input = collapse_reads_input
except:
    pass

_collapse_reads_output = "alignment/{sample}.{part}.collapsed{num_support,\d+}.bam"
try:
    _collapse_reads_output = collapse_reads_output
except:
    pass

rule pre_collapse_reads_prep_revertsam_umi:
    input:
        _collapse_reads_input
    output:
        temp("alignment/.{sample}.{part}.sanitised.bam")
    params:
        extra="SANITIZE=true REMOVE_DUPLICATE_INFORMATION=false REMOVE_ALIGNMENT_INFORMATION=false SORT_ORDER=queryname"
    wrapper:
        "0.31.1/bio/picard/revertsam"

rule pre_collapse_prep_set_mate_info_umi:
    input:
        bam="alignment/.{sample}.{part}.sanitised.bam"
    output:
        bam=temp("alignment/.{sample}.{part}.sanitised.setmateinfo.bam")
    log:
        "logs/umis_collapse/{sample}.{part}.fgbioSetMQInfo.txt"
    wrapper:
        "0.31.1/bio/fgbio/setmateinformation"

rule pre_collapse_prep_groupreads_by_umi:
    input:
        "alignment/.{sample}.{part}.sanitised.setmateinfo.bam"
    output:
        temp("alignment/.{sample}.{part}.sanitised.setmateinfo.groupreads.bam")
    log:
        "logs/umis_collapse/{sample}.{part}.merged.fgbioGroup.txt"
    params:
        extra="-s adjacency --edits 1 -Xms500m -Xmx64g"
    wrapper:
        "0.31.1/bio/fgbio/groupreadsbyumi"

rule collapse_reads_umi:
    input:
        "alignment/.{sample}.{part}.sanitised.setmateinfo.groupreads.bam"
    output:
        temp("alignment/{sample}.{part}.consensus{num_support,\d+}.bam")
    log:
       "logs/umis_collapse/{sample}.{part}.merged.fgbioCMCR-{num_support}.txt"
    params:
        extra=lambda wildcards: "-M " + wildcards.num_support
    wrapper:
        "0.31.1/bio/fgbio/callmolecularconsensusreads"

rule fastq_from_bam_umi:
    input:
        "alignment/{sample}.{part}.consensus{num_support,\d+}.bam"
    output:
        fastq1=temp("fastq/{sample}.{part}.consensus{num_support,\d+}.R1.fastq"),
        fastq2=temp("fastq/{sample}.{part}.consensus{num_support,\d+}.R2.fastq")
    wrapper:
        "0.31.1/bio/picard/samtofastq"

rule bwa_mem_collapsed_reads:
    input:
        reads=["fastq/{sample}.{part}.consensus{num_support,\d+}.R1.fastq", "fastq/{sample}.{part}.consensus{num_support,\d+}.R2.fastq"]
    output:
        _collapse_reads_output
    log:
        "logs/bwa_mem/{sample}.{part}.collapsed{num_support,\d+}.log"
    benchmark:
        "benchmark/bwa_mem/{sample}.{part}.collapsed{num_support,\d+}.tsv"
    threads: 16
    params:
        index=config['reference_genome'],
        extra=lambda wildcards: r"-M -R " + _rg_information_function(wildcards) + " " + config.get("bwa_extra_settings", ""),
        sort="samtools",
        sort_order="coordinate",
        sort_extra="-@ 8"
    wrapper:
        "0.35.1/bio/bwa/mem"
