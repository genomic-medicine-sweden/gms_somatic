import pandas as pd

configfile: "config.yaml"

samples = pd.read_table(config["samples"], index_col="sample")
units = pd.read_table(config["units"], index_col=["sample", "unit"], dtype=str)
units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])

singularity: config.get("singularity_image","")

rule all:
    input:
        ["alignment/" + sample.Index + ".L001.collapsed" + str(config["num_support"]) + "." + type for sample in samples.itertuples() for type in ["bam", "bai", "stats"]] +
        ["alignment/" + sample.Index + ".L001.umiAnnoBam." + type for sample in samples.itertuples() for type in ["bam", "bai", "stats"]]

include: "src/workflows/basic_workflow_umi.smk"

onsuccess:
    print("Workflow finished, no error")
    if config["notification_mail"]:
        shell("mail -s \"Basic workflow completed! \" " + config["notification_mail"] + " < {log}")

onerror:
    print("An error occurred")
    if config["notification_mail"]:
        shell("mail -s \"an error occurred\" " + config["notification_mail"] + " < {log}")
