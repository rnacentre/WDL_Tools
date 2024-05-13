version 1.0
task ExtractFASTQ {
    input {
        File sra_file
        File sratoolkit_tar_gz
        String sample
        String memory
        # Disk space in GB
        String disk_space
        # Number of cpus per cellranger job
        Int cpu
        String lane
    }
    command <<<
        set -e
        sample=$(echo "~{sample}" | sed 's/\./_/g')
        mkdir -p sratoolkit
        tar -xzf ~{sratoolkit_tar_gz} -C sratoolkit --strip-components 1
        export PATH=$(pwd)/sratoolkit/bin:$PATH
        sample=$(echo "~{sample}" | sed 's/\./_/g')
        lane="~{lane}" # Ensure this is correctly set
        python3 <<CODE
        import os
        import subprocess
        from subprocess import check_call
        import shutil
        import glob
        import re
        sra_file = "~{sra_file}"
        sample = "~{sample}"
        lane = "~{lane}"
        cpu = ~{cpu}
        call_args = [
            'fasterq-dump',
            '--split-3',
            '-e', str(cpu),
            sra_file
        ]
        print('Executing:', ' '.join(call_args))
        check_call(call_args)
        # Prepare to rename files
        files = glob.glob('*.fastq')
        # Extract suffixes and sort files
        file_suffixes = {re.search('_(\d)\.fastq', f).group(1): f for f in files if re.search('_(\d)\.fastq', f)}
        # Initialize variables to hold file paths
        i1_file, i2_file, r1_file, r2_file = None, None, None, None
        if '1' in file_suffixes:
            i1_file = file_suffixes['1']
        if '2' in file_suffixes:
            i2_file = file_suffixes['2']
        if '3' in file_suffixes:
            r1_file = file_suffixes['3']
        if '4' in file_suffixes:
            r2_file = file_suffixes['4']
        # Define new filenames and list to compress
        new_filenames = []
        if i1_file:
            i1_new_filename = f"{sample}_S1_{lane}_I1_001.fastq"
            shutil.copy2(i1_file, i1_new_filename)
            new_filenames.append(i1_new_filename)
        if i2_file:
            i2_new_filename = f"{sample}_S1_{lane}_I2_001.fastq"
            shutil.copy2(i2_file, i2_new_filename)
            new_filenames.append(i2_new_filename)
        if r1_file:
            r1_new_filename = f"{sample}_S1_{lane}_R1_001.fastq"
            shutil.copy2(r1_file, r1_new_filename)
            new_filenames.append(r1_new_filename)
        if r2_file:
            r2_new_filename = f"{sample}_S1_{lane}_R2_001.fastq"
            shutil.copy2(r2_file, r2_new_filename)
            new_filenames.append(r2_new_filename)
        # Compress only new files
        for fastq in new_filenames:
            command = ['pigz', '-p', str(cpu), fastq]
            subprocess.check_call(command)
            print(f"Successfully compressed: {fastq}")
        CODE
        ls -l
        ls ./
        pwd
    >>>

    output {
        Array[File] fastq_files = glob("./*.fastq.gz")
        String sample_out = sample
    }
    runtime {
        docker: "ooaahhdocker/python_pigz:1.0"
        cpu: cpu
        memory: memory
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
        String lane = "L001"
    }
    call ExtractFASTQ {
        input:
            sra_file = sra_file,
            sratoolkit_tar_gz = sratoolkit_tar_gz,
            sample = sample,
            cpu = cpu,
            memory = memory,
            disk_space = disk_space,
            lane = lane
    }
    output {
        Array[File] fastq_files = ExtractFASTQ.fastq_files
    }
}
