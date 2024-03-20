rule deepvariant_normal:
    input:
        ref="path/to/ref.fa",
        normal_bam="sorted/normal_{sample_id}/{sample_id}.sorted.bam"
    output:
        vcf="vcfs/normal_{sample_id}/normal_{sample_id}.vcf"
    threads: 36
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    conda:
        "envs/deepvariant.yaml"
    shell:
        """
        run_deepvariant \
          --model_type=ONT \
          --ref={input.ref} \
          --reads={input.normal_bam} \
          --output_vcf={output.vcf} \
          --num_shards=36
        """

rule margin_phase_normal:
    input:
        normal_bam="sorted/normal_{sample_id}/{sample_id}.sorted.bam",
        ref="path/to/ref.fa",
        vcf="vcfs/normal_{sample_id}/normal_{sample_id}.vcf"
    output:
        phased_vcf="phased/normal_{sample_id}/phased_normal_{sample_id}.vcf",
        phased_bam="phased/normal_{sample_id}/phased_normal_{sample_id}.bam"
    threads: 36
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    singularity:
        "docker://kishwars/pepper_deepvariant:latest"
    shell:
        """
        margin phase {input.normal_bam} {input.ref} {input.vcf} \
        allParams.haplotag.ont-r104q20.json -t {threads} \
        -o {output.phased_vcf} \
        -r {output.phased_bam}
        """

rule haplotag_normal:
    input:
        phased_vcf="phased/normal_{sample_id}/phased_normal_{sample_id}.vcf",
        normal_bam="sorted/normal_{sample_id}/{sample_id}.sorted.bam",
        ref="path/to/ref.fa"
    output:
        haplotagged_bam="haplotagged/normal_{sample_id}/haplotagged_normal_{sample_id}.bam"
    conda:
        "envs/whatshap.yaml"
    shell:
        """
        whatshap haplotag \
        --reference {input.ref} \
        --output {output.haplotagged_bam} \
        --ignore-read-groups \
        {input.phased_vcf} {input.normal_bam}
        """

rule haplotag_tumor:
    input:
        phased_vcf="phased/normal_{sample_id}/phased_normal_{sample_id}.vcf",
        tumor_bam="sorted/tumor_{sample_id}/{sample_id}.sorted.bam",
        ref="path/to/ref.fa"
    output:
        haplotagged_bam="haplotagged/tumor_{sample_id}/haplotagged_tumor_{sample_id}.bam"
    conda:
        "envs/whatshap.yaml"
    shell:
        """
        whatshap haplotag \
        --reference {input.ref} \
        --output {output.haplotagged_bam} \
        --ignore-read-groups \
        {input.phased_vcf} {input.tumor_bam}
        """

rule run_severus:
    input:
        tumor_bam="haplotagged/tumor_{sample_id}/haplotagged_tumor_{sample_id}.bam",
        normal_bam="haplotagged/normal_{sample_id}/haplotagged_normal_{sample_id}.bam",
        phased_vcf="phased/normal_{sample_id}/phased_normal_{sample_id}.vcf",
        vntr_bed="vntrs/human_GRCh38_no_alt_analysis_set.trf.bed"  # Adjust this path as necessary
    output:
        sv_vcf="severus/tumor_{sample_id}/tumor_{sample_id}_severus_sv.vcf"
    params:
        out_dir=lambda wildcards: "severus/tumor_{sample_id}".format(sample_id=wildcards.sample_id)
    threads: 16
    conda:
        "envs/severus.yaml"
    shell:
        """
        severus --target-bam {input.tumor_bam} \
                --control-bam {input.normal_bam} \
                --out-dir {params.out_dir} \
                -t {threads} \
                --phasing-vcf {input.phased_vcf} \
                --vntr-bed {input.vntr_bed}
        """
