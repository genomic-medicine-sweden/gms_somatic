# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

"""
Require a config.yaml containing the following data, or a config dict with the
corresponding data
...............................................................................
config.yaml
---
trimmomatic:
  trimmer:
    - "option1"
    - "option2"
  extra_settings: "ILLUMINACLIP:TruSeq3-PE.fa:2:30:10"
...............................................................................
trimmer is required and must be a list
extra_settings are optional
"""

_trimmomatic_input_r1 = "fastq/{sample}.{part}.R1.fastq.gz"
try:
    _trimmomatic_input_r1 = trimmomatic_input_r1
except:
    pass

_trimmomatic_input_r2 = "fastq/{sample}.{part}.R2.fastq.gz"
try:
    _trimmomatic_input_r2 = trimmomatic_input_r2
except:
    pass

_trimmomatic_output_r1 = "trimmed/{sample}.{part}.R1.trimmomatic.fastq.gz"
try:
    _trimmomatic_output_r1 = trimmomatic_output_r1
except:
    pass

_trimmomatic_output_r2 = "trimmed/{sample}.{part}.R2.trimmomatic.fastq.gz"
try:
    _trimmomatic_output_r2 = trimmomatic_output_r2
except:
    pass

_trimmomatic_output_r1_unpaired = "trimmed/{sample}.{part}.R1.trimmomatic.unpaired.fastq.gz"
try:
    _trimmomatic_output_r1_unpaired = trimmomatic_output_r1_unpaired
except:
    pass

_trimmomatic_output_r2_unpaired = "trimmed/{sample}.{part}.R2.trimmomatic.unpaired.fastq.gz"
try:
    _trimmomatic_output_r2_unpaired = trimmomatic_output_r2_unpaired
except:
    pass

_cutadapt_fastq2_output = "trimmed/{sample}.{part}.R2.cutadapt.fastq.gz"
try:
    _cutadapt_fastq2_output = cutadapt_fastq2_output
except:
    pass

_trimmomatic_log_output = "logs/trimmed/{sample}.{part}.trimmoamtic.txt"
try:
    _trimmomatic_log_output = trimmomatic_log_output
except:
    pass

rule trimmomatic:
    input:
        r1=_trimmomatic_input_r1,
        r2=_trimmomatic_input_r2
    output:
        r1=_trimmomatic_output_r1,
        r2=_trimmomatic_output_r2,
        # reads where trimming entirely removed the mate
        r1_unpaired=temp(_trimmomatic_output_r1_unpaired),
        r2_unpaired=temp(_trimmomatic_output_r2_unpaired)
    log:
        _trimmomatic_log_output
    params:
        trimmer=config["trimmomatic"]["trimmer"],
        extra=config["trimmomatic"].get("extra_settings", ""),
        compression_level="-9"
    threads: 8
    wrapper:
        "0.35.1/bio/trimmomatic/pe"
