# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__="Patrik Smeds"
__copyright__ = "Copyright 2019, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "MIT"

_annotate_bam_with_umi_input_bam = "alignment/{sample}.{part}.bam"
try:
    _annotate_bam_with_umi_input_bam = annotate_bam_with_umi_input_bam
except:
    pass

_annotate_bam_with_umi_input_umi = "umis/{sample}.{part}.combinedR1R2.UMIs%s.fastq" % config['umi_length']
try:
    _annotate_bam_with_umi_input_umi = annotate_bam_with_umi_input_umi
except:
    pass

_annotate_bam_with_umi_output = "alignment/{sample}.{part}.umiAnnoBam.bam"
try:
  _annotate_bam_with_umi_output = annotate_bam_with_umi_output
except:
    pass

_annotate_bam_with_umi_log = "logs/umis/{sample}.{part}.R1R2.fgbioAnnoBam.txt"
try:
    _annotate_bam_with_umi_log = annotate_bam_with_umi_log
except:
    pass

_annotate_bam_with_umi_benchmark = "benchmark/umi/annotatebam/{sample}.{part}.R1R2.UMIs%s.tsv" % config['umi_length']
try:
    _annotate_bam_with_umi_benchmark = annotate_bam_with_umi_benchmark
except:
    pass

rule annotate_bam_with_umi:
    input:
        bam=_annotate_bam_with_umi_input_bam,
        umi=_annotate_bam_with_umi_input_umi
    output:
        bam=_annotate_bam_with_umi_output
    log:
        _annotate_bam_with_umi_log
    benchmark:
        _annotate_bam_with_umi_benchmark
    wrapper:
        "0.31.1/bio/fgbio/annotatebamwithumis"
