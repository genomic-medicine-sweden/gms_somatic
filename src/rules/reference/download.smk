# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Sarath Murugan"


REF_GENOME_LINK = "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/hg19.fa.gz"
TH_GENOME_LINK = "https://storage.googleapis.com/gatk-legacy-bundles/b37/1000G_phase3_v4_20130502.sites.vcf.gz"
DBSNP_LINK = "https://storage.googleapis.com/gatk-legacy-bundles/b37/dbsnp_138.b37.vcf.gz"

REF_GENOME = "reference/genome/Homo_sapiens_hg19.fasta"
TH_GENOME = "reference/variants/1KG_phase3_v4_sites.vcf.gz"
DBSNP = "reference/variants/dbsnp_138_b37.vcf.gz"

rule download_reference:
	params:
		_ref_genome_link = REF_GENOME_LINK, 
		_dbsnp_link = DBSNP_LINK, 
		_th_genome_link = TH_GENOME_LINK
	output:
		_ref_genome = REF_GENOME,
		_dbsnp = DBSNP,
		_th_genome = TH_GENOME
	shell:
		"wget {params._ref_genome_link} -O {output._ref_genome}.gz; gunzip {output._ref_genome}.gz;"
		"wget {params._dbsnp_link} -O {output._dbsnp};"
		"wget {params._th_genome_link} -O {output._th_genome};"

