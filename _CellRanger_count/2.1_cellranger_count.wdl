version 1.0
#########################################
# Modified WDL File for CellRanger
# Incorporates external CellRanger tar.gz
#########################################

task run_cellranger_count {
    input {
        Array[File] fastq_file_paths
        File reference_genome_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz"
        String run_id
        String sample
        String memory = "225 GB"
        String disk_space = "300 GB"
        Int cpu = 8
        String chemistry = "auto"
        String no_bam = "False"
        String secondary = "False"
        # New input for CellRanger software package tar.gz
        File cellranger_tar_gz
    }

    command {
        set -e

        # Unpack the CellRanger software to a local directory
        mkdir cellranger
        tar -zxf ${cellranger_tar_gz} -C cellranger --strip-components 1
        # Set PATH to include CellRanger binaries
        export PATH=$(pwd)/cellranger:$PATH

        # Unpack the reference genome
        mkdir transcriptome_dir
        tar xf ${reference_genome_tar_gz} -C transcriptome_dir --strip-components 1

        python3 <<CODE
        import os
        from subprocess import check_call
    
        # Convert the WDL Array[File] input to a Python list
        fastq_file_paths = ["${sep='","' fastq_file_paths}"]
        fastq_dirs = set([os.path.dirname(f) for f in fastq_file_paths])
        print(fastq_dirs)
    
        call_args = ['cellranger']
        call_args.append('count')
        call_args += ['--jobmode=local',
                      '--transcriptome=transcriptome_dir',
                      '--id=' + "~{run_id}",
                      '--sample=' + "~{sample}",
                      '--fastqs=' + ','.join(list(fastq_dirs))]
        if "~{chemistry}" != 'auto':
            call_args += ['--chemistry=' + "~{chemistry}"]
        if '~{no_bam}' == 'True':
            call_args.append('--no-bam')
        if '~{secondary}' != 'True':
            call_args.append('--nosecondary')
        call_args.append('--disable-ui')
        print('Executing:', ' '.join(call_args))
        check_call(call_args)
        CODE

        tar -czvf ~{run_id}_outs.tar.gz ~{run_id}/outs
    }

    output {
        File output_count_directory = "~{run_id}_outs.tar.gz"
        File output_metrics_summary = "~{run_id}/outs/metrics_summary.csv"
        File output_web_summary = "~{run_id}/outs/web_summary.html"
    }

    runtime {
        docker: "python:3.9.19-slim-bullseye"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}
