# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Hassan Foroughi Asl"

rule samtools_sort:
  input: "{sample}.bam"
  output: "{sample}.sorted.bam"
  log: "logs/samtools/{sample}.sort.log"
  message: "Running samtools_sort on {{sample}}.bam"
  params: ""
  threads: 4
  wrapper: "0.27.1/bio/samtools/sort"

rule samtools_index:
  input: "{sample}.sorted.bam"
  output: "{sample}.sorted.bam.bai"
  log: "logs/samtools/{sample}.index.log"
  message: "Running samtools_index on {{sample}}.sorted.bam"
  params: ""
  threads: 4
  wrapper: "0.27.1/bio/samtools/index"

rule samtools_stats:
  input: "{sample}.sorted.bam"
  output: "{sample}.sorted.bam.stats"
  log: "logs/samtools/{sample}.stats.log"
  message: "Running samtools_stats on {{sample}}.sorted.bam"
  params: ""
  threads: 4
  wrapper: "0.27.1/bio/samtools/stats"
