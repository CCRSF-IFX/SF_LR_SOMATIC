# VariantQC 

def get_vtext_clairs(samples):
    analysis_folder = os.getcwd()
    v_text_clairs = ""
    for sample_id in samples:
        v_text_clairs += f" -V:{sample_id} {analysis_folder}/clairs/tumor_{sample_id}/{sample_id}_clairs.vcf"
    return v_text_clairs

rule variantqc_clairs:
    input:
        clairs = expand("clairs/tumor_{sample_id}/{sample_id}_clairs.vcf", sample_id=SAMPLES),
        ref = config['reference']['path']
    output:
        out_clairs = "VariantQC/clairs_variantqc.html"
    resources:
        mem_mb=config['mem_md'],
        time=config['time'],
        partition=config['partition']
    threads: 8
    log:
        "logs/variantqc_clairs.log"
    singularity:
        "docker://ghcr.io/bimberlab/discvrseq"
    params:
        vtexts_clairs = lambda wildcards: get_vtext_clairs(SAMPLES)
    shell:
        """
        VariantQC -R {input.ref} {params.vtexts_clairs} -O {output.out_clairs}
        """
