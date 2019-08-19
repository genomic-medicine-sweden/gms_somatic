# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Hassan Foroughi Asl, Patrik Smeds"
__copyright__ = "Copyright 2019, Hassan Foroughi Asl, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

_samtools_index_input = "alignment/{sample}.{part}.bam"
try:
    _samtools_index_input = _samtools_index_input
except:
    pass

_samtools_index_output = "alignment/{sample}.{part}.bai"
try:
    _samtools_index_output = samtools_index_output
except:
    pass

_samtools_index_log = "logs/samtools/index/{sample}.{part}.log"
try:
    _samtools_index_log = samtools_index_log
except:
    pass

_samtools_index_benchmark = "benchmark/samtools/index/{sample}.{part}.tsv"
try:
    _samtools_index_benchmark = samtools_index_benchmark
except:
    pass

_samtools_index_message = "Running samtools index on {{sample}}.{{part}}.bam"
try:
    _samtools_index_message = samtools_index_message
except:
    pass

rule samtools_index:
    input:
        _samtools_index_input
    output:
        _samtools_index_output
    log:
        _samtools_index_log
    benchmark:
        _samtools_index_benchmark
    message:
        _samtools_index_message
    params: ""
    threads: 4
    wrapper: "0.27.1/bio/samtools/index"
