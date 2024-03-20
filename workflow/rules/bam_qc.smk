# BAM QC rules

rule qualimap:
    input: "sorted/{sample_type}_{sample_id}/{sample_id}.sorted.bam"
    output: "qualimap/{sample_type}_{sample_id}/qualimapReport.html"
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    threads: 36
    log: "logs/{sample_type}_{sample_id}_qualimap.log"
    params: fname = "qualimap/{sample_type}_{sample_id}/qualimap"
    conda: "envs/qualimap.yaml"
    shell: "unset DISPLAY; qualimap bamqc --java-mem-size=400G -bam {input} -c -gd HUMAN -nw 5000 -nt 36 -outdir {params.fname} 2>{log}"

rule nanoplot2:
    input: "sorted/{sample_type}_{sample_id}/{sample_id}.sorted.bam"
    output: "nanoplot_bam/{sample_type}_{sample_id}/{sample_id}Non_weightedHistogramReadlength.png"
    resources:
        mem_mb=config['mem_lg'], 
        time=config['time'], 
        partition=config['partition']
    threads: 12
    log: "log/{sample_type}_{sample_id}/{sample_id}_nanoplot.log"
    params: out = "nanoplot/{sample_type}_{sample_id}/nanoplot_bam", sample = "{sample_id}"
    conda: "envs/nanoplot.yaml"
    shell: "mkdir -p {params.out}; nanoplot -t 12 -o {params.out} --prefix {params.sample} --N50 --bam {input} --plots kde 2>{log}"
    