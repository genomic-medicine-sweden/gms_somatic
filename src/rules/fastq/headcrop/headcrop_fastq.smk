# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__="Patrik Smeds"
__copyright__ = "Copyright 2019, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

_headcrop_fastq_input = "fastq/{sample}.{part}.{read}.fastq.gz"
try:
    _headcrop_fastq_input = headcrop_fastq_input
except:
    pass

_headcrop_fastq_output = "fastq/{sample}.{part}.{read}.headcrop%s.fastq.gz" % config['headcrop_num_bases']
try:
    _headcrop_fastq_output = headcrop_fastq_output
except:
    pass

_headcrop_fastq_log = "logs/fastq/{sample}.{part}.{read}.headcrop%s.txt" % config['headcrop_num_bases']
try:
    _headcrop_fastq_log = headcrop_fastq_log
except:
    pass

_headcrop_fastq_benchmark = "benchmark/fastq/{sample}.{part}.{read}headcrop%s.tsv"  % config['headcrop_num_bases']
try:
    _headcrop_fastq_benchmark = headcrop_fastq_benchmark
except:
    pass

rule headcrop_read:
    input:
        _headcrop_fastq_input
    output:
        _headcrop_fastq_output
    log:
        _headcrop_fastq_log
    benchmark:
        _headcrop_fastq_benchmark
    params:
        trimmer= lambda wildcards: [ "HEADCROP:%s" %  config['headcrop_num_bases']],
        extra=""
    threads: 8
    wrapper:
        "0.31.1/bio/trimmomatic/se"
