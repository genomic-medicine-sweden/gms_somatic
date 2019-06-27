# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Hassan Foroughi Asl"

rule samtools_index:
  input: "{sample}.bam"
  output: "{sample}.bam.bai"
  log: "logs/samtools/{sample}.log"
  message: "Running samtools_index on {{sample}}.bam"
  params: ""
  threads: 4
  wrapper: "0.27.1/bio/samtools/index"
