# gms_somatic workflow

A snakemake repository that can be used for GMS collaborations.

# workflows

## basice workflows

An example of a simple workflow that will perform trimming, alignment and stats generation.

### How to run
Setup (see exmaple_files):
- Create a samples.tsv file
- Create units.tsv file
- create/setup config.yaml file


#### Regular data
```bash
virtualenv -p python3 venv
source venv/bin/activate
# Install python dependencies
pip install -r path/gms_somatic/requirements.txt
# Build singularity image with required softwares
singularity build basic.simg basic.def
# Run snakemake

snakemake -j 128 \
  -s /path/projects/software/gms_somatic/basic.Snakefile \
  --directory /path/projects/gms_project \
  --use-singularity --singularity-args "--bind /data --bind /path  "
```

#### UMI
```bash
virtualenv -p python3 venv
source venv/bin/activate
# Install python dependencies
pip install -r path/gms_somatic/requirements.txt
# Build singularity image with required softwares
singularity build basic.umi.simg basic.umi.def
# Run snakemake

snakemake -j 128 \
  -s /path/projects/software/gms_somatic/basic.Snakefile \
  --directory /path/projects/gms_project \
  --use-singularity --singularity-args "--bind /data --bind /path  "
```
