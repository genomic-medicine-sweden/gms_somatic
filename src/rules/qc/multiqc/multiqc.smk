# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__="Joel Ås"
__email__ = "joel.as@medsci.uu.se"

import sys
sys.path.insert(0,"src/lib/util/")
from wf_functions import get_expected_output

_qc_rules_to_run = config["QC_rules"]
_sample = {"sample": config["samples"]}
_run = config["ID"]


rule multiqc:
    input: get_expected_output(rules, _qc_rules_to_run, _sample)
    output: "QC/MultiQC/multiqc_{}.html".format(_run)
    params: ""
    log: "logs/MultiQC/multiqc_{}.log".format(_run)
    wrapper: "0.35.1/bio/multiqc"
