from snakemake.utils import validate
import pandas as pd

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

# Path to the sample sheet
SAMPLE_SHEET = "config/sample_sheet.csv"

# Read the sample sheet into a DataFrame
sample_sheet = pd.read_csv(SAMPLE_SHEET)

# Ensure that the sample sheet has the correct columns
assert 'Tumor Sample ID' in sample_sheet.columns, "Sample sheet missing 'Tumor Sample ID'"
assert 'Tumor Sample Path' in sample_sheet.columns, "Sample sheet missing 'Tumor Sample Path'"
assert 'Normal Sample ID' in sample_sheet.columns, "Sample sheet missing 'Normal Sample ID'"
assert 'Normal Sample Path' in sample_sheet.columns, "Sample sheet missing 'Normal Sample Path'"

# Creating dictionaries for sample paths to be accessed by sample IDs
tumor_sample_paths = dict(zip(sample_sheet['Tumor Sample ID'], sample_sheet['Tumor Sample Path']))
normal_sample_paths = dict(zip(sample_sheet['Normal Sample ID'], sample_sheet['Normal Sample Path']))

# Sample types (tumor and normal)
SAMPLE_TYPES = ['tumor', 'normal']

# Combine tumor and normal samples into a single dictionary for easier handling
samples = {
    'tumor': tumor_sample_paths,
    'normal': normal_sample_paths,
}

# List of all sample IDs, assuming unique IDs across tumor and normal
SAMPLES = list(set(sample_sheet['Tumor Sample ID']).union(set(sample_sheet['Normal Sample ID'])))

# Function to get the sample path based on sample type and ID
def get_sample_path(sample_type, sample_id):
    return samples[sample_type][sample_id]
