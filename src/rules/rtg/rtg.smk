# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Vilma Canfjorden, Alvar Almstedt"

configfile: "config.yaml"
# Input BAM files.
bam_files=expand("{sample}", sample=config["bam"])

# Load rtg-core module.
import socket
if "medair" in socket.gethostname():
	shell.executable("/bin/bash")
	shell.prefix("module load rtg/v3.10-5604f7a; ")

rule all:
	input:
		"rtg_coverage_results"

# Create reference SDF using a fasta file.
rule reference:
	input:
		sdf=config["sdf"]
	output:
		outsdf=directory("sdf.reference")
	shell:
		"rtg format {input.sdf} -o {output.outsdf}"

# Runs rtg core coverage with a bed file to get specific regions. 
rule rtg:
	input:
		ref="sdf.reference",
		bed=config["bed"] 
	output:
		out=directory("rtg_coverage_results")
	shell:
		"rtg coverage {bam_files} -t {input.ref} --bed-regions {input.bed} -o {output.out}"
