rule somatic_cna:
    input:
        tumor_bam="haplotagged/tumor_{sample_id}/haplotagged_tumor_{sample_id}.bam",
        phased_vcf="phased/normal_{sample_id}/phased_normal_{sample_id}.vcf"
    output:
        plots_dir="somatic_cna_plot/tumor_{sample_id}/"
    params:
        genome_name=lambda wildcards: "tumor_{sample_id}".format(sample_id=wildcards.sample_id),
        out_dir_plots=lambda wildcards: "somatic_cna_plot/tumor_{sample_id}/".format(sample_id=wildcards.sample_id),
        somatic_cna_script="/mnt/ccrsf-ifx/Software/tools/SomaticCNA/src/main.py"
    conda:
        "envs/somatic_cna.yaml"
    shell:
        """
        module load samtools
        module load bcftools

        python {params.somatic_cna_script} \
        --target-bam {input.tumor_bam} \
        --out-dir-plots {params.out_dir_plots} \
        --genome-name {params.genome_name} \
        --phased-vcf {input.phased_vcf} \
        --phaseblock-flipping-enable True \
        --smoothing-enable True \
        --phaseblocks-enable True \
        --breakpoints-enable True \
        --phased-vcf-snps-freqs True
        """
        