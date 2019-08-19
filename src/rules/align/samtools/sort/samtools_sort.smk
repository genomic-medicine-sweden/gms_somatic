# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Hassan Foroughi Asl, Patrik Smeds"
__copyright__ = "Copyright 2019, Hassan Foroughi Asl, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

_samtools_sort_input = "alignment/{sample}.{part}.bam"
try:
    _samtools_sort_input = _samtools_sort_input
except:
    pass

_samtools_sort_output = "alignment/{sample}.{part}.sorted.bam"
try:
    _samtools_sort_output = samtools_sort_output
except:
    pass

_samtools_sort_log = "logs/samtools/sort/{sample}.{part}.log"
try:
    _samtools_sort_log = samtools_sort_log
except:
    pass

_samtools_sort_benchmark = "benchmark/samtools/sort/{sample}.{part}.tsv"
try:
    _samtools_sort_benchmark = samtools_sort_benchmark
except:
    pass

_samtools_sort_message = "Running samtools sort on {{sample}}.{{part}}.bam"
try:
    _samtools_sort_message = samtools_sort_message
except:
    pass

rule samtools_sort:
    input:
        _samtools_sort_input
    output:
        _samtools_sort_output
    log:
        _samtools_sort_log
    benchmark:
        _samtools_sort_benchmark
    message:
        _samtools_sort_message
    params: ""
    threads: 4
    wrapper: "0.27.1/bio/samtools/sort"
