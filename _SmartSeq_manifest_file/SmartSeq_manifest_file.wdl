version 1.0

task generate_sample_tsv {
    input {
        Array[File] fastq_files
        String output_filename
        String disk_space
    }

    command <<<
        python3 <<CODE
        import os

        # Get the sorted list of files
        files = sorted("~{sep=' ' fastq_files}".split())
        output_filename = "~{output_filename}"

        with open(output_filename, 'w') as tsv_file:
            tsv_file.write("read1\tread2\tCell_ID\n")
            
            # Check if the number of files is odd
            if len(files) % 2 != 0:
                print("Warning: The number of input files is odd, expecting pairs of files.")

            # Iterate through the list in steps of 2
            for i in range(0, len(files) - 1, 2):
                R1 = files[i]
                R2 = files[i + 1]
                SRR_id = os.path.basename(R1).split('_')[-2]
                
                # Ensure that R1 and R2 have the same SRR_id
                if os.path.basename(R2).split('_')[-2] != SRR_id:
                    print(f"Mismatched pair detected: {R1} and {R2}")
                    continue  # Skip this pair and log an error or handle appropriately
                
                # Write to TSV file using proper formatting
                tsv_file.write(f"{R1}\t{R2}\t{SRR_id}\n")

        CODE
    >>>


    output {
        File sample_tsv = "~{output_filename}"
    }

    runtime {
        docker: "python:3.9.19-slim-bullseye"
        memory: "2 GB"
        cpu: "1"
        disk: disk_space
    }
}

workflow process_smart_seq2 {
    input {
        Array[File] fastq_files
        String output_filename = "samples.tsv"
        String disk_space = "1 GB"
    }

    call generate_sample_tsv {
        input:
            fastq_files = fastq_files,
            output_filename = output_filename,
            disk_space = disk_space
    }

    output {
        File samples_tsv = generate_sample_tsv.sample_tsv
    }
}
