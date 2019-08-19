# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Hassan Foroughi Asl, Patrik Smeds"
__copyright__ = "Copyright 2019, Hassan Foroughi Asl, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

_samtools_stats_input = "alignment/{sample}.{part}.bam"
try:
    _samtools_stats_input = _samtools_stats_input
except:
    pass

_samtools_stats_output = "alignment/{sample}.{part}.stats"
try:
    _samtools_stats_output = samtools_stats_output
except:
    pass

_samtools_stats_log = "logs/samtools/stats/{sample}.{part}.stats.log"
try:
    _samtools_stats_log = samtools_stats_log
except:
    pass

_samtools_stats_benchmark = "benchmark/samtools/stats/{sample}.{part}.stats.tsv"
try:
    _samtools_stats_benchmark = samtools_stats_benchmark
except:
    pass

_samtools_stats_message = "Running samtools stats on {{sample}}.{{part}}.bam"
try:
    _samtools_stats_message = samtools_stats_message
except:
    pass

rule samtools_stats:
    input:
        _samtools_stats_input
    output:
        _samtools_stats_output
    log:
        _samtools_stats_log
    benchmark:
        _samtools_stats_benchmark
    message:
        _samtools_stats_message
    params: ""
    threads: 4
    wrapper: "0.27.1/bio/samtools/stats"
