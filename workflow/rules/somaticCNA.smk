# SomaticCNA, aka Wakhan

rule somatic_cna:
    input:
        tumor_bam="haplotagged/tumor_{sample_id}/haplotagged_tumor_{sample_id}.bam",
        tumor_vcf="vcfs/tumor_{sample_id}/tumor_{sample_id}.vcf.gz"
        phased_vcf="phased/normal_{sample_id}/phased_normal_{sample_id}.vcf.gz"
    output:
        plots_dir="somatic_cna_plot/tumor_{sample_id}/"
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    threads: 36
    params:
        genome_name=lambda wildcards: "tumor_{sample_id}".format(sample_id=wildcards.sample_id),
        out_dir_plots=lambda wildcards: "somatic_cna_plot/tumor_{sample_id}/".format(sample_id=wildcards.sample_id),
        somatic_cna_script="/mnt/Software/tools/SomaticCNA/src/main.py",
        ref=config[config['reference']]['ref']
    conda:
        "envs/somatic_cna.yaml"
    shell:
        """
        python {params.somatic_cna_script} \
        --threads {threads} \
        --reference {params.ref} \
        --target-bam {input.tumor_bam} \
        --tumor-vcf {input.tumor_vcf}
        --normal-phased-vcf {input.phased_vcf} \    
    	--smoothing-enable True \
	    --copynumbers-enable True  \
	    --unphased-reads-coverage-enable True \
	    --phaseblock-flipping-enable True  \
	    --cut-threshold 150 \
        --out-dir-plots {params.out_dir_plots} \
        --genome-name {params.genome_name} \
        --phaseblocks-enable True \
        --breakpoints-enable True \
        --phased-vcf-snps-freqs True
        """
        