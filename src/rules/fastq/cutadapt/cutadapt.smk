# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

"""
Require a config.yaml containing the following data, or a config dict with the
corresponding data
...............................................................................
config.yaml
---
cutadapt:
  params: " ... "
...............................................................................
"""

_cutadapt_input = ["fastq/{sample}.{part}.R1.fastq.gz", "fastq/{sample}.{part}.R2.fastq.gz"]
try:
    _cutadapt_input = cutadapt_input
except:
    pass

_cutadapt_fastq1_output = "trimmed/{sample}.{part}.R1.cutadapt.fastq.gz"
try:
    _cutadapt_fastq1_output = cutadapt_fastq1_output
except:
    pass

_cutadapt_fastq2_output = "trimmed/{sample}.{part}.R2.cutadapt.fastq.gz"
try:
    _cutadapt_fastq2_output = cutadapt_fastq2_output
except:
    pass

_cutadapt_log_output = "logs/trimmed/{sample}.{part}.cutadapt.txt"
try:
    _cutadapt_log_output = cutadapt_log_output
except:
    pass

rule cutadapt:
  input:
      _cutadapt_input
  output:
      fastq1=_cutadapt_fastq1_output,
      fastq2=_cutadapt_fastq2_output,
      qc = _cutadapt_log_output
  threads: 1
  params: config["cutadapt"].get("params","")
  wrapper:
      "0.35.1/bio/cutadapt/pe"
