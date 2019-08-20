# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__="Patrik Smeds"
__copyright__ = "Copyright 2019, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

"""
Require a config.yaml containing the following data, or a config dict with the
corresponding data.
...............................................................................
config.yaml
---
reference_genome: /path/genome

bwa_mem:
 extra_settings: " ... "
...............................................................................

...............................................................................
samples.tsv
---
sample    platform
sample1    NextSeq
...............................................................................
"""

def get_now():
    from datetime import datetime
    return datetime.now().strftime('%Y%m%d')

_bwa_mem_input = ["fastq/{sample}.{part}.R1.fastq.gz", "fastq/{sample}.{part}.R2.fastq.gz"]
try:
    _bwa_mem_input = bwa_mem_input
except:
    pass

_bwa_mem_output = "alignment/{sample}.{part}.bam"
try:
    _bwa_mem_output = bwa_mem_output
except:
    pass

_bwa_mem_log = "logs/bwa_mem/{sample}.{part}.log"
try:
    _bwa_mem_log = bwa_mem_log
except:
    pass

_bwa_mem_benchmark = "benchmark/bwa_mem/{sample}.{part}.tsv"
try:
    _bwa_mem_benchmark = bwa_mem_benchmark
except:
    pass

_rg_information_function = lambda wildcards: "'@RG\tID:%s_%s\tSM:%s\tPL:%s'" % (get_now(),wildcards.sample + "_" + wildcards.part, wildcards.sample + "_" + wildcards.part, samples['platform'][wildcards.sample])
try:
    _rg_information_function = rg_information_function
except:
    pass

rule bwa_mem:
    input:
        reads=_bwa_mem_input
    output:
        _bwa_mem_output
    log:
        _bwa_mem_log
    benchmark:
        _bwa_mem_benchmark
    threads: 16
    params:
        index=config['reference_genome'],
        extra=lambda wildcards: r"-M -R " + _rg_information_function(wildcards) + " " + config.get("bwa_extra_settings", ""),
        sort="samtools",
        sort_order="coordinate",
        sort_extra="-@ 8"
    wrapper:
        "0.35.1/bio/bwa/mem"
