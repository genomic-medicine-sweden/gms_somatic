# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__="Patrik Smeds"
__copyright__ = "Copyright 2019, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

_extract_umis_read_head_input = "fastq/{sample}.{part}.{read}.fastq.gz"
try:
    _extract_umis_read_head_input = extract_umis_read_head_input
except:
    pass

_extract_umis_read_head_output = "umis/{sample}.{part}.{read}.UMIs%s.fastq" % config["umi_length"]
try:
    _extract_umis_read_head_output = extract_umis_read_head_output
except:
    pass

_extract_umis_read_head_log = "logs/fastq/{sample}.{part}.{read}.UMIs%s.fastq.txt" % config['umi_length']
try:
    _extract_umis_read_head_log = headcrop_read_log
except:
    pass

_extract_umis_read_head_benchmark = "benchmark/umi/extract_head/{sample}.{part}.{read}.UMIs%s.tsv" % config['umi_length']
try:
    _extract_umis_read_head_benchmark = extract_umis_read_head_benchmark
except:
    pass

rule extract_umis_read_head:
    input:
       _extract_umis_read_head_input
    output:
       _extract_umis_read_head_output
    params:
      trimmer=["CROP:%s" % config["umi_length"]],
       extra=""
    threads: 8
    wrapper:
       "0.31.1/bio/trimmomatic/se"
