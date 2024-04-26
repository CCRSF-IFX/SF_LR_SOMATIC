# Longread Somatic Analysis Pipeline

This pipeline processes longread sequencing data to identify somatic mutations using various bioinformatics tools. The workflow is defined using Snakemake, ensuring reproducibility and scalability.

## Workflow Overview

The pipeline integrates several bioinformatics tools to process samples from raw sequencing data to somatic variant calling and analysis. Key steps include mapping with Minimap2, sorting BAM files, quality control with Qualimap and NanoPlot, variant calling with ClairS, variant annotation with VEP, somatic structure variant (SV) calling, and somatic copy number alteration (CNA) analysis.

![SF_LR_Somatic](/resources/Diagram.PNG)

### Workflow Details

The pipeline is designed to take longread sequencing data through a comprehensive analysis to identify and characterize somatic mutations, including single nucleotide variants (SNVs), structural variants (SVs), and copy number alterations (CNAs). Below is a breakdown of the critical stages in the pipeline:

#### Mapping with Minimap2
- **Purpose**: Aligns raw sequencing reads to a reference genome. This step is crucial for identifying the genomic locations of the reads.
- **Tool**: Minimap2 is a fast sequence alignment program designed to handle long reads (e.g., from PacBio or Oxford Nanopore technologies).

#### Sorting BAM Files
- **Purpose**: Sorts the aligned reads in the BAM files by their genomic coordinates. Sorting is necessary for many downstream analyses, including variant calling.
- **Tool**: This step is performed using Samtools, which can efficiently sort and index BAM files.

#### Quality Control with Qualimap and NanoPlot
- **Purpose**: Assesses the quality of the sequencing and alignment. Quality control metrics help identify potential issues with sequencing runs or alignment processes.
- **Tools**:
  - Qualimap provides detailed statistics about alignment quality, coverage, and other essential metrics.
  - NanoPlot generates graphical summaries of sequencing quality, offering insights into the distribution of read lengths, quality scores, and more.

#### Variant Calling with ClairS
- **Purpose**: Identifies somatic variants from the aligned reads, focusing on mutations that occur in cancer cells.
- **Tool**: ClairS is a variant caller designed for high accuracy in detecting single nucleotide variants (SNVs) and indels from sequencing data.

#### Variant Annotation with VEP
- **Purpose**: Enriches variant calls with information on their potential effects on genes, proteins, and disease phenotypes. This step is crucial for interpreting the functional impact of identified variants.
- **Tool**: The Variant Effect Predictor (VEP) annotates detected variants with data from multiple databases, providing insights into their biological significance.

#### Somatic Structural Variant (SV) Calling
- **Purpose**: Detects larger genomic rearrangements such as deletions, duplications, inversions, and translocations that can play significant roles in cancer development.
- **Tool**: Severus analyze the alignments for patterns indicative of somatic structural variations.

#### Somatic Copy Number Alteration (CNA) Analysis
- **Purpose**: Identifies changes in the number of copies of genomic regions, which are common in cancer genomes and can indicate regions of amplification or deletion associated with oncogenes or tumor suppressor genes.
- **Tool**: Wakhan can perform somatic CNA analysis, offering insights into the genomic gains and losses across the cancer genome.

### Conclusion

By integrating these bioinformatics tools and steps, the pipeline provides a comprehensive analysis of somatic mutations from long read sequencing data, enabling researchers to understand the genetic alterations driving cancer and potentially identify targets for therapy.

## Configuration

Modify the `config/config.yaml` and `config/sample_sheet.csv` to specify your samples and analysis parameters.

## Output

The pipeline produces the following key outputs:

- Sorted BAM files
- Quality control reports from Qualimap and NanoPlot
- Somatic variants in VCF format annotated with VEP
- Somatic structure variants results
- Somatic copy number alteration (CNA) analysis results

## Contact
CCRSF_IFX@nih.gov
