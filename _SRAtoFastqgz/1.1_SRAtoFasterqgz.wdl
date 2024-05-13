version 1.0
task ExtractFASTQ {
    input {
        File sra_file
        File sratoolkit_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/sratoolkit.3.1.0-ubuntu64(1).tar.gz" 
        String sample
        String memory = "8 GB"
        # Disk space in GB
        String disk_space = "300 GB"
        # Number of cpus per cellranger job
        Int cpu = 8
    }

    command {
        set -e
        sample=$(echo "~{sample}" | sed 's/\./_/g')
        mkdir -p sratoolkit
        tar -xzf ~{sratoolkit_tar_gz} -C sratoolkit --strip-components 1
        export PATH=$(pwd)/sratoolkit/bin:$PATH

        python3 <<CODE
        import os
        from subprocess import check_call

        sra_file = "~{sra_file}"
        cpu = ~{cpu}
        call_args = [
            'fasterq-dump',
            '--split-files',
            '-e', str(cpu),
            sra_file
        ]
        print('Executing:', ' '.join(call_args))
        check_call(call_args)
        CODE

    }

    output {
        Array[File] fastq_files = glob("*.fastq")
    }


    runtime {
        docker: "python:3.9.19-slim-bullseye"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}


task rename_fastq_files_based_on_size {
  input {
    Array[File] fastq_file_paths
    String sample
    String disk_space
    Int cpu = 4 
  }

    command <<<
        sample=$(echo "~{sample}" | sed 's/\./_/g')
        python3 <<CODE
        import os
        import shutil
    
        # Convert file paths from WDL array to Python list
        files = ["~{sep='", "' fastq_file_paths}"]
        sample = "~{sample}"
    
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
        i1_new_filename = f"{sample}_S1_L001_I1_001.fastq" if i1_file else None
        r1_new_filename = f"{sample}_S1_L001_R1_001.fastq"
        r2_new_filename = f"{sample}_S1_L001_R2_001.fastq"
    
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
        
        apt-get update && apt-get install -y pigz
        
        for fastq in *.fastq; do
            pigz -p 4 "$fastq"
        done
    >>>

  output {
    Array[File] renamed_fastq_files = glob("./*_L001_*_001.fastq.gz")
    String sample_out = sample
  }

  runtime {
    docker: "python:3.9.19-slim-bullseye"
    cpu: cpu
    disk: disk_space
  }
}




workflow ProcessSRA {
    input {
        File sra_file
        File sratoolkit_tar_gz  = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/sratoolkit.3.1.0-ubuntu64(1).tar.gz" 
        String sample
        String memory = "8 GB"
        String disk_space = "300 GB"
        Int cpu = 8
    }

    call ExtractFASTQ {
        input:
            sra_file = sra_file,
            sratoolkit_tar_gz = sratoolkit_tar_gz,
            sample = sample,
            cpu = cpu,
            memory = memory,
            disk_space = disk_space
    }

    call rename_fastq_files_based_on_size {
        input:
            fastq_file_paths = ExtractFASTQ.fastq_files,
            sample = sample,
            disk_space = disk_space,
            cpu = cpu
    }

    output {
        Array[File] gz_fastq_files = rename_fastq_files_based_on_size.renamed_fastq_files
    }
}
