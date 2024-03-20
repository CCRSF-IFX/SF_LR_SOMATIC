# Running ClairS for variant calling on sorted BAM files for tumor-normal pairs

rule run_clairs:
    input:
        tumor_bam = "sorted/tumor_{sample_id}/{sample_id}.sorted.bam",
        normal_bam = "sorted/normal_{sample_id}/{sample_id}.sorted.bam"
    output:
        vcf = "clairs/tumor_{sample_id}/{sample_id}_clairs.vcf"
    log:
        "logs/tumor_{sample_id}_clairs.log"
    params:
        ref = config[config['reference']]['ref'],
        output_dir = lambda wildcards: "clairs/tumor_{sample_id}".format(sample_id=wildcards.sample_id),
        platform = "ont_r10"
    threads: 36
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    singularity: 
        "docker://hkubal/clairs:latest"
    shell:
        """
        mkdir -p {params.output_dir}
        module load singularity
        singularity exec -B $(dirname {input.tumor_bam}):/data -B $(dirname {input.normal_bam}):/data -B {params.ref}:/ref {singularity} \
        /opt/bin/run_clairs \
        --threads {threads} \
        --phase_tumor True \
        --whatshap_for_phasing True \
        --tumor_bam_fn /data/{wildcards.sample_id}.sorted.bam \
        --normal_bam_fn /data/{wildcards.sample_id}.sorted.bam \
        --ref_fn /ref/hg38.fa \
        --output_dir {params.output_dir} \
        --platform {params.platform}
        """
