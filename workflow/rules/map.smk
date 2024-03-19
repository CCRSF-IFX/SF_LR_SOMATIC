# Mapping reads to the genome for both tumor and normal samples

rule minimap2:
    input:
        lambda wildcards: get_sample_path(wildcards.sample_type, wildcards.sample_id)
    output:
        temp("mapped/{sample_type}_{sample_id}/{sample_id}.sam")
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    threads: 36
    log:
        "logs/{sample_type}_{sample_id}_map.log"
    params:
        ref=config[config['reference']]['ref']
    conda:
        "envs/minimap2.yaml"
    shell:
        """
        minimap2 -t {threads} -ax map-ont {params.ref} {input} > {output} 2> {log}
        """

# Sorting and indexing the mapped reads for both tumor and normal samples

rule sort:
    input:
        "mapped/{sample_type}_{sample_id}/{sample_id}.sam"
    output:
        file1 = temp("sorted/{sample_type}_{sample_id}/{sample_id}.bam"), 
        file2 = "sorted/{sample_type}_{sample_id}/{sample_id}.sorted.bam"
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    threads: 36
    log:
        "logs/{sample_type}_{sample_id}_sort.log"
    conda:
        "envs/samtools.yaml"
    shell:
        """
        samtools view -S -b {input} > {output.file1}
        samtools sort -o {output.file2} -@ {threads} {output.file1}
        samtools index {output.file2}
        """
