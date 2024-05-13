version 1.0

task rename_fastq_files_based_on_size {
  input {
    Array[File] fastq_file_paths
    String sample_name
    String disk_space = "150 GB"
    Int cpu = 1 
  }

  command <<<
    python3 <<CODE
    import os
    import shutil

    # Convert file paths from WDL array to Python list
    files = ["~{sep='", "' fastq_file_paths}"]
    sample_name = "~{sample_name}"

    # Calculate file sizes and sort them
    file_sizes = [(f, os.path.getsize(f)) for f in files]
    file_sizes.sort(key=lambda x: x[1])

    # Initialize variables to hold file paths
    i1_file, r1_file, r2_file = None, None, None

    # Determine the number of files and assign accordingly
    if len(files) == 2:
        r1_file, r2_file = file_sizes[0][0], file_sizes[1][0]
    elif len(files) == 3:
        i1_file, r1_file, r2_file = file_sizes[0][0], file_sizes[1][0], file_sizes[2][0]

    # Define new filenames
    i1_new_filename = f"{sample_name}_S1_L001_I1_001.fastq.gz" if i1_file else None
    r1_new_filename = f"{sample_name}_S1_L001_R1_001.fastq.gz"
    r2_new_filename = f"{sample_name}_S1_L001_R2_001.fastq.gz"

    # Copy and rename files
    if i1_file:
        shutil.copy2(i1_file, i1_new_filename)
    shutil.copy2(r1_file, r1_new_filename)
    shutil.copy2(r2_file, r2_new_filename)

    # Output new filenames for verification
    if i1_new_filename:
        print(i1_new_filename)
    print(r1_new_filename)
    print(r2_new_filename)
    CODE
  >>>

  output {
    Array[File] renamed_fastq_files = glob("./*_L001_*_001.fastq.gz")
    String sample_name_out = sample_name
  }

  runtime {
    docker: "python:3.9.19-slim-bullseye"
    cpu: cpu
    disk: disk_space
  }
}

workflow example_workflow {
  input {
    Array[File] fastq_file_paths
    String sample_name
    String disk_space = "150 GB"
    Int cpu = 1
  }

  call rename_fastq_files_based_on_size {
    input:
      fastq_file_paths = fastq_file_paths,
      sample_name = sample_name,
      disk_space = disk_space,
      cpu = cpu
  }

  output {
    Array[File] renamed_files = rename_fastq_files_based_on_size.renamed_fastq_files
    String sample_name_out = rename_fastq_files_based_on_size.sample_name_out
  }
}
