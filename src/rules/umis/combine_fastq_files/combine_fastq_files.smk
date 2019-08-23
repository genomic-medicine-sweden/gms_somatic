# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__="Patrik Smeds"
__copyright__ = "Copyright 2019, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

combine_fastq_files_input_r1 = "umis/{sample}.{part}.R1.UMIs%s.fastq" % config["umi_length"]
try:
    _combine_fastq_files_input_r1 = combine_fastq_files_input_r1
except:
    pass

combine_fastq_files_input_r2 = "umis/{sample}.{part}.R2.UMIs%s.fastq" % config["umi_length"]
try:
    _combine_fastq_files_input_r2 = combine_fastq_files_input_r2
except:
    pass

_combine_fastq_files_output = "umis/{sample}.{part}.combinedR1R2.UMIs%s.fastq" % config["umi_length"]
try:
    _combine_fastq_files_output = combine_fastq_files_output
except:
    pass

_combine_fastq_files_log = "logs/umis/merge/{sample}.{part}.R1R2.UMIs%s.fastq.txt" % config['umi_length']
try:
    _combine_fastq_files_log = combine_fastq_files_log
except:
    pass

_combine_fastq_files_benchmark = "benchmark/umis/merge/{sample}.{part}.R1R2.UMIs%s.tsv" % config['umi_length']
try:
    _combine_fastq_files_benchmark = combine_fastq_files_benchmark
except:
    pass

rule combine_fastq_files:
    input:
       r1=combine_fastq_files_input_r1,
       r2=combine_fastq_files_input_r2
    output:
       _combine_fastq_files_output
    log:
        _combine_fastq_files_log
    benchmark:
        _combine_fastq_files_benchmark
    threads: 1
    shell:
       "paste {input.r1} {input.r2} | awk '{{print($1\" 3:N:0:1\");getline;print($1$2);getline;print($1);getline;print($1$2)}}' > {output}"
