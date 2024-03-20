#VEP
if config['reference'] = "hg38": 
    vep_params = "--offline --force_overwrite --everything --hgvs --hgvsg --check_existing --fork 4 --cache --cache_version 98 --dir_cache /mnt/RefGenomes/Variant_annotation/VEP --species homo_sapiens --assembly GRCh38"
    vep_species = "homo_sapiens" 
    vep_assembly = "GRCh38"
    vep_fasta = "/mnt/Variant_annotation/VEP/homo_sapiens/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"

rule vep:
    input: clairs = "clairs/tumor_{sample_id}/{sample_id}_clairs.vcf"
    output: cs = "clairs/tumor_{sample_id}/{sample_id}_clairs.vep.vcf"
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    threads: 8
    log: "logs/tumor_{sample_id}_clairs_vep.log"
    conda: "envs/vep.yaml"
    shell: "vep {vep_params} --species {vep_species} --assembly {vep_assembly} --fasta {vep_fasta} --vcf -i {input.clairs} -o {output.cs}"